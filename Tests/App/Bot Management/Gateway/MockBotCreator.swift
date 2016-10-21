
@testable import xcsautobuild

class MockBotCreator: BotCreator {

    var didCreateBot = false
    var invokedBranches = [Branch]()
    func createBot(forBranch branch: Branch) {
        didCreateBot = true
        invokedBranches.append(branch)
    }
}
