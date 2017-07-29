import Foundation

// Probably a terrible implementation of channels
// You’ve been warned

class Chan<T>: Sequence {
    convenience init(_ buffer: Int) { self.init(buffer: buffer) }

    init(buffer: Int = 0) {
        guard buffer >= 0 else { fatalError("invalid buffer argument") }

        self.pressure = DispatchSemaphore.init(value: buffer + 1)
        self.buffer = DispatchSemaphore.init(value: buffer)
    }

    private var values = Array<T>()
    private let sent = DispatchSemaphore.init(value: 0)
    private let lock = DispatchSemaphore.init(value: 1)
    private let buffer: DispatchSemaphore
    private let pressure: DispatchSemaphore

    func send(_ value: T) {
        // Block until there’s room in the buffer
        pressure.wait()

        // Wait for the lock
        lock.wait()
        values.append(value)
        lock.signal()

        // Let any waiting recievers know we’ve sent
        sent.signal()

        // Block if we just filled the buffer
        buffer.wait()
    }

    func receive() -> T? {
        // Block until a value has been sent
        sent.wait()

        // Wait for the lock
        lock.wait()
        let value = values.removeFirst()
        lock.signal()

        // Let any waiting senders know we’ve taken a value
        pressure.signal()
        buffer.signal()

        return value
    }

    // Implement the Sequence protocol
    func makeIterator() -> AnyIterator<T> {
        return AnyIterator<T> { <~self }
    }
}

precedencegroup ChanPrecedence {
    associativity: left
}

// Send to channel
infix operator <- : ChanPrecedence
func <-<T> (c: Chan<T>, value: T) { c.send(value) }

// Recieve from channel
prefix operator <-
prefix func <-<T> (c: Chan<T>) -> T! { return c.receive() }

// Recieve optional from channel
prefix operator <~
prefix func <~<T> (c: Chan<T>) -> T? { return c.receive() }
