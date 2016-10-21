
import Foundation

protocol MainThreadCompletable {
    func wrapInMainThread<T>(_ closure: ((T) -> ())?) -> (T) -> ()
}
