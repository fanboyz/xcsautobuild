//
// Created by Sean Henry on 12/09/2016.
//

import Foundation
import FlexiJSON

class XCSBotSynchroniser: BotSynchroniser {

    private let getBotRequest: AnyXCSRequest<String, Data>
    private let duplicateBotRequest: AnyXCSRequest<DuplicateBotRequestData, String>
    private let deleteBotRequest: AnyXCSRequest<String, Void>
    private let botTemplateLoader: BotTemplateLoader

    init(
        getBotRequest: AnyXCSRequest<String, Data>,
        duplicateBotRequest: AnyXCSRequest<DuplicateBotRequestData, String>,
        deleteBotRequest: AnyXCSRequest<String, Void>,
        botTemplateLoader: BotTemplateLoader
    ) {
        self.getBotRequest = getBotRequest
        self.duplicateBotRequest = duplicateBotRequest
        self.deleteBotRequest = deleteBotRequest
        self.botTemplateLoader = botTemplateLoader
    }

    func synchroniseBot(fromBranch branch: XCSBranch, completion: (XCSBranch) -> ()) {
        guard let templateID = loadTemplateID(forBranch: branch) else {
            completion(branch)
            return
        }
        guard let botID = branch.botID, doesBotExist(withID: botID) else {
            createBot(forNewBranch: branch, templateID: templateID, completion: completion)
            return
        }
        completion(branch)
    }

    func deleteBot(fromBranch branch: XCSBranch, completion: (Bool) -> ()) {
        guard let botID = branch.botID else {
            completion(true)
            return
        }
        let response = deleteBotRequest.send(botID)
        completion(isBotDeleted(fromResponse: response))
    }

    private func loadTemplateID(forBranch branch: XCSBranch) -> String? {
        guard let data = botTemplateLoader.load()?.data else { return nil }
        return FlexiJSON(data: data)["_id"].string
    }

    private func createBot(forNewBranch branch: XCSBranch, templateID: String, completion: (XCSBranch) -> ()) {
        let templateData = DuplicateBotRequestData(id: templateID, name: BotNameConverter.convertToBotName(branchName: branch.name))
        if let newBotID = duplicateBotRequest.send(templateData)?.data {
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
