
class BotManagementLauncher {

    func launch() -> Command? {
        guard let configuration = Dependencies.gitConfigurationDataStore.load(),
              let xcsConfiguration = Dependencies.xcsConfigurationDataStore.load() else { return nil }
        return BotSyncingInteractor(
            branchFetcher: GitBranchFetcher(directory: configuration.directory, remoteName: configuration.remoteName, credentialProvider: try! configuration.credentialProvider()),
            botSynchroniser: Dependencies.botSynchroniser(requestSender: Dependencies.createRequestSender(xcsConfiguration: xcsConfiguration)),
            branchFilter: Dependencies.wildcardBranchFilter,
            botDataStore: Dependencies.synchronisedBotsDataStore
        )
    }
}
