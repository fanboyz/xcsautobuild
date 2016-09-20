//
// Created by Sean Henry on 20/09/2016.
//

import Foundation

class XCSDuplicateBotRequest: XCSRequest {

    let network: Network

    init(network: Network) {
        self.network = network
    }

    func createRequest(data: String) -> HTTPRequest {
        return HTTPRequest(url: endpoint + "bots/\(data)/duplicate", method: .post, jsonBody: nil)
    }

    func parse(response data: NSData) -> String? {
        return FlexiJSON(data: data)["_id"].string
    }
}
