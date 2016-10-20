//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

class XCSGetBotRequest: XCSRequest {

    let network: Network

    init(network: Network) {
        self.network = network
    }

    func createRequest(_ data: String) -> HTTPRequest {
        return HTTPRequest(path: "/bots/\(data)", method: .get, jsonBody: nil)
    }

    func parse(response data: Data) -> Data? {
        return data
    }
}
