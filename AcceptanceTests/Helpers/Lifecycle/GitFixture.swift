//
//  GitFixture.swift
//
//
//

import Foundation

protocol GitFixture: class {
    var gitBuilder: TwoRemoteGitBuilder! { get set }
}

extension GitFixture {

    func setUpGit(branches: String...) {
        setUpGit(branches: branches)
    }

    func setUpGit(branches: [String]) {
        remove(file: testLocalGitURL)
        remove(file: testRemoteGitURL)
        remove(file: testXCSGitURL)
        gitBuilder = nil
        gitBuilder = TwoRemoteGitBuilder(localURL: testLocalGitURL, remoteURL: testRemoteGitURL, xcsURL: testXCSGitURL)
        for branch in branches {
            gitBuilder.add(branch: branch)
        }
    }

    func remove(file: URL) {
        _ = try? FileManager.default.removeItem(at: file)
    }
}
