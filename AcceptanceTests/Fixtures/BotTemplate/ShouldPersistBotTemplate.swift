//
//  ShouldPersistBotTemplate.swift
//
//
//

import Foundation

@objc(ShouldPersistBotTemplate)
class ShouldPersistBotTemplate: NSObject, SlimDecisionTable {

    // MARK: - inputs
    var botName: String!
    var availableBots: String!
    var availableBotsArray: [String] {
        return commaSeparatedList(from: availableBots)
    }

    // MARK: - outputs
    var didPersist: String!

    // MARK: - test
    var interactor: BotTemplateCreatingInteractor!
    var network: MockNetwork!
    var finished = false

    func reset() {
        botName = nil
        availableBots = nil
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
        waitUntil(didPersist != nil)
    }
}

extension ShouldPersistBotTemplate: BotTemplateCreatingInteractorOutput {

    func didCreateTemplate() {
        didPersist = FileBotTemplatePersister(file: testTemplateFile).load() != nil ? yes : no
    }

    func didFailToFindTemplate() {
        didPersist = no
    }
}
