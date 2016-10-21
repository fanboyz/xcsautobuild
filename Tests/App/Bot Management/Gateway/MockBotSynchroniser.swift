
import Foundation
@testable import xcsautobuild

class MockBotSynchroniser: BotSynchroniser {

    var didSynchronise = false
    var invokedSynchronisedBot: Bot?
    var invokedSynchronisedBots = [Bot]()
    var stubbedSynchronisedBot: Bot?
    func synchronise(_ bot: Bot, completion: (Bot) -> ()) {
        didSynchronise = true
        invokedSynchronisedBot = bot
        invokedSynchronisedBots.append(bot)
        completion(stubbedSynchronisedBot ?? bot)
    }

    var didDelete = false
    var invokedDeletedBot: Bot?
    var invokedDeletedBots = [Bot]()
    var stubbedDeletionResult = false
    func delete(_ bot: Bot, completion: (Bool) -> ()) {
        didDelete = true
        invokedDeletedBot = bot
        invokedDeletedBots.append(bot)
        completion(stubbedDeletionResult)
    }
}

