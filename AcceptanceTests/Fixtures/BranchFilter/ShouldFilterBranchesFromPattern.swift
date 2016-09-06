//
// Created by Sean Henry on 06/09/2016.
//

import Foundation

@objc(ShouldFilterBranchesFromPattern)
class ShouldFilterBranchesFromPattern: NSObject, SlimDecisionTable {

    // MARK: - Input
    var pattern: String!
    var branches: String!
    var branchesArray: [String] {
        return commaSeparatedList(from: branches)
    }

    // MARK: - Output
    var createdBots: String!

    // MARK: - Test
    func reset() {
        pattern = nil
        createdBots = nil
    }

    func execute() {
    }
}
