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

    func send(request: HTTPRequest, completion: ((NSData) -> ())?) {
        didSendRequest = true
        invokedRequest = request
        completion?(stubbedResponse)
    }
}
