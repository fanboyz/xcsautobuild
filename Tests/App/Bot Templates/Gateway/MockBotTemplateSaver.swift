//
//  MockBotTemplateSaver.swift
//
//
//

import XCTest
@testable import xcsautobuild

class MockBotTemplateSaver: BotTemplateSaver {

    var didSave = false
    func save(template: BotTemplate) {
        didSave = true
    }
}
