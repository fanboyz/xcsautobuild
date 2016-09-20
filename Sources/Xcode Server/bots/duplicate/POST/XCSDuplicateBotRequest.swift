//
// Created by Sean Henry on 20/09/2016.
//

import Foundation

class XCSDuplicateBotRequest: XCSRequest {

    let network: Network

    init(network: Network) {
        self.network = network
    }

    func createRequest(data: DuplicateBotRequestData) -> HTTPRequest {
        return HTTPRequest(url: endpoint + "bots/\(data.id)/duplicate", method: .post, jsonBody: ["name": data.name])
    }

    func parse(response data: NSData) -> String? {
        return FlexiJSON(data: data)["_id"].string
    }
}
