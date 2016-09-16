//
//  Copyright (c) 2016 Sean Henry
//

import Foundation
@testable import xcsautobuild

private func createBot() -> Bot {
    let location = Bot.Configuration.Blueprint.Location(branchName: "master")
    let repo = Bot.Configuration.Blueprint.Repository(
        id: testRepoID,
        url: "https://xcs-server.local/git/xcsautobuild.git",
        fingerprint: testRepoFingerprint
    )
    let blueprint = Bot.Configuration.Blueprint(
        location: location,
        projectName: "xcsautobuild",
        projectPath: "xcsautobuild.xcodeproj",
        authenticationStrategy: .basic("sean", "password"),
        repository: repo
    )
    let before = Bot.Configuration.Trigger(
        phase: .before,
        name: "Before Trigger",
        scriptBody: "echo \"hello world!\""
    )
    let after = Bot.Configuration.Trigger(
        phase: .after([.onWarnings, .onSuccess, .onAnalyzerWarnings]),
        name: "After Trigger",
        scriptBody: "echo \"fancy seeing you here\""
    )
    let configuration = Bot.Configuration(
        schedule: .commit, schemeName: "xcsautobuild_macOS",
        builtFromClean: .never,
        performsAnalyzeAction: true,
        performsTestAction: .no,
        exportsProductFromArchive: true,
        triggers: [before, after],
        sourceControlBlueprint: blueprint
    )
    return Bot(name: "bot1", configuration: configuration)
}

let testRepoFingerprint = "93138D460F513226B44C11D1DC747F2BE36A21CE"
let testRepoID = "C214B4F4246A49E51CAE71AA5C1349A716302EB4"
let testBot = createBot()
let testEndpoint = "https://seans-macbook-pro-2.local:20343/api/"
let testRequest = HTTPRequest(url: testURL.absoluteString, method: .get, jsonBody: [:])
let testBranch = Branch(name: "test")
let testTemplateBotJSON = ["name": "template bot", "id": "bot_id"]
let testTemplateBotData = FlexiJSON(dictionary: testTemplateBotJSON).data!
let testBotTemplate = BotTemplate(name: testTemplateBotJSON["name"]!, data: testTemplateBotData)
let testBotName = "test bot"
let testBotID = "test_bot_id"
let testBotJSON = ["name": testBotName, "id": testBotID]
let testBotData = FlexiJSON(dictionary: testBotJSON).data!
let testData = "data".dataUsingEncoding(NSUTF8StringEncoding)!
let testURL = NSURL(string: "https://test.com")!

extension String {

    var utf8Data: NSData {
        return dataUsingEncoding(NSUTF8StringEncoding)!
    }
}
