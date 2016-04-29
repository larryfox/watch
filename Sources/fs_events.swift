import Foundation

struct FSEvent {
    let path: String
    let flags: FSEventFlag
    let id: UInt64
}

class FSEventStream: Sequence {
    let paths: [String]
    let events = Chan<[FSEvent]>()
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

    func makeIterator() -> AnyIterator<[FSEvent]> {
        return events.makeIterator()
    }

    private func watch() {
        var context = FSEventStreamContext(
            version: 0,
            info: UnsafeMutablePointer(unsafeAddress(of: self)),
            retain: nil,
            release: nil,
            copyDescription: nil)

        let flags = FSWatchFlag.UseCFTypes
            .union(FSWatchFlag.FileEvents)
            .union(FSWatchFlag.IgnoreSelf)
            .union(FSWatchFlag.NoDefer)
            .rawValue

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

        var events = [FSEvent]()

        for index in 0..<eventCount {
            let flag = FSEventFlag(rawValue: eventFlags[index])
            let event = FSEvent(path: paths[index], flags: flag, id: eventIDs[index])
            events.append(event)
        }

        let `self` = unsafeBitCast(context, to: FSEventStream.self)
        self.events <- events
    }
}

