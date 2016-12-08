
import Foundation

class BotTemplateLauncher {

    func launch(view: TextFieldBotTemplateView) {
        guard let configuration = Dependencies.xcsConfigurationDataStore.load() else {
            view.isEnabled = false
            return
        }
        let api = Dependencies.createAPI(requestSender: Dependencies.createRequestSender(xcsConfiguration: configuration))
        let saver = FileBotTemplateDataStore(file: Locations.botTemplateFile.path)
        let interactor = BotTemplateCreatingInteractor(botTemplatesFetcher: api, botTemplateSaver: saver)
        let presenter = BotTemplatePresenter(view: view, templateCreatingInteractor: interactor)
        view.eventHandler = presenter
        interactor.output = presenter
        view.display(botName: saver.load()?.name ?? "")
        view.isEnabled = true
    }
}
