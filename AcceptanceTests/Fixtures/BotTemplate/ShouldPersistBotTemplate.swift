//
//  Copyright (c) 2016 Sean Henry
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
    var persister: FileBotTemplatePersister!

    func reset() {
        botName = nil
        availableBots = nil
        network = nil
        persister = nil
        didPersist = nil
        _ = try? NSFileManager.defaultManager().removeItemAtPath(testTemplateFile)
    }

    func execute() {
        network = MockNetwork()
        network.stubGetBots(withNames: availableBotsArray, ids: availableBotsArray)
        availableBotsArray.forEach { network.stubGetBot(withID: $0, name: $0) }
        persister = FileBotTemplatePersister(file: testTemplateFile)
        interactor = BotTemplateCreatingInteractor(botTemplatesFetcher: api, botTemplateSaver: persister)
        interactor.botName = botName
        interactor.output = self
        interactor.execute()
        waitUntil(didPersist != nil)
    }
}

extension ShouldPersistBotTemplate: BotTemplateCreatingInteractorOutput {

    func didCreateTemplate() {
        didPersist = persister.load() != nil ? yes : no
    }

    func didFailToFindTemplate() {
        didPersist = no
    }
}
