
import Foundation

class AnyXCSRequest<RequestDataType, ResponseType>: XCSRequest {

    var network: HTTPRequestSender { return _networkGetter() }
    private let _send: (RequestDataType, @escaping (XCSResponse<ResponseType>?) -> ()) -> ()
    private let _networkGetter: (() -> (HTTPRequestSender))
    private let _createRequest: (RequestDataType) -> (HTTPRequest)
    private let _parse: (Data) -> (ResponseType?)

    init<T: XCSRequest>(_ request: T) where T.RequestDataType == RequestDataType, T.ResponseType == ResponseType {
        _send = request.send
        _networkGetter = { return request.network }
        _createRequest = request.createRequest
        _parse = request.parse
    }

    func createRequest(_ data: RequestDataType) -> HTTPRequest {
        return _createRequest(data)
    }

    func parse(response data: Data) -> ResponseType? {
        return _parse(data)
    }

    func send(_ data: RequestDataType, completion: @escaping (XCSResponse<ResponseType>?) -> ()) {
        _send(data, completion)
    }
}
