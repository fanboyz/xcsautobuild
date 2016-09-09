//
// Created by Sean Henry on 09/09/2016.
//

import Foundation

@testable import xcsautobuild

class MockBotTemplateLoader: BotTemplateLoader {

    var stubbedTemplate: BotTemplate?
    func load() -> BotTemplate? {
        return stubbedTemplate
    }
}
