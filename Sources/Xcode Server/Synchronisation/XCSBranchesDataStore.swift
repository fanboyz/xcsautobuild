//
// Created by Sean Henry on 11/09/2016.
//

import Foundation

protocol XCSBranchesDataStore {
    func load(fromBranchName name: String) -> XCSBranch?
    func save(branch branch: XCSBranch)
}
