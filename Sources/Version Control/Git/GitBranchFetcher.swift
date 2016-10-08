//
//  Copyright (c) 2016 Sean Henry
//

import Foundation
import ObjectiveGit

class GitBranchFetcher: BranchFetcher {

    private let remoteName = "origin"
    private let ciServerName = "xcs"
    private let commandLine: CommandLine
    private let repo: GTRepository

    init?(directory: String) {
        commandLine = CommandLine(directory: directory)
        repo = try! GTRepository(url: URL(fileURLWithPath: directory))
    }

    func fetchBranches() -> [Branch] {
        guard let remote = try? GTRemote(name: remoteName, in: repo) else { return [] }
        try! repo.fetch(remote, withOptions: [GTRepositoryRemoteOptionsFetchPrune: true], progress: nil)
        copyRemoteBranchesToCIRemote()
        let branches = try! repo.remoteBranches()
        return branches.filter { $0.remoteName == ciServerName }
            .flatMap { $0.shortName }
            .map { Branch(name: $0) }
    }

    private func copyRemoteBranchesToCIRemote() {
        gitCommand("push --prune \(ciServerName) +refs/remotes/\(remoteName)/*:refs/heads/*")
    }

    @discardableResult private func gitCommand(_ arguments: String) -> String {
        return commandLine.execute("/usr/bin/git \(arguments)")
    }
}
