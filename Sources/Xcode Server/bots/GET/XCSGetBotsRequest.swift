//
//  Copyright (c) 2016 Sean Henry
//

import Foundation
import FlexiJSON

class XCSGetBotsRequest: XCSRequest {

    let network: Network

    init(network: Network) {
        self.network = network
    }

    func createRequest(_ data: Void) -> HTTPRequest {
        return HTTPRequest(path: "/bots", method: .get, jsonBody: nil)
    }

    func parse(response data: Data) -> [RemoteBot]? {
        return FlexiJSON(data: data)["results"].flatMap(toBot)
    }

    private func toBot(_ json: FlexiJSON) -> RemoteBot? {
        if let id = json["_id"].string,
            let name = json["name"].string {
            return RemoteBot(id: id, name: name)
        }
        return nil
    }
}
