//
//  ShouldCreateTemplateFromBotName.swift
//
//
//

import Foundation

@objc(ShouldCreateTemplateFromBotName)
class ShouldCreateTemplateFromBotName: NSObject, SlimDecisionTable {

    // MARK: - input
    var botName: String!
    var availableBots: String!
    var availableBotsArray: [String] {
        return commaSeparatedList(from: availableBots)
    }

    // MARK: - output
    var createdTemplate: String!

    // MARK: - test
    var interactor: BotTemplateCreatingInteractor!
    var network: MockNetwork!

    func reset() {
        botName = nil
        availableBots = nil
        createdTemplate = nil
        network = nil
        _ = try? NSFileManager.defaultManager().removeItemAtPath(testTemplateFile)
    }

    func execute() {
        network = MockNetwork()
        network.stubGetBots(withNames: availableBotsArray, ids: availableBotsArray)
        availableBotsArray.forEach { network.stubGetBot(withID: $0, name: $0) }
        interactor = BotTemplateCreatingInteractor(botTemplatesFetcher: api, botTemplateSaver: FileBotTemplatePersister(file: testTemplateFile))
        interactor.botName = botName
        interactor.output = self
        interactor.execute()
        waitUntil(createdTemplate != nil)
    }
}

extension ShouldCreateTemplateFromBotName: BotTemplateCreatingInteractorOutput {

    func didCreateTemplate() {
        createdTemplate = yes
    }

    func didFailToFindTemplate() {
        createdTemplate = no
    }
}
