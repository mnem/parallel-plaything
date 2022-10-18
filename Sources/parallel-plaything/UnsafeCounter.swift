import Foundation

final class UnsafeCounter {
    private(set) var count = 0

    func increment() {
        count += 1
    }
}

extension UnsafeCounter: Incrementable, Countable {}
