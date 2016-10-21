
import Foundation

class IgnoreMasterBranchFilter: BranchFilter {

    func filter(_ branches: [Branch]) -> [Branch] {
        return branches.filter { $0.name != "master" }
    }
}
