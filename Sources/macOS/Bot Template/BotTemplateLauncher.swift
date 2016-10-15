//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

class BotTemplateLauncher {

    func launch(view: TextFieldBotTemplateView) {
        let api = Dependencies.api
        let saver = FileBotTemplatePersister(file: Locations.botTemplateFile.path)
        let interactor = BotTemplateCreatingInteractor(botTemplatesFetcher: api, botTemplateSaver: saver)
        let presenter = BotTemplatePresenter(view: view, templateCreatingInteractor: interactor)
        view.eventHandler = presenter
        interactor.output = presenter
        view.display(botName: saver.load()?.name ?? "")
    }
}
