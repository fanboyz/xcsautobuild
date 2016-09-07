//
//  MockNSURLSessionDataTask.swift
//
//
//

import Foundation

class MockNSURLSessionDataTask: NSURLSessionDataTask {

    var didResume = false
    override func resume() {
        didResume = true
    }
}
