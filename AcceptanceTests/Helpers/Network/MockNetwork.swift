//
//  Copyright (c) 2016 Sean Henry
//

import Foundation
import OHHTTPStubs

class MockNetwork {

    deinit {
        OHHTTPStubs.removeAllStubs()
    }

    var duplicateBotCount = 0
    var invokedDuplicateBotResponse: Data?
    var stubbedDuplicatedBotID = "6139a72b95fdeec94b49ec0a1f00191a"
    func expectDuplicateBot(id: String) {
        stub(isHost(testHost) && isMethodPOST() && isPath("/api/bots/\(id)/duplicate")) { [unowned self] request in
            self.invokedDuplicateBotResponse = request.OHHTTPStubs_HTTPBody()
            self.duplicateBotCount += 1
            var json = FlexiJSON(data: load("bots_post_response", "json"))
            json["_id"] = FlexiJSON(string: self.stubbedDuplicatedBotID)
            return OHHTTPStubsResponse(data: json.data!, statusCode: 201, headers: nil)
        }
    }

    var deleteBotCount = 0
    func expectDeleteBot(id: String) {
        stub(isMethodDELETE() && isPath("/api/bots/\(id)")) { [unowned self] _ in
            self.deleteBotCount += 1
            return empty(204)
        }
    }

    func expectDeleteBotNotFound(id: String) {
        stub(isMethodDELETE() && isPath("/api/bots/\(id)")) { _ in
            return empty(404)
        }
    }

    func stubGetBots(withNames names: [String], ids: [String]) {
        stub(isHost(testHost) && isMethodGET() && isPath("/api/bots")) { _ -> OHHTTPStubsResponse in
            var json = FlexiJSON(data: load("bots_get_response", "json"))
            json["count"] = FlexiJSON(int: Int64(names.count))
            let template = json["results"][0]
            var array = [AnyObject]()
            for i in 0..<names.count {
                var bot = template
                bot["name"] = FlexiJSON(string: names[i])
                bot["_id"] = FlexiJSON(string: ids[i])
                array.append(bot.dictionary!)
            }
            json["results"] = FlexiJSON(array: array)
            return OHHTTPStubsResponse(data: json.data!, statusCode: 200, headers: nil)
        }
    }

    func stubGetBot(withID id: String, name: String) {
        stub(isHost(testHost) && isMethodGET() && isPath("/api/bots/\(id)")) { request in
            var json = FlexiJSON(data: load("bot_get_response", "json"))
            json["name"] = FlexiJSON(string: name)
            json["_id"] = FlexiJSON(string: id)
            return OHHTTPStubsResponse(data: json.data!, statusCode: 200, headers: nil)
        }
    }

    func stubGetBotError(withID id: String, statusCode: Int32) {
        stub(isHost(testHost) && isMethodGET() && isPath("/api/bots/\(id)")) { _ in
            OHHTTPStubsResponse(data: Data(), statusCode: statusCode, headers: nil)
        }
    }
}

func empty(_ statusCode: Int32) -> OHHTTPStubsResponse {
    return OHHTTPStubsResponse(data: NSData(), statusCode: statusCode, headers: nil)
}

func json(_ fileName: String) -> OHHTTPStubsResponse {
    let file = testBundle.pathForResource(fileName, ofType: "json")!
    return fixture(file, headers: nil)
}
