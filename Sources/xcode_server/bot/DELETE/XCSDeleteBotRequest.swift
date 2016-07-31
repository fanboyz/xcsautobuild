//
//  XCSDeleteBotRequest.swift
//
//
//

import Foundation

class XCSDeleteBotRequest: XCSRequest {

    let network: Network

    init(network: Network) {
        self.network = network
    }

    func createRequest(data: String) -> HTTPRequest {
        return HTTPRequest(url: endpoint + "bot/" + data, method: .delete, jsonBody: nil)
    }

    func parse(response data: NSData) -> Void? {
        return ()
    }
}
