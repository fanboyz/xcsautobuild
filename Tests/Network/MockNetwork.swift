//
//  Copyright (c) 2016 Sean Henry
//

import XCTest
@testable import xcsautobuild

class MockNetwork: Network {

    var didSendRequest = false
    var invokedRequest: HTTPRequest?
    var stubbedResponse: Data?
    var stubbedStatusCode: Int?
    func send(_ request: HTTPRequest, completion: ((Data?, Int?) -> ())?) {
        didSendRequest = true
        invokedRequest = request
        completion?(stubbedResponse, stubbedStatusCode)
    }
}
