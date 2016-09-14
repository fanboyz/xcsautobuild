//
// Created by Sean Henry on 11/09/2016.
//

import Foundation

@objc(ShouldCreateABotWhenOutOfSyncWithXcodeServer)
class ShouldCreateABotWhenOutOfSyncWithXcodeServer: DecisionTable, GitFixture {

    // MARK: - Input
    var existingBotID: String!
    var botID: String? {
        return existingBotID != "" ? existingBotID : nil
    }

    // MARK: - Output
    var botCreated: String!
    var branchBotID: String!

    // MARK: - Test
    let validBotID = "valid_bot_id"
    let invalidBotID = "invalid_bot_id"
    let newBotID = "new_bot_id"
    var gitBuilder: TwoRemoteGitBuilder!
    var mockedNetwork: MockNetwork!
    var interactor: BotSyncingInteractor!

    override func setUp() {
        botCreated = nil
        branchBotID = nil
        setUpMockedNetwork()
        setUpGit(branches: "develop")
        FileBotTemplatePersister(file: testTemplateFile).save(testBotTemplate)
    }

    override func test() {
        let branchesDataStore = FileXCSBranchesDataStore(file: testDataStoreFile)
        branchesDataStore.save(branch: XCSBranch(name: "develop", botID: botID))
        interactor = BotSyncingInteractor(
            branchFetcher: GitBranchFetcher(directory: testLocalGitURL.path!)!,
            botSynchroniser: testBotSynchroniser,
            branchFilter: TransparentBranchFilter(),
            branchesDataStore: branchesDataStore
        )

        interactor.execute()
        botCreated = fitnesseString(from: mockedNetwork.createBotCount == 1)
        branchBotID = branchesDataStore.load(fromBranchName: "develop")?.botID
    }

    private func setUpMockedNetwork() {
        mockedNetwork = MockNetwork()
        mockedNetwork.expectCreateBot()
        mockedNetwork.stubGetBot(withID: validBotID, name: "develop")
        mockedNetwork.stubGetBotError(withID: invalidBotID, statusCode: 404)
        mockedNetwork.stubbedGetBotResponseID = newBotID
    }
}
