//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

class XCSGetBotsRequest: XCSRequest {

    let network: Network

    init(network: Network) {
        self.network = network
    }

    func createRequest(data: Void) -> HTTPRequest {
        return HTTPRequest(url: endpoint + "bots", method: .get, jsonBody: nil)
    }

    func parse(response data: NSData) -> [RemoteBot]? {
        return FlexiJSON(data: data)["results"].flatMap(toBot)
    }

    private func toBot(json: FlexiJSON) -> RemoteBot? {
        if let id = json["_id"].string,
            let name = json["name"].string {
            return RemoteBot(id: id, name: name)
        }
        return nil
    }
}
