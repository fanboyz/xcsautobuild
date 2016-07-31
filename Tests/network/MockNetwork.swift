//
//  MockNetwork.swift
//
//
//

import XCTest
@testable import xcsautobuild

class MockNetwork: Network {

    var didSendRequest = false
    var invokedRequest: HTTPRequest?
    var stubbedResponse = NSData()
    func sendRequest(request: HTTPRequest) {
        didSendRequest = true
        invokedRequest = request
    }

    func sendRequest(request: HTTPRequest, completion: (NSData) -> ()) {
        didSendRequest = true
        invokedRequest = request
        completion(stubbedResponse)
    }
}
