//
//  XcodeServerBotAPI.swift
//
//
//

import Foundation

class XcodeServerBotAPI: BotCreator, BotDeleter {

    private let endpoint = "https://seans-macbook-pro-2.local:20343/api/"
    private let createBotRequest: AnyXCSRequest<Bot, Void>
    private let getBotsRequest: AnyXCSRequest<Void, [RemoteBot]>
    private let deleteBotRequest: AnyXCSRequest<String, Void>

    init(
        createBotRequest: AnyXCSRequest<Bot, Void>,
        getBotsRequest: AnyXCSRequest<Void, [RemoteBot]>,
        deleteBotRequest: AnyXCSRequest<String, Void>
    ) {
        self.createBotRequest = createBotRequest
        self.getBotsRequest = getBotsRequest
        self.deleteBotRequest = deleteBotRequest
    }

    func createBot(forBranch branch: Branch) {
        let bot = temporaryBotTemplate(forBranch: branch.name)
        createBotRequest.send(bot) { _ in }
    }

    func deleteBot(forBranch branch: Branch) {
        getBots { bots in
            bots.filter { $0.name == self.branchNameToBotName(branch.name) }
                .forEach { self.deleteBot(id: $0.id) }
        }
    }

    func getBots(completion: (([RemoteBot]) -> ())) {
        getBotsRequest.send(()) { bots in
            completion(bots ?? [])
        }
    }

    func deleteBot(id id: String) {
        deleteBotRequest.send(id) { _ in }
    }

    private func temporaryBotTemplate(forBranch branch: String) -> Bot {
        let location = Bot.Configuration.Blueprint.Location(branchName: branch)
        let repo = Bot.Configuration.Blueprint.Repository(id: "C214B4F4246A49E51CAE71AA5C1349A716302EB4", url: "https://seans-macbook-pro-2.local/git/xcsautobuild.git", fingerprint: "93138D460F513226B44C11D1DC747F2BE36A21CE")
        let blueprint = Bot.Configuration.Blueprint(location: location, projectName: "xcsautobuild", projectPath: "xcsautobuild.xcodeproj", authenticationStrategy: .basic("test", "test123"), repository: repo)
        let configuration = Bot.Configuration(schedule: .commit, schemeName: "xcsautobuild_macOS", builtFromClean: .never, performsAnalyzeAction: true, performsTestAction: .no, exportsProductFromArchive: true, triggers: [], sourceControlBlueprint: blueprint)
        return Bot(name: branchNameToBotName(branch), configuration: configuration)
    }

    private func branchNameToBotName(branch: String) -> String {
        return "xcsautobuild [\(branch)]"
    }
}
