//
//  Copyright (c) 2016 Sean Henry
//

import XCTest
@testable import xcsautobuild

class MockXCSRequest<RequestDataType, ResponseType>: XCSRequest {

    var endpoint = "endpoint"
    var network: Network = MockNetwork()

    var didCreateRequest = false
    var stubbedRequest = HTTPRequest(url: "", method: .get, jsonBody: [:])
    var invokedData: RequestDataType?
    func createRequest(data: RequestDataType) -> HTTPRequest {
        didCreateRequest = true
        invokedData = data
        return stubbedRequest
    }

    var didParse = false
    var stubbedResponse: XCSResponse<ResponseType>?
    func parse(response data: NSData) -> ResponseType? {
        didParse = true
        return stubbedResponse?.data
    }

    var didSend = false
    var didSendCount = 0
    func send(data: RequestDataType, completion: (XCSResponse<ResponseType>?) -> ()) {
        didSend = true
        didSendCount += 1
        invokedData = data
        completion(stubbedResponse)
    }

    func send(data: RequestDataType) -> XCSResponse<ResponseType>? {
        didSend = true
        didSendCount += 1
        invokedData = data
        return stubbedResponse
    }
}
