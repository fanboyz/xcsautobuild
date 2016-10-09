//
//  GitFixture.swift
//
//
//

import Foundation

protocol GitFixture: class {
    var gitBuilder: GitBuilder! { get set }
}

extension GitFixture {

    func setUpGit(branches: String...) {
        setUpGit(branches: branches)
    }

    func setUpGit(branches: [String]) {
        remove(file: testLocalGitURL)
        remove(file: testRemoteGitURL)
        gitBuilder = nil
        gitBuilder = GitBuilder(localURL: testLocalGitURL, remoteURL: testRemoteGitURL)
        for branch in branches {
            gitBuilder.add(branch: branch)
        }
    }

    func remove(file: URL) {
        _ = try? FileManager.default.removeItem(at: file)
    }
}
