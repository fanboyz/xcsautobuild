//
//  GCDHelper.swift
//
//
//

import Foundation

class GCDHelper: MainThreadCompletable {

    func wrapInMainThread<T>(closure: ((T) -> ())?) -> (T) -> () {
        let closure = nonnullClosure(closure)
        guard !NSThread.isMainThread() else { return closure }
        return { argument in
            dispatch_async(dispatch_get_main_queue()) {
                closure(argument)
            }
        }
    }

    private func nonnullClosure<T>(closure: ((T) -> ())?) -> (T) -> () {
        return { argument in
            closure?(argument)
        }
    }
}
