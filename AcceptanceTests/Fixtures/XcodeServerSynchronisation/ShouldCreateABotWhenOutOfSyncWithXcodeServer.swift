
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
        branchBotID = botDataStore.load(fromBranchName: "develop")?.id
    }

    override func setUpMockedNetwork() {
        super.setUpMockedNetwork()
        mockedNetwork.expectDuplicateBot(id: testTemplateBotID)
        mockedNetwork.stubGetBot(withID: validBotID, name: "develop")
        mockedNetwork.stubGetBotError(withID: invalidBotID, statusCode: 404)
        mockedNetwork.stubGetBot(withID: newBotID, name: "develop")
        mockedNetwork.stubPatchBot(withID: newBotID)
        mockedNetwork.stubbedDuplicatedBotID = newBotID
    }
}
