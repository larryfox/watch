import Foundation

struct FSEvent {
    let paths: [String]
    let flags: [FSFlag]
    let ids: [UInt64]
}

class FSEvents: Sequence {
    let paths: [String]
    let events = Chan<FSEvent>()
    private var stream: FSEventStreamRef!

    init(paths: [String]) {
        self.paths = paths
        go(self.watch())
    }

    deinit {
        guard let stream = self.stream else { return }

        FSEventStreamStop(stream)
        FSEventStreamInvalidate(stream)
        FSEventStreamRelease(stream)
        self.stream = nil
    }

    func makeIterator() -> AnyIterator<FSEvent> {
        return events.makeIterator()
    }

    private func watch() {
        var context = FSEventStreamContext(
            version: 0,
            info: UnsafeMutablePointer(unsafeAddress(of: self)),
            retain: nil,
            release: nil,
            copyDescription: nil
        )

        let flags = UInt32(kFSEventStreamCreateFlagUseCFTypes |
            kFSEventStreamCreateFlagFileEvents |
            kFSEventStreamCreateFlagIgnoreSelf |
            kFSEventStreamCreateFlagNoDefer)

        self.stream = FSEventStreamCreate(kCFAllocatorDefault,
            streamCallback,
            &context,
            paths,
            FSEventStreamEventId(kFSEventStreamEventIdSinceNow),
            2.0,
            flags)

        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        FSEventStreamSetDispatchQueue(stream, queue)
        FSEventStreamStart(stream)
    }

    private let streamCallback: FSEventStreamCallback = { (
                stream: ConstFSEventStreamRef,
                context: UnsafeMutablePointer?,
                eventCount: Int,
                eventPaths: UnsafeMutablePointer,
                eventFlags: UnsafePointer<FSEventStreamEventFlags>!,
                eventIDs: UnsafePointer<FSEventStreamEventId>!
            ) in

        guard let paths = unsafeBitCast(eventPaths, to: NSArray.self) as? [String]
            else { return }

        var flags = [FSFlag]()
        var ids = [UInt64]()
        for index in 0..<eventCount {
            flags.append(FSFlag(rawValue: eventFlags[index]))
            ids.append(eventIDs[index])
        }

        let `self` = unsafeBitCast(context, to: FSEvents.self)
        self.events <- FSEvent(paths: paths, flags: flags, ids: ids)
    }
}

