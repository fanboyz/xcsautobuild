//
//  Copyright (c) 2016 Sean Henry
//

import Foundation
import OHHTTPStubs
import FlexiJSON


class MockNetwork {

    deinit {
        OHHTTPStubs.removeAllStubs()
    }

    var duplicateBotCount = 0
    var invokedDuplicateBotResponse: Data?
    var stubbedDuplicatedBotID = testBotID
    func expectDuplicateBot(id: String) {
        _ = stub(condition: isHost(testHost) && isMethodPOST() && isPath("/api/bots/\(id)/duplicate")) { [unowned self] request in
            let request = request as NSURLRequest
            self.invokedDuplicateBotResponse = request.ohhttpStubs_HTTPBody()
            self.duplicateBotCount += 1
            var json = FlexiJSON(data: load("bots_post_response", "json"))
            json["_id"] = FlexiJSON(string: self.stubbedDuplicatedBotID)
            return OHHTTPStubsResponse(data: json.data!, statusCode: 201, headers: nil)
        }
    }

    var deleteBotCount = 0
    var deletedBotIDs = [String]()
    func expectDeleteBot(id: String) {
        _ = stub(condition: isMethodDELETE() && isPath("/api/bots/\(id)")) { [unowned self] _ in
            self.deletedBotIDs.append(id)
            self.deleteBotCount += 1
            return empty(204)
        }
    }

    func expectDeleteBotNotFound(id: String) {
        _ = stub(condition: isMethodDELETE() && isPath("/api/bots/\(id)")) { _ in
            return empty(404)
        }
    }

    var patchedBotBranchName: String?
    func expectPatchBot(id: String) {
        _ = stub(condition: isHost(testHost) && isMethodPATCH() && isPath("/api/bots/\(id)")) { [unowned self] request in
            let request = request as NSURLRequest
            let body = request.ohhttpStubs_HTTPBody()!
            self.patchedBotBranchName = FlexiJSON(data: body)["configuration"]["sourceControlBlueprint"]["DVTSourceControlWorkspaceBlueprintLocationsKey"][testPrimaryRepoKey]["DVTSourceControlBranchIdentifierKey"].string

            var json = FlexiJSON(data: load("bots_post_response", "json"))
            json["_id"] = FlexiJSON(string: self.stubbedDuplicatedBotID)
            return OHHTTPStubsResponse(data: json.data!, statusCode: 201, headers: nil)
        }
    }
    
    func stubPatchBot(withID id: String) {
        _ = stub(condition: isHost(testHost) && isMethodPATCH() && isPath("/api/bots/\(id)")) { _ in
            return OHHTTPStubsResponse(data: load("bot_get_response", "json"), statusCode: 200, headers: nil)
        }
    }

    func stubGetBots(withNames names: [String], ids: [String]) {
        _ = stub(condition: isHost(testHost) && isMethodGET() && isPath("/api/bots")) { _ -> OHHTTPStubsResponse in
            var json = FlexiJSON(data: load("bots_get_response", "json"))
            json["count"] = FlexiJSON(int: Int64(names.count))
            let template = json["results"][0]
            var array = [Any]()
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
        _ = stub(condition: isHost(testHost) && isMethodGET() && isPath("/api/bots/\(id)")) { request in
            var json = FlexiJSON(data: load("bot_get_response", "json"))
            json["name"] = FlexiJSON(string: name)
            json["_id"] = FlexiJSON(string: id)
            return OHHTTPStubsResponse(data: json.data!, statusCode: 200, headers: nil)
        }
    }

    func stubGetBotError(withID id: String, statusCode: Int32) {
        _ = stub(condition: isHost(testHost) && isMethodGET() && isPath("/api/bots/\(id)")) { _ in
            OHHTTPStubsResponse(data: Data(), statusCode: statusCode, headers: nil)
        }
    }
}

func empty(_ statusCode: Int32) -> OHHTTPStubsResponse {
    return OHHTTPStubsResponse(data: Data(), statusCode: statusCode, headers: nil)
}

func json(_ fileName: String) -> OHHTTPStubsResponse {
    let file = testBundle.path(forResource: fileName, ofType: "json")!
    return fixture(filePath: file, headers: nil)
}
