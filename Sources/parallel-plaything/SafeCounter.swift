import Foundation

actor SafeCounter {
    private(set) var count = 0

    func increment() {
        count += 1
    }
}

extension SafeCounter: Incrementable, Countable {}
