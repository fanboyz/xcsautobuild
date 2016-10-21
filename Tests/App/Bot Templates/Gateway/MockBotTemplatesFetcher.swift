
import XCTest
@testable import xcsautobuild

class MockBotTemplatesFetcher: BotTemplatesFetcher {

    var didFetchBotTemplates = false
    var stubbedBotTemplates = [BotTemplate]()
    func fetchBotTemplates(_ completion: @escaping ([BotTemplate]) -> ()) {
        didFetchBotTemplates = true
        completion(stubbedBotTemplates)
    }
}
