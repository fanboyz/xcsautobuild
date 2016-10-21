
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

    func wrapInMainThread(_ closure: @escaping () -> ()) {
        helper.wrapInMainThread(closure)()
    }

    func wrapInMainThreadAsync(_ closure: @escaping () -> ()) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
            self.helper.wrapInMainThread(closure)()
        }
    }

    func waitForOneLoop() {
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.05))
    }
}
