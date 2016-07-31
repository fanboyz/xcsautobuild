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
}
