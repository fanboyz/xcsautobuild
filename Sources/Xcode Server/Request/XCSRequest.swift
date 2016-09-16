//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

struct XCSResponse<ResponseType> {
    let data: ResponseType
    let statusCode: Int

    var isSuccess: Bool {
        return (200...299).contains(statusCode)
    }
}

protocol XCSRequest: class {
    associatedtype RequestDataType
    associatedtype ResponseType
    var network: Network { get }
    var endpoint: String { get }
    func createRequest(data: RequestDataType) -> HTTPRequest
    func send(data: RequestDataType, completion: (XCSResponse<ResponseType>?) -> ())
    func send(data: RequestDataType) -> XCSResponse<ResponseType>?
    func parse(response data: NSData) -> ResponseType?
}

extension XCSRequest {

    var endpoint: String {
        return "https://seans-macbook-pro-2.local:20343/api/"
    }

    func send(data: RequestDataType, completion: (XCSResponse<ResponseType>?) -> ()) {
        network.send(createRequest(data)) { [weak self] data, statusCode in
            completion(self?.parseResponse(fromData: data, statusCode: statusCode))
        }
    }

    func send(data: RequestDataType) -> XCSResponse<ResponseType>? {
        var response: XCSResponse<ResponseType>?
        let semaphore = dispatch_semaphore_create(0)
        send(data) { r in
            response = r
            dispatch_semaphore_signal(semaphore)
        }
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        return response
    }

    private func parseResponse(fromData data: NSData?, statusCode: Int?) -> XCSResponse<ResponseType>? {
        guard let data = data,
              let statusCode = statusCode,
              let parsed = parse(response: data) else { return nil }
        return XCSResponse(data: parsed, statusCode: statusCode)
    }
}
