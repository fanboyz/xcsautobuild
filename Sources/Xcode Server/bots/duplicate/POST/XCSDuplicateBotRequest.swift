
import Foundation
import FlexiJSON

class XCSDuplicateBotRequest: XCSRequest {

    let requestSender: HTTPRequestSender

    init(requestSender: HTTPRequestSender) {
        self.requestSender = requestSender
    }

    func createRequest(_ data: DuplicateBotRequestData) -> HTTPRequest {
        return HTTPRequest(path: "/bots/\(data.id)/duplicate", method: .post, jsonBody: ["name": data.name])
    }

    func parse(response data: Data) -> String? {
        return FlexiJSON(data: data)["_id"].string
    }
}
