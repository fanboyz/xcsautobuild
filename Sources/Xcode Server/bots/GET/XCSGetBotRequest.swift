
import Foundation

class XCSGetBotRequest: XCSRequest {

    let network: HTTPRequestSender

    init(network: HTTPRequestSender) {
        self.network = network
    }

    func createRequest(_ data: String) -> HTTPRequest {
        return HTTPRequest(path: "/bots/\(data)", method: .get, jsonBody: nil)
    }

    func parse(response data: Data) -> Data? {
        return data
    }
}
