//
// Created by Sean Henry on 12/09/2016.
//

import Foundation
@testable import xcsautobuild

class MockBotSynchroniser: BotSynchroniser {

    var didSynchroniseBot = false
    var invokedSynchronisedBranch: XCSBranch?
    var invokedSynchronisedBranches = [XCSBranch]()
    var stubbedSynchronisedBranch: XCSBranch?
    func synchroniseBot(fromBranch branch: XCSBranch, completion: (XCSBranch) -> ()) {
        didSynchroniseBot = true
        invokedSynchronisedBranch = branch
        invokedSynchronisedBranches.append(branch)
        completion(stubbedSynchronisedBranch ?? branch)
    }

    var didDeleteBot = false
    var invokedDeletedBranch: XCSBranch?
    var invokedDeletedBranches = [XCSBranch]()
    var stubbedDeletionResult = false
    func deleteBot(fromBranch branch: XCSBranch, completion: Bool -> ()) {
        didDeleteBot = true
        invokedDeletedBranch = branch
        invokedDeletedBranches.append(branch)
        completion(stubbedDeletionResult)
    }
}

