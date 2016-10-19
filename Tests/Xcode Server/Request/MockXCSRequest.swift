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
    func createRequest(_ data: RequestDataType) -> HTTPRequest {
        didCreateRequest = true
        invokedData = data
        return stubbedRequest
    }

    var didParse = false
    var stubbedResponse: XCSResponse<ResponseType>?
    var stubbedResponses = [XCSResponse<ResponseType>?]()
    func parse(response data: Data) -> ResponseType? {
        didParse = true
        return stubbedResponse?.data ?? popFirstResponse()?.data
    }

    var didSend = false
    var didSendCount = 0
    func send(_ data: RequestDataType, completion: @escaping (XCSResponse<ResponseType>?) -> ()) {
        didSend = true
        didSendCount += 1
        invokedData = data
        completion(stubbedResponse ?? popFirstResponse())
    }

    func send(_ data: RequestDataType) -> XCSResponse<ResponseType>? {
        didSend = true
        didSendCount += 1
        invokedData = data
        return stubbedResponse ?? popFirstResponse()
    }

    private func popFirstResponse() -> XCSResponse<ResponseType>? {
        guard stubbedResponses.count > 0 else { return nil }
        return stubbedResponses.removeFirst()
    }
}
