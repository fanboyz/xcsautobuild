//
//  GitBranchFetcher.swift
//
//
//

import Foundation

class GitBranchFetcher: BranchFetcher {

    private let remoteName = "origin"
    private let ciServerName = "xcs"
    private let commandLine: CommandLine

    init(commandLine: CommandLine) {
        self.commandLine = commandLine
    }

    func getRemoteBranchNames() -> [String] {
        gitCommand("fetch --prune")
        copyRemoteBranchesToCIRemote()
        let branches = gitCommand("branch -r")
        return branches.componentsSeparatedByString("\n")
            .map(byTrimmingWhitespace)
            .filter(isCIServerBranch)
            .map(byTimmingServerName)
    }

    private func copyRemoteBranchesToCIRemote() {
        gitCommand("push --prune \(ciServerName) +refs/remotes/\(remoteName)/*:refs/heads/*")
    }

    private func gitCommand(arguments: String) -> String {
        return commandLine.execute("/usr/bin/git \(arguments)")
    }

    private func byTrimmingWhitespace(branch: String) -> String {
        return branch.stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
    }

    private func isCIServerBranch(branch: String) -> Bool {
        return branch.hasPrefix(ciServerName)
    }

    private func byTimmingServerName(branch: String) -> String {
        return branch.stringByReplacingCharactersInRange(branch.startIndex...branch.startIndex.advancedBy(ciServerName.characters.count), withString: "")
    }
}
