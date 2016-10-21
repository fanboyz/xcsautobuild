//
// Created by Sean Henry on 12/09/2016.
//

import Foundation
import FlexiJSON

class XCSBotSynchroniser: BotSynchroniser {

    private let getBotRequest: AnyXCSRequest<String, Data>
    private let duplicateBotRequest: AnyXCSRequest<DuplicateBotRequestData, String>
    private let deleteBotRequest: AnyXCSRequest<String, Void>
    private let patchBotRequest: AnyXCSRequest<PatchBotRequestData, Void>
    private let botTemplateLoader: BotTemplateLoader

    init(
        getBotRequest: AnyXCSRequest<String, Data>,
        duplicateBotRequest: AnyXCSRequest<DuplicateBotRequestData, String>,
        deleteBotRequest: AnyXCSRequest<String, Void>,
        patchBotRequest: AnyXCSRequest<PatchBotRequestData, Void>,
        botTemplateLoader: BotTemplateLoader
    ) {
        self.getBotRequest = getBotRequest
        self.duplicateBotRequest = duplicateBotRequest
        self.deleteBotRequest = deleteBotRequest
        self.patchBotRequest = patchBotRequest
        self.botTemplateLoader = botTemplateLoader
    }

    func synchronise(_ bot: Bot, completion: (Bot) -> ()) {
        guard let templateID = loadTemplateID() else {
            completion(bot)
            return
        }
        guard let botID = bot.id, doesBotExist(withID: botID) else {
            let newBot = createBot(fromBranchName: bot.branchName, templateID: templateID)
            completion(newBot)
            return
        }
        completion(bot)
    }

    func delete(_ bot: Bot, completion: (Bool) -> ()) {
        guard let botID = bot.id else {
            completion(true)
            return
        }
        let response = deleteBotRequest.send(botID)
        completion(isBotDeleted(fromResponse: response))
    }

    private func loadTemplateID() -> String? {
        guard let data = botTemplateLoader.load()?.data else { return nil }
        return FlexiJSON(data: data)["_id"].string
    }

    private func createBot(fromBranchName branchName: String, templateID: String) -> Bot {
        let templateData = DuplicateBotRequestData(id: templateID, name: BotNameConverter.convertToBotName(branchName: branchName))
        if let newBotID = duplicateBotRequest.send(templateData)?.data,
           patch(branchName: branchName, ontoBotWithID: newBotID) {
            return Bot(branchName: branchName, id: newBotID)
        }
        return Bot(branchName: branchName, id: nil)
    }

    private func patch(branchName: String, ontoBotWithID id: String) -> Bool {
        guard var json = getBotJSON(from: id),
              let primaryRepoKey = repositoryKey(from: json) else { return false }
        set(branchName: branchName, in: &json, primaryRepoKey: primaryRepoKey)
        if let response = patchBotRequest.send(PatchBotRequestData(id: id, dictionary: json.dictionary!)) {
            return response.statusCode == 200
        }
        return false
    }

    private func getBotJSON(from id: String) -> FlexiJSON? {
        guard let data = getBotRequest.send(id)?.data else { return nil }
        return FlexiJSON(data: data)
    }

    private func repositoryKey(from json: FlexiJSON) -> String? {
        return json["configuration"]["sourceControlBlueprint"]["DVTSourceControlWorkspaceBlueprintPrimaryRemoteRepositoryKey"].string
    }

    private func set(branchName: String, in json: inout FlexiJSON, primaryRepoKey: String) {
        json["configuration"]["sourceControlBlueprint"]["DVTSourceControlWorkspaceBlueprintLocationsKey"][primaryRepoKey]["DVTSourceControlBranchIdentifierKey"] = FlexiJSON(string: branchName)
    }

    private func doesBotExist(withID botID: String) -> Bool {
        return getBotRequest.send(botID)?.statusCode != 404
    }

    private func isBotDeleted(fromResponse response: XCSResponse<Void>?) -> Bool {
        guard let response = response else { return false }
        return response.isSuccess || response.statusCode == 404
    }
}
