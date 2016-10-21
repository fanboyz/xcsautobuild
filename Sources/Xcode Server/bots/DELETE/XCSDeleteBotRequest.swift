
import Foundation

class XCSDeleteBotRequest: XCSRequest {

    let network: HTTPRequestSender

    init(network: HTTPRequestSender) {
        self.network = network
    }

    func createRequest(_ data: String) -> HTTPRequest {
        return HTTPRequest(path: "/bots/" + data, method: .delete, jsonBody: nil)
    }

    func parse(response data: Data) -> Void? {
        return ()
    }
}
