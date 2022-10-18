import Foundation

@main
public struct parallel_plaything {
    public static func main() async {
        await Self().go()
    }
}

extension parallel_plaything {
    private func go() async {
        await go(UnsafeCounter())
        await go(SaferCounter())
        await go(SafeCounter())
    }
    
    func go<T>(_ counter: T) async where T: Incrementable & Countable {
        let name = String(describing: T.self)
        let time = await measure {
            await parallelRun {
                await counter.increment()
            }
        }
        print("\(name): \(await counter.count) (\(String(format:"%.4f", time))s)")
    }
}

extension parallel_plaything {
    private func measure(work: () async -> Void) async -> TimeInterval {
        let start = DispatchTime.now()
        await work()
        let end = DispatchTime.now()

        let durationNanoseconds = Double(end.uptimeNanoseconds - start.uptimeNanoseconds)
        return TimeInterval(durationNanoseconds / 1_000_000_000.00)
    }
    
    private func parallelRun(iterations: Int = 10_000, work: @escaping () async -> Void) async {
        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<iterations {
                group.addTask(priority: .high) {
                    await work()
                }
            }
            await group.waitForAll()
        }
    }
}

protocol Incrementable {
    func increment() async
}

protocol Countable {
    var count: Int { get async }
}
