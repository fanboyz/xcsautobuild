//
//  Copyright (c) 2016 Sean Henry
//

import Foundation
import ObjectiveGit

class TwoRemoteGitBuilder {

    private let localRepo: GTRepository
    private let remoteRepo: GTRepository
    private let xcsRepo: GTRepository
    private let commandLine = CommandLine.createTestCommandLine()
    private let remoteURL: NSURL
    private let xcsURL: NSURL
    let localURL: NSURL

    init() {
        remoteURL = NSURL(fileURLWithPath: "\(commandLine.directory)/origin")
        localURL = NSURL(fileURLWithPath: "\(commandLine.directory)/local")
        xcsURL = NSURL(fileURLWithPath: "\(commandLine.directory)/xcs")
        remoteRepo = TwoRemoteGitBuilder.createRemote(remoteURL)
        localRepo = TwoRemoteGitBuilder.createLocal(from: remoteURL, to: localURL)
        xcsRepo = TwoRemoteGitBuilder.createRemote(xcsURL)
        createXCSRemote()
        makeInitialCommit()
    }

    deinit {
        commandLine.removeTestDirectory()
    }

    func add(branch branch: String) {
        guard try! remoteRepo.localBranches().indexOf({ $0.shortName == branch }) == nil else { return }
        let currentBranch = try! remoteRepo.currentBranch()
        try! remoteRepo.createBranchNamed(branch, fromOID: currentBranch.OID!, message: nil)
    }

    private func makeInitialCommit() {
        let builder = try! GTTreeBuilder(tree: nil, repository: remoteRepo)
        try! builder.addEntryWithData("initial".dataUsingEncoding(NSUTF8StringEncoding)!, fileName: "initial", fileMode: .Blob)
        let tree = try! builder.writeTree()
        try! remoteRepo.createCommitWithTree(tree, message: "initial commit", parents: nil, updatingReferenceNamed: "refs/heads/master")
    }

    private static func createRemote(url: NSURL) -> GTRepository {
        return try! GTRepository.initializeEmptyRepositoryAtFileURL(url, options: nil)
    }

    private static func createLocal(from remote: NSURL, to local: NSURL) -> GTRepository {
        return try! GTRepository.cloneFromURL(remote, toWorkingDirectory: local, options: nil, transferProgressBlock: nil, checkoutProgressBlock: nil)
    }

    private func createXCSRemote() {
        try! GTRemote.createRemoteWithName("xcs", URLString: xcsURL.path!, inRepository: localRepo)
    }
}

extension CommandLine {

    private static var tempDirectory: String { return NSTemporaryDirectory() }
    private static var testDirectoryName: String { return "fitnesse_tests" }

    private static func createTestCommandLine() -> CommandLine {
        var commandLine = CommandLine(directory: tempDirectory)
        commandLine.removeTestDirectory()
        commandLine.createTestDirectory()
        commandLine.cd(testDirectoryName)
        return commandLine
    }

    private func removeTestDirectory() {
        _ = try? NSFileManager.defaultManager().removeItemAtPath("\(CommandLine.tempDirectory)\(CommandLine.testDirectoryName)")
    }

    private func createTestDirectory() {
        mkdir(CommandLine.testDirectoryName)
    }
}
