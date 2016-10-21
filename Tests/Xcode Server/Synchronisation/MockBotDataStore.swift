//
// Created by Sean Henry on 11/09/2016.
//

import Foundation
@testable import xcsautobuild

class MockBotDataStore: BotDataStore {

    var didLoad = false
    var invokedLoadedBranchName: String?
    var stubbedLoadedBot: Bot?
    func load(fromBranchName name: String) -> Bot? {
        didLoad = true
        invokedLoadedBranchName = name
        return stubbedLoadedBot
    }

    var stubbedLoadedBots = [Bot]()
    func load() -> [Bot] {
        didLoad = true
        return stubbedLoadedBots
    }

    var invokedSavedBot: Bot?
    func save(_ bot: Bot) {
        invokedSavedBot = bot
    }

    var didDelete = false
    var invokedDeletedBot: Bot?
    func delete(_ bot: Bot) {
        didDelete = true
        invokedDeletedBot = bot
    }
}
