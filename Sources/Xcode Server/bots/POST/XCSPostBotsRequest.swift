//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

class XCSPostBotsRequest: XCSRequest {

    let network: Network

    init(network: Network) {
        self.network = network
    }

    func createRequest(data: [String: AnyObject]) -> HTTPRequest {
        return HTTPRequest(url: endpoint + "bots", method: .post, jsonBody: data)
    }

    func parse(response data: NSData) -> Void? {
        return ()
    }
}
