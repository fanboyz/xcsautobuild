//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

class BotTemplateLauncher {

    func launch(withView view: TextFieldBotTemplateView) {
        let api = Constants.api
        let saver = FileBotTemplatePersister(file: Constants.templateFile)
        let interactor = BotTemplateCreatingInteractor(botTemplatesFetcher: api, botTemplateSaver: saver)
        let presenter = BotTemplatePresenter(view: view, templateCreatingInteractor: interactor)
        view.eventHandler = presenter
        interactor.output = presenter
    }
}
