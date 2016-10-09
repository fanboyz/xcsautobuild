//
//  Copyright (c) 2016 Sean Henry
//

import Foundation
import ObjectiveGit

class GitBranchFetcher: BranchFetcher {

    private let remoteName: String
    private let repo: GTRepository
    private let credential: GTCredential

    init(directory: String, remoteName: String, credential: GTCredential) {
        self.remoteName = remoteName
        self.credential = credential
        repo = try! GTRepository(url: URL(fileURLWithPath: directory))
    }

    func fetchBranches() -> [Branch] {
        guard let remote = try? GTRemote(name: remoteName, in: repo) else { return [] }
        let options: [String: Any] = [
            GTRepositoryRemoteOptionsFetchPrune: true,
            GTRepositoryRemoteOptionsCredentialProvider: credentialProvider()
        ]
        try! repo.fetch(remote, withOptions: options, progress: nil)
        let branches = try! repo.remoteBranches()
        return branches
            .filter { $0.remoteName == remoteName }
            .flatMap { $0.shortName }
            .map { Branch(name: $0) }
    }
    
    private func credentialProvider() -> GTCredentialProvider {
        return GTCredentialProvider { [unowned self] (_, _, _) -> GTCredential in
            self.credential
        }
    }
}
