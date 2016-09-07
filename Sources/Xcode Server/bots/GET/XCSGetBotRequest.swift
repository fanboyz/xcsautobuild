//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

class XCSGetBotRequest: XCSRequest {

    let network: Network

    init(network: Network) {
        self.network = network
    }

    func createRequest(data: String) -> HTTPRequest {
        let url = endpoint + "bots/" + data
        return HTTPRequest(url: url, method: .get, jsonBody: nil)
    }

    func parse(response data: NSData) -> NSData? {
        return data
    }
}
