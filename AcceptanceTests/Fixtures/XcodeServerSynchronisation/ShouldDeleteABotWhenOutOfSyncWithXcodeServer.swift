
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
        branchDeleted = fitnesseString(from: botDataStore.load(fromBranchName: branch) == nil)
    }

    override func setUpMockedNetwork() {
        super.setUpMockedNetwork()
        mockedNetwork.expectDeleteBot(id: validBotID)
        mockedNetwork.expectDeleteBotNotFound(id: invalidBotID)
        mockedNetwork.stubGetBot(withID: validBotID, name: branch)
        mockedNetwork.stubGetBotError(withID: invalidBotID, statusCode: 404)
        mockedNetwork.stubbedDuplicatedBotID = newBotID
    }
}
