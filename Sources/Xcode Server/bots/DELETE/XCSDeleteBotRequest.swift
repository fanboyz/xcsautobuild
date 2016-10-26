
import Foundation

class XCSDeleteBotRequest: XCSRequest {

    let requestSender: HTTPRequestSender

    init(requestSender: HTTPRequestSender) {
        self.requestSender = requestSender
    }

    func createRequest(_ data: String) -> HTTPRequest {
        return HTTPRequest(path: "/bots/" + data, method: .delete, jsonBody: nil)
    }

    func parse(response data: Data) -> Void? {
        return ()
    }
}
