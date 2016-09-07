//
//  Copyright (c) 2016 Sean Henry
//

import XCTest
@testable import xcsautobuild

class MockBotTemplatesFetcher: BotTemplatesFetcher {

    var didFetchBotTemplates = false
    var stubbedBotTemplates = [BotTemplate]()
    func fetchBotTemplates(completion: ([BotTemplate]) -> ()) {
        didFetchBotTemplates = true
        completion(stubbedBotTemplates)
    }
}
