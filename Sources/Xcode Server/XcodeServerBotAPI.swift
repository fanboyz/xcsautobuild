//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

class XcodeServerBotAPI: BotDeleter {

    private let endpoint = "https://seans-macbook-pro-2.local:20343/api/"
    private let getBotsRequest: AnyXCSRequest<Void, [RemoteBot]>
    private let deleteBotRequest: AnyXCSRequest<String, Void>
    private let getBotRequest: AnyXCSRequest<String, NSData>

    init(
        getBotsRequest: AnyXCSRequest<Void, [RemoteBot]>,
        deleteBotRequest: AnyXCSRequest<String, Void>,
        getBotRequest: AnyXCSRequest<String, NSData>
    ) {
        self.getBotsRequest = getBotsRequest
        self.deleteBotRequest = deleteBotRequest
        self.getBotRequest = getBotRequest
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
