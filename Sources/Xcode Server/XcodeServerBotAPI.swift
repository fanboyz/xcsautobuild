//
//  Copyright (c) 2016 Sean Henry
//

import Foundation
import FlexiJSON

class XcodeServerBotAPI: BotDeleter {

    fileprivate let getBotsRequest: AnyXCSRequest<Void, [RemoteBot]>
    fileprivate let getBotRequest: AnyXCSRequest<String, Data>
    private let deleteBotRequest: AnyXCSRequest<String, Void>

    init(
        getBotsRequest: AnyXCSRequest<Void, [RemoteBot]>,
        deleteBotRequest: AnyXCSRequest<String, Void>,
        getBotRequest: AnyXCSRequest<String, Data>
    ) {
        self.getBotsRequest = getBotsRequest
        self.deleteBotRequest = deleteBotRequest
        self.getBotRequest = getBotRequest
    }

    func deleteBot(forBranch branch: Branch) {
        getBots { bots in
            bots.filter { $0.name == BotNameConverter.convertToBotName(branchName: branch.name) }
                .forEach { self.deleteBot(id: $0.id) }
        }
    }

    func getBots(_ completion: @escaping (([RemoteBot]) -> ())) {
        getBotsRequest.send(()) { response in
            completion(response?.data ?? [])
        }
    }

    func deleteBot(id: String) {
        deleteBotRequest.send(id) { _ in }
    }
}

extension XcodeServerBotAPI: BotTemplatesFetcher {

    func fetchBotTemplates(_ completion: @escaping ([BotTemplate]) -> ()) {
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
                  let name = FlexiJSON(data: data)["name"].string else { return nil }
        return BotTemplate(name: name, data: data)
    }
}
