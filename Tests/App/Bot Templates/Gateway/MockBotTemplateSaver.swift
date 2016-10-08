//
//  Copyright (c) 2016 Sean Henry
//

import XCTest
@testable import xcsautobuild

class MockBotTemplateSaver: BotTemplateSaver {

    var didSave = false
    func save(_ template: BotTemplate) {
        didSave = true
    }
}
