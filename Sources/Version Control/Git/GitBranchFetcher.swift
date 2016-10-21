
import Foundation
import ObjectiveGit

class GitBranchFetcher: BranchFetcher {

    private let remoteName: String
    private let repo: GTRepository
    private let credentialProvider: GTCredentialProvider

    init(directory: String, remoteName: String, credentialProvider: GTCredentialProvider) {
        self.remoteName = remoteName
        self.credentialProvider = credentialProvider
        repo = try! GTRepository(url: URL(fileURLWithPath: directory))
    }

    func fetchBranches() -> [Branch] {
        guard let remote = try? GTRemote(name: remoteName, in: repo) else { return [] }
        let options: [String: Any] = [
            GTRepositoryRemoteOptionsFetchPrune: false,
            GTRepositoryRemoteOptionsCredentialProvider: credentialProvider
        ]
        try! repo.fetch(remote, withOptions: options, progress: nil)
        let branches = try! repo.remoteBranches()
        return branches
            .filter { $0.remoteName == remoteName }
            .flatMap { $0.shortName }
            .map { Branch(name: $0) }
    }
}
