//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

protocol BranchFetcher {
    func getRemoteBranchNames() -> [String]
}
