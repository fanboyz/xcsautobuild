
import Foundation

class XCSGetBotRequest: XCSRequest {

    let requestSender: HTTPRequestSender

    init(requestSender: HTTPRequestSender) {
        self.requestSender = requestSender
    }

    func createRequest(_ data: String) -> HTTPRequest {
        return HTTPRequest(path: "/bots/\(data)", method: .get, jsonBody: nil)
    }

    func parse(response data: Data) -> Data? {
        return data
    }
}
