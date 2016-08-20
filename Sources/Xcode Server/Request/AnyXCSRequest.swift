//
//  AnyXCSRequest.swift
//
//
//

import Foundation

class AnyXCSRequest<RequestDataType, ResponseType>: XCSRequest {

    var network: Network { return _networkGetter() }
    private let _send: (RequestDataType, (ResponseType?) -> ()) -> ()
    private let _networkGetter: (() -> (Network))
    private let _createRequest: (RequestDataType) -> (HTTPRequest)
    private let _parse: (NSData) -> (ResponseType?)

    init<T: XCSRequest where T.RequestDataType == RequestDataType, T.ResponseType == ResponseType>(_ request: T) {
        _send = request.send
        _networkGetter = { return request.network }
        _createRequest = request.createRequest
        _parse = request.parse
    }

    func createRequest(data: RequestDataType) -> HTTPRequest {
        return _createRequest(data)
    }

    func parse(response data: NSData) -> ResponseType? {
        return _parse(data)
    }

    func send(data: RequestDataType, completion: (ResponseType?) -> ()) {
        _send(data, completion)
    }
}
