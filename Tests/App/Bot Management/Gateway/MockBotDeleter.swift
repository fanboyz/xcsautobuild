//
//  Copyright (c) 2016 Sean Henry
//

@testable import xcsautobuild

class MockBotDeleter: BotDeleter {

    var didDeleteBot = false
    var invokedBranches = [Branch]()
    func deleteBot(forBranch branch: Branch) {
        didDeleteBot = true
        invokedBranches.append(branch)
    }
}
