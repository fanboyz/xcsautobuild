//
//  Copyright (c) 2016 Sean Henry
//

@testable import xcsautobuild

class MockCommand: Command {

    var didExecute = false
    func execute() {
        didExecute = true
    }
}
