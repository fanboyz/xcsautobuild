//
// Created by Sean Henry on 11/09/2016.
//

import Foundation

@objc(ShouldDeleteABotWhenOutOfSyncWithXcodeServer)
class ShouldDeleteABotWhenOutOfSyncWithXcodeServer: DecisionTable {

    // MARK: - Input
    var existingBotID: String!

    // MARK: - Output
    var botDeleted: String!
    var branchDeleted: String!

    // MARK: - Test
    override func setUp() {
        botDeleted = nil
        branchDeleted = nil
    }

    override func test() {

    }
}
