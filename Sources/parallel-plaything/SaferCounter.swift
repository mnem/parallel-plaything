import Foundation

final class SaferCounter {
    private let lock = NSLock()
    private(set) var count = 0

    func increment() {
        lock.lock()
        defer {
            lock.unlock()
        }
        count += 1
    }
}

extension SaferCounter: Incrementable, Countable {}
