//
// Created by Sean Henry on 06/09/2016.
//

import Foundation

class IgnoreMasterBranchFilter: BranchFilter {

    func filter(_ branches: [Branch]) -> [Branch] {
        return branches.filter { $0.name != "master" }
    }
}
