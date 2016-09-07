//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

class XCSDeleteBotRequest: XCSRequest {

    let network: Network

    init(network: Network) {
        self.network = network
    }

    func createRequest(data: String) -> HTTPRequest {
        return HTTPRequest(url: endpoint + "bots/" + data, method: .delete, jsonBody: nil)
    }

    func parse(response data: NSData) -> Void? {
        return ()
    }
}
