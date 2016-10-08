//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

protocol DataLoader {
    func loadData(from file: String) -> Data?
}

class DefaultDataLoader: DataLoader {

    func loadData(from file: String) -> Data? {
        // TODO:
        return (try? Data(contentsOf: Foundation.URL(fileURLWithPath: file)))
    }
}
