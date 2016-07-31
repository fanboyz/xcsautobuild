//
//  XcodeServerBotAPI.swift
//
//
//

import Foundation

class XcodeServerBotAPI: BotCreator {

    private let network: Network
    private let endpoint = "https://seans-macbook-pro-2.local:20343/api/"

    init(network: Network) {
        self.network = network
    }

    func createBot(forBranch branch: Branch) {
        let branch = branch.name
        network.sendRequest(HTTPRequest(url: endpoint + "bots", method: .post, jsonBody: temporaryBotTemplate(forBranch: branch)))
    }

    func getBots(completion: (([RemoteBot]) -> ())) {
        let request = HTTPRequest(url: endpoint + "bots", method: .delete, jsonBody: nil)
        network.sendRequest(request) { data in
            completion(XCSGetBotsResponseParser().parse(response: data))
        }
    }

    private func temporaryBotTemplate(forBranch branch: String) -> [String: AnyObject] {
        let location = Bot.Configuration.Blueprint.Location(branchName: branch)
        let repo = Bot.Configuration.Blueprint.Repository(id: "C214B4F4246A49E51CAE71AA5C1349A716302EB4", url: "https://seans-macbook-pro-2.local/git/xcsautobuild.git", fingerprint: "93138D460F513226B44C11D1DC747F2BE36A21CE")
        let blueprint = Bot.Configuration.Blueprint(location: location, projectName: "xcsautobuild", projectPath: "xcsautobuild.xcodeproj", authenticationStrategy: .basic("test", "test123"), repository: repo)
        let configuration = Bot.Configuration(schedule: .commit, schemeName: "xcsautobuild_macOS", builtFromClean: .never, performsAnalyzeAction: true, performsTestAction: .no, exportsProductFromArchive: true, triggers: [], sourceControlBlueprint: blueprint)
        return Bot(name: "xcsautobuild [\(branch)]", configuration: configuration).toJSON()
    }
}
