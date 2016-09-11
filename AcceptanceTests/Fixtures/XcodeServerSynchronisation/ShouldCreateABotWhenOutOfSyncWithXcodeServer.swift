//
// Created by Sean Henry on 11/09/2016.
//

import Foundation

@objc(ShouldCreateABotWhenOutOfSyncWithXcodeServer)
class ShouldCreateABotWhenOutOfSyncWithXcodeServer: NSObject, SlimDecisionTable {

    // MARK: - Input
    var existingBotID: String!

    // MARK: - Output
    var botCreated: String!
    var branchBotID: String!

    // MARK: - Test
    func reset() {
        existingBotID = nil
        botCreated = nil
        branchBotID = nil
    }

    func execute() {

    }
}
