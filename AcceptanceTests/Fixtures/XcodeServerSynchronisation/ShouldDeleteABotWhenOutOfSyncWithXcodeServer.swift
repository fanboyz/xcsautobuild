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
        botDeleted = nil
        branchDeleted = nil
        super.setUp()
    }

    override func test() {
        super.test()
        botDeleted = fitnesseString(from: mockedNetwork.createBotCount == 1)
        branchDeleted = fitnesseString(from: branchesDataStore.load(fromBranchName: "develop") == nil)
    }

    override func setUpMockedNetwork() {
        mockedNetwork = MockNetwork()
        if let id = botID {
            mockedNetwork.expectDeleteBot(id: id)
        }
        mockedNetwork.stubGetBot(withID: validBotID, name: "develop")
        mockedNetwork.stubGetBotError(withID: invalidBotID, statusCode: 404)
    }
}
