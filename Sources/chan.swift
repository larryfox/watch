import Foundation

// Probably a terrible implementation of channels
// You’ve been warned

class Chan<T>: Sequence {
    convenience init(_ buffer: Int) { self.init(buffer: buffer) }

    init(buffer: Int = 0) {
        guard buffer >= 0 else { fatalError("invalid buffer argument") }

        self.pressure = dispatch_semaphore_create(buffer + 1)
        self.buffer = dispatch_semaphore_create(buffer)
    }

    private var values = Array<T>()
    private let sent = dispatch_semaphore_create(0)
    private let lock = dispatch_semaphore_create(1)
    private let buffer: dispatch_semaphore_t
    private let pressure: dispatch_semaphore_t

    private func send(_ value: T) {
        // Block until there’s room in the buffer
        dispatch_semaphore_wait(pressure, DISPATCH_TIME_FOREVER)

        // Wait for the lock
        dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER)
        values.append(value)
        dispatch_semaphore_signal(lock)

        // Let any waiting recievers know we’ve sent
        dispatch_semaphore_signal(sent)

        // Block if we just filled the buffer
        dispatch_semaphore_wait(buffer, DISPATCH_TIME_FOREVER)
    }

    private func receive() -> T? {
        // Block until a value has been sent
        dispatch_semaphore_wait(sent, DISPATCH_TIME_FOREVER)

        // Wait for the lock
        dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER)
        let value = values.removeFirst()
        dispatch_semaphore_signal(lock)

        // Let any waiting senders know we’ve taken a value
        dispatch_semaphore_signal(pressure)
        dispatch_semaphore_signal(buffer)

        return value
    }

    // Implement the Sequence protocol
    func makeIterator() -> AnyIterator<T> {
        return AnyIterator<T> { <~self }
    }
}

// Send to channel
infix operator <- { associativity left }
func <-<T> (c: Chan<T>, value: T) { c.send(value) }

// Recieve from channel
prefix operator <- {}
prefix func <-<T> (c: Chan<T>) -> T! { return c.receive() }

// Recieve optional from channel
prefix operator <~ {}
prefix func <~<T> (c: Chan<T>) -> T? { return c.receive() }
