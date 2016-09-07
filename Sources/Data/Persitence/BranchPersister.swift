//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

protocol BranchPersister {
    func load() -> [String]
    func save(branches: [String])
}
