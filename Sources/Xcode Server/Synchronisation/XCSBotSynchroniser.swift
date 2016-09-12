//
// Created by Sean Henry on 12/09/2016.
//

import Foundation

class XCSBotSynchroniser: BotSynchroniser {

    private let getBotRequest: AnyXCSRequest<String, NSData>
    private let createBotRequest: AnyXCSRequest<[String: AnyObject], Void>
    private let botTemplateLoader: BotTemplateLoader

    init(
            getBotRequest: AnyXCSRequest<String, NSData>,
            createBotRequest: AnyXCSRequest<[String: AnyObject], Void>,
            botTemplateLoader: BotTemplateLoader
    ) {
        self.getBotRequest = getBotRequest
        self.createBotRequest = createBotRequest
        self.botTemplateLoader = botTemplateLoader
    }

    func synchroniseBot(fromBranch branch: XCSBranch) {
        guard let template = loadTemplateJSON(forBranch: branch) else { return }
        guard let botID = branch.botID else {
            createBotRequest.send(template)
            return
        }
        if !doesBotExist(withID: botID) {
            createBotRequest.send(template)
        }
    }

    private func loadTemplateJSON(forBranch branch: XCSBranch) -> [String: AnyObject]? {
        guard let data = botTemplateLoader.load()?.data else { return nil }
        var json = FlexiJSON(data: data)
        json["name"] = FlexiJSON(string: Constants.convertBranchNameToBotName(branch.name))
        return json.dictionary
    }

    private func doesBotExist(withID botID: String) -> Bool {
        return getBotRequest.send(botID)?.statusCode != 404
    }
}
