//
//  XcodeServerSynchronisation.swift
//
//
//

import Foundation

class XcodeServerSynchronisation: DecisionTable, GitFixture {

    // MARK: - Input
    var existingBotID: String!
    var botID: String? {
        return existingBotID != "" ? existingBotID : nil
    }

    // MARK: - Test
    let validBotID = "valid_bot_id"
    let invalidBotID = "invalid_bot_id"
    let newBotID = "new_bot_id"
    let branch = "develop"
    var gitBuilder: TwoRemoteGitBuilder!
    var mockedNetwork: MockNetwork!
    var interactor: BotSyncingInteractor!
    var branchesDataStore: FileXCSBranchesDataStore!

    override func setUp() {
        setUpMockedNetwork()
        FileBotTemplatePersister(file: testTemplateFile).save(testBotTemplate)
    }

    override func test() {
        setUpBranchesDataStore()
        interactor = BotSyncingInteractor(
            branchFetcher: GitBranchFetcher(directory: testLocalGitURL.path)!,
            botSynchroniser: testBotSynchroniser,
            branchFilter: TransparentBranchFilter(),
            branchesDataStore: branchesDataStore
        )

        interactor.execute()
    }

    private func setUpBranchesDataStore() {
        branchesDataStore = FileXCSBranchesDataStore(file: testDataStoreFile)
        branchesDataStore.save(branch: XCSBranch(name: branch, botID: botID))
    }

    func setUpMockedNetwork() {
        mockedNetwork = MockNetwork()
    }
}
