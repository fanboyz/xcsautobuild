//
// Created by Sean Henry on 11/09/2016.
//

import Foundation

@objc(ShouldDeleteABotWhenOutOfSyncWithXcodeServer)
class ShouldDeleteABotWhenOutOfSyncWithXcodeServer: XcodeServerSynchronisation {

    // MARK: - Output
    var botDeleted: String!
    var branchDeleted: String!

    // MARK: - Test

    override func setUp() {
        super.setUp()
        botDeleted = nil
        branchDeleted = nil
        setUpGit(branches: ["different_branch"])
    }

    override func test() {
        super.test()
        botDeleted = fitnesseString(from: mockedNetwork.deleteBotCount == 1)
        branchDeleted = fitnesseString(from: branchesDataStore.load(fromBranchName: branch) == nil)
    }

    override func setUpMockedNetwork() {
        super.setUpMockedNetwork()
        mockedNetwork.expectCreateBot()
        mockedNetwork.expectDeleteBot(id: validBotID)
        mockedNetwork.expectDeleteBotNotFound(id: invalidBotID)
        print(existingBotID )
        mockedNetwork.stubGetBot(withID: validBotID, name: branch)
        mockedNetwork.stubGetBotError(withID: invalidBotID, statusCode: 404)
    }
}
