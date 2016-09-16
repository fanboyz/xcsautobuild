//
//  DecisionTable.swift
//
//
//

import Foundation

class DecisionTable: NSObject, SlimDecisionTable {

    func setUp() {
    }

    func tearDown() {
    }

    func test() {
    }

    func reset() {
        createFiles()
    }

    func execute() {
        setUp()
        test()
        tearDown()
        removeFiles()
    }

    private func createFiles() {
        create(directory: NSURL(fileURLWithPath: testGitPath))
    }

    private func create(directory directory: NSURL) {
        _ = try? NSFileManager.defaultManager().createDirectoryAtURL(directory, withIntermediateDirectories: true, attributes: nil)
    }

    private func removeFiles() {
        _ = try? NSFileManager.defaultManager().removeItemAtURL(NSURL(fileURLWithPath: testPath))
    }
}
