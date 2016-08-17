//
//  XCSRequest.swift
//
//
//

import Foundation

protocol XCSRequest: class {
    associatedtype RequestDataType
    associatedtype ResponseType
    var network: Network { get }
    var endpoint: String { get }
    func createRequest(data: RequestDataType) -> HTTPRequest
    func send(data: RequestDataType, completion: (ResponseType?) -> ())
    func send(data: RequestDataType) -> ResponseType?
    func parse(response data: NSData) -> ResponseType?
}

extension XCSRequest {

    var endpoint: String {
        return "https://seans-macbook-pro-2.local:20343/api/"
    }

    func send(data: RequestDataType, completion: (ResponseType?) -> ()) {
        network.send(createRequest(data)) { [weak self] data in
            let parsed = self?.parse(response: data)
            completion(parsed)
        }
    }

    func send(data: RequestDataType) -> ResponseType? {
        var response: ResponseType?
        let semaphore = dispatch_semaphore_create(0)
        send(data) { r in
            response = r
            dispatch_semaphore_signal(semaphore)
        }
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        return response
    }
}
