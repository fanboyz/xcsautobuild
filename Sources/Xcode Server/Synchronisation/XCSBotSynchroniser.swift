//
// Created by Sean Henry on 12/09/2016.
//

import Foundation

class XCSBotSynchroniser: BotSynchroniser {

    private let getBotRequest: AnyXCSRequest<String, NSData>
    private let createBotRequest: AnyXCSRequest<[String: AnyObject], String>
    private let deleteBotRequest: AnyXCSRequest<String, Void>
    private let botTemplateLoader: BotTemplateLoader

    init(
        getBotRequest: AnyXCSRequest<String, NSData>,
        createBotRequest: AnyXCSRequest<[String: AnyObject], String>,
        deleteBotRequest: AnyXCSRequest<String, Void>,
        botTemplateLoader: BotTemplateLoader
    ) {
        self.getBotRequest = getBotRequest
        self.createBotRequest = createBotRequest
        self.deleteBotRequest = deleteBotRequest
        self.botTemplateLoader = botTemplateLoader
    }

    func synchroniseBot(fromBranch branch: XCSBranch, completion: (XCSBranch) -> ()) {
        guard let template = loadTemplateJSON(forBranch: branch) else {
            completion(branch)
            return
        }
        guard let botID = branch.botID where doesBotExist(withID: botID) else {
            createBot(forNewBranch: branch, template: template, completion: completion)
            return
        }
        completion(branch)
    }

    func deleteBot(fromBranch branch: XCSBranch, completion: Bool -> ()) {
        guard let botID = branch.botID else {
            completion(true)
            return
        }
        let response = deleteBotRequest.send(botID)
        completion(isBotDeleted(fromResponse: response))
    }

    private func loadTemplateJSON(forBranch branch: XCSBranch) -> [String: AnyObject]? {
        guard let data = botTemplateLoader.load()?.data else { return nil }
        var json = FlexiJSON(data: data)
        json["name"] = FlexiJSON(string: Constants.convertBranchNameToBotName(branch.name))
        return json.dictionary
    }

    private func createBot(forNewBranch branch: XCSBranch, template: [String: AnyObject], completion: (XCSBranch) -> ()) {
        if let newBotID = createBotRequest.send(template)?.data {
            completion(XCSBranch(name: branch.name, botID: newBotID))
        } else {
            completion(branch)
        }
    }

    private func doesBotExist(withID botID: String) -> Bool {
        return getBotRequest.send(botID)?.statusCode != 404
    }

    private func isBotDeleted(fromResponse response: XCSResponse<Void>?) -> Bool {
        guard let response = response else { return false }
        return response.isSuccess || response.statusCode == 404
    }
}
