
import Foundation

@objc(ShouldPersistBotTemplate)
class ShouldPersistBotTemplate: DecisionTable {

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
    var persister: FileBotTemplateDataStore!

    override func setUp() {
        didPersist = nil
    }

    override func test() {
        network = MockNetwork()
        network.stubGetBots(withNames: availableBotsArray, ids: availableBotsArray)
        availableBotsArray.forEach { network.stubGetBot(withID: $0, name: $0) }
        persister = FileBotTemplateDataStore(file: testTemplateFile)
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
