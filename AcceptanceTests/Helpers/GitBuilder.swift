
import Foundation
import ObjectiveGit

class GitBuilder {

    private let localRepo: GTRepository
    private let remoteRepo: GTRepository
    private let remoteURL: URL
    let localURL: URL
    var localPath: String { return localURL.path }

    init(localURL: URL, remoteURL: URL) {
        self.localURL = localURL
        self.remoteURL = remoteURL
        remoteRepo = GitBuilder.createRemote(remoteURL)
        localRepo = GitBuilder.createLocal(from: remoteURL, to: localURL)
        makeInitialCommit()
    }

    deinit {
        removeRepos()
    }

    func add(branch: String) {
        guard try! remoteRepo.localBranches().index(where: { $0.shortName == branch }) == nil else { return }
        let currentBranch = try! remoteRepo.currentBranch()
        try! remoteRepo.createBranchNamed(branch, from: currentBranch.oid!, message: nil)
    }

    private func makeInitialCommit() {
        let builder = try! GTTreeBuilder(tree: nil, repository: remoteRepo)
        try! builder.addEntry(with: "initial".data(using: String.Encoding.utf8)!, fileName: "initial", fileMode: .blob)
        let tree = try! builder.writeTree()
        try! remoteRepo.createCommit(with: tree, message: "initial commit", parents: nil, updatingReferenceNamed: "HEAD")
    }

    private static func createRemote(_ url: URL) -> GTRepository {
        return try! GTRepository.initializeEmpty(atFileURL: url, options: nil)
    }

    private static func createLocal(from remote: URL, to local: URL) -> GTRepository {
        return try! GTRepository.clone(from: remote, toWorkingDirectory: local, options: nil, transferProgressBlock: nil, checkoutProgressBlock: nil)
    }

    private func removeRepos() {
        GitBuilder.remove(file: remoteURL)
        GitBuilder.remove(file: localURL)
    }

    private static func remove(file: URL) {
        _ = try? FileManager.default.removeItem(at: file)
    }
}
