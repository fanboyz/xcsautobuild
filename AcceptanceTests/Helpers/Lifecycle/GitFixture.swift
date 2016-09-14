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

    func setUpGit(branches branches: String...) {
        setUpGit(branches: branches)
    }

    func setUpGit(branches branches: [String]) {
        remove(file: testLocalGitURL)
        remove(file: testRemoteGitURL)
        remove(file: testXCSGitURL)
        gitBuilder = nil
        gitBuilder = TwoRemoteGitBuilder(localURL: testLocalGitURL, remoteURL: testRemoteGitURL, xcsURL: testXCSGitURL)
        for branch in branches {
            gitBuilder.add(branch: branch)
        }
    }

    func remove(file file: NSURL) {
        _ = try? NSFileManager.defaultManager().removeItemAtURL(file)
    }
}
