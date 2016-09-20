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
        super.setUp()
        botCreated = nil
        branchBotID = nil
        setUpGit(branches: branch)
    }

    override func test() {
        super.test()
        botCreated = fitnesseString(from: mockedNetwork.duplicateBotCount == 1)
        branchBotID = branchesDataStore.load(fromBranchName: "develop")?.botID
    }

    override func setUpMockedNetwork() {
        super.setUpMockedNetwork()
        mockedNetwork.expectDuplicateBot(id: testTemplateBotID)
        mockedNetwork.stubGetBot(withID: validBotID, name: "develop")
        mockedNetwork.stubGetBotError(withID: invalidBotID, statusCode: 404)
        mockedNetwork.stubbedDuplicatedBotID = newBotID
    }
}
