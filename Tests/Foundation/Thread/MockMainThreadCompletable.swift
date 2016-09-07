//
//  MockMainThreadCompletable.swift
//
//
//

import XCTest
@testable import xcsautobuild

class MockMainThreadCompletable: MainThreadCompletable {

    var didWrapInMainThread = false
    var didCompleteOnMainThread = false
    func wrapInMainThread<T>(closure: ((T) -> ())?) -> (T) -> () {
        didWrapInMainThread = true
        return { arguments in
            self.didCompleteOnMainThread = closure != nil
            closure?(arguments)
        }
    }
}