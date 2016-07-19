//
//  GitBranchFetcher.swift
//
//
//

import Foundation

class GitBranchFetcher: BranchFetcher {

    private let git = "/usr/bin/git"
    private let remoteName = "origin"

    func getRemoteBranchNames() -> [String] {
        let branches = system(git, arguments: "fetch", remoteName, "--prune")!
        copyRemoteBranchesToCIRemote()
        return branches.componentsSeparatedByString("\n").filter { !$0.isEmpty }
    }

    private func copyRemoteBranchesToCIRemote() {
        let ciServerName = "ci"
        system(git, arguments: "push", ciServerName, "--prune", "+refs/remotes/\(remoteName)/*:refs/heads/*")
    }
}
