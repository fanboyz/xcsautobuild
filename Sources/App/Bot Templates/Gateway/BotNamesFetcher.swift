//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

protocol BotTemplatesFetcher {
    func fetchBotTemplates(completion: ([BotTemplate]) -> ())
}
