//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

@objc(ShouldOverwriteExistingBotTemplate)
class ShouldOverwriteExistingBotTemplate: DecisionTable {

    // MARK: - inputs
    var botName: String!
    var availableBots: String!
    var availableBotsArray: [String] {
        return commaSeparatedList(from: availableBots)
    }

    // MARK: - outputs
    var didOverwriteTemplate: String!

    // MARK: - test
    var interactor: BotTemplateCreatingInteractor!
    var network: MockNetwork!
    var finished = false
    var persister: FileBotTemplatePersister!

    override func setUp() {
        finished = false
        didOverwriteTemplate = nil
    }

    override func test() {
        network = MockNetwork()
        network.stubGetBots(withNames: availableBotsArray, ids: availableBotsArray)
        availableBotsArray.forEach { network.stubGetBot(withID: $0, name: $0) }
        persister = FileBotTemplatePersister(file: testTemplateFile)
        persister.save(testBotTemplate)
        interactor = BotTemplateCreatingInteractor(botTemplatesFetcher: api, botTemplateSaver: persister)
        interactor.botName = botName
        interactor.output = self
        interactor.execute()
        waitUntil(didOverwriteTemplate != nil)
    }
}

extension ShouldOverwriteExistingBotTemplate: BotTemplateCreatingInteractorOutput {

    func didCreateTemplate() {
        didOverwriteTemplate = yes
    }

    func didFailToFindTemplate() {
        didOverwriteTemplate = no
    }
}
