//
//  XCSPostBotsRequest.swift
//
//
//

import Foundation

class XCSPostBotsRequest: XCSRequest {

    private let template: [String: AnyObject]
    let network: Network

    init(template: [String: AnyObject], network: Network) {
        self.template = template
        self.network = network
    }

    func createRequest(data: Bot) -> HTTPRequest {
        return HTTPRequest(url: endpoint + "bots", method: .post, jsonBody: data.toJSON())
    }

    func parse(response data: NSData) -> Void? {
        return ()
    }
}
