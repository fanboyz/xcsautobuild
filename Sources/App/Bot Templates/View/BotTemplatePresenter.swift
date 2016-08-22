//
//  BotTemplatePresenter.swift
//
//
//

import Foundation

class BotTemplatePresenter {

    typealias TemplateCreatingInteractor = protocol<Command, BotNamable>
    private weak var view: BotTemplateView?
    private var templateCreatingInteractor: TemplateCreatingInteractor

    init(view: BotTemplateView, templateCreatingInteractor: TemplateCreatingInteractor) {
        self.view = view
        self.templateCreatingInteractor = templateCreatingInteractor
    }
}

extension BotTemplatePresenter: BotTemplateEventHandler {

    func create(templateFromName name: String) {
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
