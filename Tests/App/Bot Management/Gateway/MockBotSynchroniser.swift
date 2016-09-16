//
// Created by Sean Henry on 12/09/2016.
//

import Foundation
@testable import xcsautobuild

class MockBotSynchroniser: BotSynchroniser {

    var didSynchroniseBot = false
    var invokedBranch: XCSBranch?
    var invokedBranches = [XCSBranch]()
    var stubbedBranch: XCSBranch?
    func synchroniseBot(fromBranch branch: XCSBranch, completion: (XCSBranch) -> ()) {
        didSynchroniseBot = true
        invokedBranch = branch
        invokedBranches.append(branch)
        completion(stubbedBranch ?? branch)
    }
}

