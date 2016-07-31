//
//  GitBranchFetcher.swift
//
//
//

import Foundation

class GitBranchFetcher: BranchFetcher {

    private let remoteName = "origin"
    private let ciServerName = "xcs"

    func getRemoteBranchNames() -> [String] {
        gitCommand("fetch --prune")
        copyRemoteBranchesToCIRemote()
        let branches = gitCommand("branch -r")
        return branches.componentsSeparatedByString("\n")
            .map { $0.stringByTrimmingCharactersInSet(.whitespaceCharacterSet()) }
            .filter { $0.hasPrefix(ciServerName) }
    }

    private func copyRemoteBranchesToCIRemote() {
        gitCommand("push --prune \(ciServerName) +refs/remotes/\(remoteName)/*:refs/heads/*")
    }

    private func gitCommand(arguments: String) -> String {
        return command.execute("/usr/bin/git \(arguments)")
    }
}
