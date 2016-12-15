
import Foundation

class BotTemplateLauncher {

    func launch(view: TextFieldBotTemplateView) {
        guard let configuration = Dependencies.xcsConfigurationDataStore.load() else {
            view.isEnabled = false
            return
        }
        let api = Dependencies.createAPI(requestSender: Dependencies.createRequestSender(xcsConfiguration: configuration))
        let dataStore = FileBotTemplateDataStore(file: Locations.botTemplateFile.path)
        let interactor = BotTemplateCreatingInteractor(botTemplatesFetcher: api, botTemplateDataStore: AnyDataStore(dataStore))
        let presenter = BotTemplatePresenter(view: view, templateCreatingInteractor: interactor)
        view.eventHandler = presenter
        interactor.output = presenter
        view.display(botName: dataStore.load()?.name ?? "")
        view.isEnabled = true
    }
}
