
import Foundation

protocol BotTemplateCreatingInteractorOutput: class {
    func didCreateTemplate()
    func didFailToFindTemplate()
}

protocol BotNamable {
    var botName: String { get set }
}

class BotTemplateCreatingInteractor: Command, BotNamable {

    private let botTemplatesFetcher: BotTemplatesFetcher
    private let botTemplateDataStore: BotTemplateDataStore
    weak var output: BotTemplateCreatingInteractorOutput?
    var botName = ""

    init(botTemplatesFetcher: BotTemplatesFetcher, botTemplateDataStore: BotTemplateDataStore) {
        self.botTemplatesFetcher = botTemplatesFetcher
        self.botTemplateDataStore = botTemplateDataStore
    }

    func execute() {
        botTemplatesFetcher.fetchBotTemplates { [weak self] templates in
            self?.handle(fetchedTemplates: templates)
        }
    }

    private func handle(fetchedTemplates templates: [BotTemplate]) {
        let matching = templates.filter { $0.name == botName }.first
        guard let template = matching else {
            output?.didFailToFindTemplate()
            return
        }
        botTemplateDataStore.save(template)
        output?.didCreateTemplate()
    }
}
