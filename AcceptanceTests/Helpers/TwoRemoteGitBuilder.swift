//
//  Copyright (c) 2016 Sean Henry
//

import Foundation
import ObjectiveGit

class TwoRemoteGitBuilder {

    private let localRepo: GTRepository
    private let remoteRepo: GTRepository
    private let xcsRepo: GTRepository
    private let remoteURL: NSURL
    private let xcsURL: NSURL
    let localURL: NSURL
    var localPath: String { return localURL.path! }

    init(localURL: NSURL, remoteURL: NSURL, xcsURL: NSURL) {
        self.localURL = localURL
        self.remoteURL = remoteURL
        self.xcsURL = xcsURL
        remoteRepo = TwoRemoteGitBuilder.createRemote(remoteURL)
        localRepo = TwoRemoteGitBuilder.createLocal(from: remoteURL, to: localURL)
        xcsRepo = TwoRemoteGitBuilder.createRemote(xcsURL)
        createXCSRemote()
        makeInitialCommit()
    }

    deinit {
        removeRepos()
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

    private func removeRepos() {
        TwoRemoteGitBuilder.remove(file: remoteURL)
        TwoRemoteGitBuilder.remove(file: xcsURL)
        TwoRemoteGitBuilder.remove(file: localURL)
    }

    private static func remove(file file: NSURL) {
        _ = try? NSFileManager.defaultManager().removeItemAtURL(file)
    }
}
