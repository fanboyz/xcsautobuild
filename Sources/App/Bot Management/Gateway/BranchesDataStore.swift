//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

protocol BranchesDataStore {
    func load()
    func getNewBranches() -> [Branch]
    func getDeletedBranches() -> [Branch]
    func commit()
}
