//
// Created by Sean Henry on 11/09/2016.
//

import Foundation

@objc(ShouldCreateABotWhenOutOfSyncWithXcodeServer)
class ShouldCreateABotWhenOutOfSyncWithXcodeServer: XcodeServerSynchronisation {

    // MARK: - Output
    var botCreated: String!
    var branchBotID: String!

    // MARK: - Test

    override func setUp() {
        botCreated = nil
        branchBotID = nil
        super.setUp()
    }

    override func test() {
        super.test()
        botCreated = fitnesseString(from: mockedNetwork.createBotCount == 1)
        branchBotID = branchesDataStore.load(fromBranchName: "develop")?.botID
    }

    override func setUpMockedNetwork() {
        mockedNetwork = MockNetwork()
        mockedNetwork.expectCreateBot()
        mockedNetwork.stubGetBot(withID: validBotID, name: "develop")
        mockedNetwork.stubGetBotError(withID: invalidBotID, statusCode: 404)
        mockedNetwork.stubbedCreatedBotID = newBotID
    }
}
