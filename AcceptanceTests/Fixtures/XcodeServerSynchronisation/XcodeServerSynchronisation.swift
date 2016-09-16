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
    var gitBuilder: TwoRemoteGitBuilder!
    var mockedNetwork: MockNetwork!
    var interactor: BotSyncingInteractor!
    var branchesDataStore: FileXCSBranchesDataStore!

    override func setUp() {
        setUpMockedNetwork()
        setUpGit(branches: "develop")
        FileBotTemplatePersister(file: testTemplateFile).save(testBotTemplate)
    }

    override func test() {
        branchesDataStore = FileXCSBranchesDataStore(file: testDataStoreFile)
        branchesDataStore.save(branch: XCSBranch(name: "develop", botID: botID))
        interactor = BotSyncingInteractor(
            branchFetcher: GitBranchFetcher(directory: testLocalGitURL.path!)!,
            botSynchroniser: testBotSynchroniser,
            branchFilter: TransparentBranchFilter(),
            branchesDataStore: branchesDataStore
        )

        interactor.execute()
    }

    func setUpMockedNetwork() {
    }
}
