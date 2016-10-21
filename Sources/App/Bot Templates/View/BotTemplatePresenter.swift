
import Foundation

class BotTemplatePresenter {

    typealias TemplateCreatingInteractor = Command & BotNamable
    fileprivate weak var view: BotTemplateView?
    fileprivate var templateCreatingInteractor: TemplateCreatingInteractor

    init(view: BotTemplateView, templateCreatingInteractor: TemplateCreatingInteractor) {
        self.view = view
        self.templateCreatingInteractor = templateCreatingInteractor
    }
}

extension BotTemplatePresenter: BotTemplateEventHandler {

    func createTemplate(fromName name: String) {
        templateCreatingInteractor.botName = name
        templateCreatingInteractor.execute()
    }
}

extension BotTemplatePresenter: BotTemplateCreatingInteractorOutput {

    func didCreateTemplate() {
        view?.showSuccess()
    }

    func didFailToFindTemplate() {
        view?.showFailure()
    }
}
