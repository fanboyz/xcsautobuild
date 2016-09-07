//
//  Copyright (c) 2016 Sean Henry
//

import XCTest
@testable import xcsautobuild

class MockBotTemplateCreatingInteractorOutput: BotTemplateCreatingInteractorOutput {

    var didCallDidCreateTemplate = false
    func didCreateTemplate() {
        didCallDidCreateTemplate = true
    }

    var didCallDidFailToFindTemplate = false
    func didFailToFindTemplate() {
        didCallDidFailToFindTemplate = true
    }
}
