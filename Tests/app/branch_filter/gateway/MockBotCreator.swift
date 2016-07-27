//
//  MockBotCreator.swift
//
//
//

import XCTest
@testable import xcsautobuild

class MockBotCreator: BotCreator {

    var didCreateBot = false
    var invokedBranches = [String]()
    func createBot(forBranch branch: String) {
        didCreateBot = true
        invokedBranches.append(branch)
    }
}
