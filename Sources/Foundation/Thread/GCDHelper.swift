
import Foundation

class GCDHelper: MainThreadCompletable {

    func wrapInMainThread<T>(_ closure: ((T) -> ())?) -> (T) -> () {
        let closure = nonnullClosure(closure)
        guard !Thread.isMainThread else { return closure }
        return { argument in
            DispatchQueue.main.async {
                closure(argument)
            }
        }
    }

    private func nonnullClosure<T>(_ closure: ((T) -> ())?) -> (T) -> () {
        return { argument in
            closure?(argument)
        }
    }
}
