
import Foundation

class MockNSURLSessionDataTask: URLSessionDataTask {

    var didResume = false
    override func resume() {
        didResume = true
    }
}
