
import Foundation

@testable import xcsautobuild

class MockBotTemplateLoader: BotTemplateLoader {

    var stubbedTemplate: BotTemplate?
    func load() -> BotTemplate? {
        return stubbedTemplate
    }
}
