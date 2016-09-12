//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

class XcodeServerBotAPI: BotCreator, BotDeleter {

    private let endpoint = "https://seans-macbook-pro-2.local:20343/api/"
    private let createBotRequest: AnyXCSRequest<[String: AnyObject], Void>
    private let getBotsRequest: AnyXCSRequest<Void, [RemoteBot]>
    private let deleteBotRequest: AnyXCSRequest<String, Void>
    private let getBotRequest: AnyXCSRequest<String, NSData>
    private let botTemplateLoader: BotTemplateLoader

    init(
        createBotRequest: AnyXCSRequest<[String: AnyObject], Void>,
        getBotsRequest: AnyXCSRequest<Void, [RemoteBot]>,
        deleteBotRequest: AnyXCSRequest<String, Void>,
        getBotRequest: AnyXCSRequest<String, NSData>,
        botTemplateLoader: BotTemplateLoader
    ) {
        self.createBotRequest = createBotRequest
        self.getBotsRequest = getBotsRequest
        self.deleteBotRequest = deleteBotRequest
        self.getBotRequest = getBotRequest
        self.botTemplateLoader = botTemplateLoader
    }

    func createBot(forBranch branch: Branch) {
        guard let dictionary = loadTemplateJSON(forBranch: branch)?.dictionary else { return }
        createBotRequest.send(dictionary) { _ in }
    }

    func deleteBot(forBranch branch: Branch) {
        getBots { bots in
            bots.filter { $0.name == Constants.convertBranchNameToBotName(branch.name) }
                .forEach { self.deleteBot(id: $0.id) }
        }
    }

    func getBots(completion: (([RemoteBot]) -> ())) {
        getBotsRequest.send(()) { response in
            completion(response?.data ?? [])
        }
    }

    func deleteBot(id id: String) {
        deleteBotRequest.send(id) { _ in }
    }

    private func loadTemplateJSON(forBranch branch: Branch) -> FlexiJSON? {
        guard let data = botTemplateLoader.load()?.data else { return nil }
        var json = FlexiJSON(data: data)
        json["name"] = FlexiJSON(string: Constants.convertBranchNameToBotName(branch.name))
        return json
    }

}

extension XcodeServerBotAPI: BotTemplatesFetcher {

    func fetchBotTemplates(completion: ([BotTemplate]) -> ()) {
        getBots { [unowned self] bots in
            let templates = self.fetchTemplates(forRemoteBots: bots)
            completion(templates)
        }
    }

    private func fetchTemplates(forRemoteBots bots: [RemoteBot]) -> [BotTemplate] {
        return bots.flatMap { fetchTemplate(forRemoteBot: $0) }
    }

    private func fetchTemplate(forRemoteBot bot: RemoteBot) -> BotTemplate? {
        guard let data = getBotRequest.send(bot.id)?.data,
                  name = FlexiJSON(data: data)["name"].string else { return nil }
        return BotTemplate(name: name, data: data)
    }
}
