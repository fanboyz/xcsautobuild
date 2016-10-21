
import Foundation

@objc(ShouldCreateTemplateFromBotName)
class ShouldCreateTemplateFromBotName: DecisionTable {

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

    override func setUp() {
        createdTemplate = nil
    }

    override func test() {
        network = MockNetwork()
        network.stubGetBots(withNames: availableBotsArray, ids: availableBotsArray)
        availableBotsArray.forEach { network.stubGetBot(withID: $0, name: $0) }
        interactor = BotTemplateCreatingInteractor(botTemplatesFetcher: api, botTemplateSaver: FileBotTemplateDataStore(file: testTemplateFile))
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
