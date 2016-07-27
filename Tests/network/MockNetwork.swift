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
    func sendRequest(request: HTTPRequest) {
        didSendRequest = true
        invokedRequest = request
    }
}
