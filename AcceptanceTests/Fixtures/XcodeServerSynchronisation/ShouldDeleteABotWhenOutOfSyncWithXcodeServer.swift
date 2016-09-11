//
// Created by Sean Henry on 11/09/2016.
//

import Foundation

@objc(ShouldDeleteABotWhenOutOfSyncWithXcodeServer)
class ShouldDeleteABotWhenOutOfSyncWithXcodeServer: NSObject, SlimDecisionTable {

    // MARK: - Input
    var existingBotID: String!

    // MARK: - Output
    var botDeleted: String!
    var branchDeleted: String!

    // MARK: - Test
    func reset() {
        existingBotID = nil
        botDeleted = nil
        branchDeleted = nil
    }

    func execute() {

    }
}
