//
//  Copyright (c) 2016 Sean Henry
//

import Foundation
import FlexiJSON
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
let testRequest = HTTPRequest(path: "/test/request/path?key=value", method: .get, jsonBody: [:])
let testBranch = Branch(name: "test")
let testTemplateBotID = "template_bot_id"
let testTemplateBotJSON = ["name": "template bot", "_id": testTemplateBotID]
let testTemplateBotData = FlexiJSON(dictionary: testTemplateBotJSON).data!
let testBotTemplate = BotTemplate(name: testTemplateBotJSON["name"]!, data: testTemplateBotData)
let testBotName = "test bot"
let testBotID = "6139a72b95fdeec94b49ec0a1f00191a"
let testBotJSON = ["name": testBotName, "_id": testBotID]
let testBotData = FlexiJSON(dictionary: testBotJSON).data!
let testPrimaryRepoKey = "C214B4F4246A49E51CAE71AA5C1349A716302EB4"
let testData = "data".data(using: String.Encoding.utf8)!
let testURL = URL(string: "https://test.com")!
let testBundle = Bundle(for: TestClass.self)

private class TestClass {}

extension String {

    var utf8Data: Data {
        return data(using: String.Encoding.utf8)!
    }
}
