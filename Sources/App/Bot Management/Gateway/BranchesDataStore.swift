//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

protocol BranchesDataStore {
    func load()
    func getAllBranches() -> [Branch]
    func getDeletedBranches() -> [Branch]
    func commit()
}
