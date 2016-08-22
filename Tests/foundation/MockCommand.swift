//
//  MockCommand.swift
//
//
//

@testable import xcsautobuild

class MockCommand: Command {

    var didExecute = false
    func execute() {
        didExecute = true
    }
}
