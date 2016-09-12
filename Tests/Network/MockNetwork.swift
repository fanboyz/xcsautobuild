//
//  Copyright (c) 2016 Sean Henry
//

import XCTest
@testable import xcsautobuild

class MockNetwork: Network {

    var didSendRequest = false
    var invokedRequest: HTTPRequest?
    var stubbedResponse: NSData?
    var stubbedStatusCode: Int?
    func send(request: HTTPRequest, completion: ((NSData?, Int?) -> ())?) {
        didSendRequest = true
        invokedRequest = request
        completion?(stubbedResponse, stubbedStatusCode)
    }
}
