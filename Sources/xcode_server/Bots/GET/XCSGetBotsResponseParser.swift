//
//  XCSGetBotsResponseParser.swift
//
//
//

import Foundation

class XCSGetBotsResponseParser {

    func parse(response data: NSData) -> [RemoteBot] {
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
