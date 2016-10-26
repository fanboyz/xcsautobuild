
import Foundation

protocol XCSRequest: class {
    associatedtype RequestDataType
    associatedtype ResponseType
    var requestSender: HTTPRequestSender { get }
    func createRequest(_ data: RequestDataType) -> HTTPRequest
    func send(_ data: RequestDataType, completion: @escaping (XCSResponse<ResponseType>?) -> ())
    func send(_ data: RequestDataType) -> XCSResponse<ResponseType>?
    func parse(response data: Data) -> ResponseType?
}

extension XCSRequest {

    func send(_ data: RequestDataType, completion: @escaping (XCSResponse<ResponseType>?) -> ()) {
        requestSender.send(createRequest(data)) { [weak self] data, statusCode in
            completion(self?.parseResponse(fromData: data, statusCode: statusCode))
        }
    }

    func send(_ data: RequestDataType) -> XCSResponse<ResponseType>? {
        var response: XCSResponse<ResponseType>?
        let semaphore = DispatchSemaphore(value: 0)
        send(data) { r in
            response = r
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return response
    }

    private func parseResponse(fromData data: Data?, statusCode: Int?) -> XCSResponse<ResponseType>? {
        guard let data = data,
              let statusCode = statusCode,
              let parsed = parse(response: data) else { return nil }
        return XCSResponse(data: parsed, statusCode: statusCode)
    }
}
