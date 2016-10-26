
import Foundation

class AnyXCSRequest<RequestDataType, ResponseType>: XCSRequest {

    var requestSender: HTTPRequestSender { return _requestSenderGetter() }
    private let _send: (RequestDataType, @escaping (XCSResponse<ResponseType>?) -> ()) -> ()
    private let _requestSenderGetter: (() -> (HTTPRequestSender))
    private let _createRequest: (RequestDataType) -> (HTTPRequest)
    private let _parse: (Data) -> (ResponseType?)

    init<T: XCSRequest>(_ request: T) where T.RequestDataType == RequestDataType, T.ResponseType == ResponseType {
        _send = request.send
        _requestSenderGetter = { return request.requestSender }
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
