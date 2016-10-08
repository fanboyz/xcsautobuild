//
//  Copyright (c) 2016 Sean Henry
//

import XCTest
@testable import xcsautobuild

class MockMainThreadCompletable: MainThreadCompletable {

    var didWrapInMainThread = false
    var didCompleteOnMainThread = false
    func wrapInMainThread<T>(_ closure: ((T) -> ())?) -> (T) -> () {
        didWrapInMainThread = true
        return { arguments in
            self.didCompleteOnMainThread = closure != nil
            closure?(arguments)
        }
    }
}
