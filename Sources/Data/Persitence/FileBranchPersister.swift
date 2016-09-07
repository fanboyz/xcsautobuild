//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

class FileBranchPersister: BranchPersister {

    private let file: String

    init(file: String) {
        self.file = file
    }

    func load() -> [String] {
        return NSArray(contentsOfFile: file) as? [String] ?? []
    }

    func save(branches: [String]) {
        NSArray(array: branches).writeToFile(file, atomically: true)
    }
}
