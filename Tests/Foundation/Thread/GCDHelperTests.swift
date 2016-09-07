//
//  Copyright (c) 2016 Sean Henry
//

import XCTest
@testable import xcsautobuild

class GCDHelperTests: XCTestCase {
    
    var helper: GCDHelper!
    
    override func setUp() {
        super.setUp()
        helper = GCDHelper()
    }
    
    // MARK: - wrapInMainThread
    
    func test_wrapInMainThread_shouldReturnInstantly_whenAlreadyOnTheMainThread() {
        var didComplete = false
        wrapInMainThread {
            didComplete = true
        }
        XCTAssert(didComplete)
    }

    func test_wrapInMainThread_shouldCompleteAsyncOnTheMainThread_whenOnAnotherThread() {
        var didComplete = false
        wrapInMainThreadAsync {
            didComplete = true
        }
        XCTAssertFalse(didComplete)
        waitForOneLoop()
        XCTAssert(didComplete)
    }

    func test_wrapInMainThread_shouldHandleNil() {
        let closure: (() -> ())? = nil
        _ = helper.wrapInMainThread(closure)
    }

    func test_wrapInMainThread_shouldHandleNilWithArguments() {
        let closure: ((String, Int) -> ())? = nil
        _ = helper.wrapInMainThread(closure)
    }

    func test_wrapInMainThread_shouldHandleClosureWithArgument() {
        var invokedString = ""
        let closure: (String) -> () = { string in
            invokedString = string
        }
        helper.wrapInMainThread(closure)("testing")
        XCTAssertEqual(invokedString, "testing")
    }

    func test_wrapInMainThread_shouldHandleClosureWithArguments() {
        var invokedString = ""
        var invokedInt = 0
        let closure: (String, Int) -> () = { string, int in
            invokedString = string
            invokedInt = int
        }
        helper.wrapInMainThread(closure)("testing", 123)
        XCTAssertEqual(invokedString, "testing")
        XCTAssertEqual(invokedInt, 123)
    }

    // MARK: - Helpers

    func wrapInMainThread(closure: () -> ()) {
        helper.wrapInMainThread(closure)()
    }

    func wrapInMainThreadAsync(closure: () -> ()) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            self.helper.wrapInMainThread(closure)()
        }
    }

    func waitForOneLoop() {
        let expectation = expectationWithDescription(#function)
        NSOperationQueue.mainQueue().addOperationWithBlock {
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(5, handler: nil)
    }
}
