//
//  XCSPostBotsRequest.swift
//
//
//

import Foundation

class XCSPostBotsRequest: XCSRequest {

    let network: Network

    init(network: Network) {
        self.network = network
    }

    func createRequest(data: Bot) -> HTTPRequest {
        return HTTPRequest(url: endpoint + "bots", method: .post, jsonBody: data.toJSON())
    }

    func parse(response data: NSData) -> Void? {
        return ()
    }
}
