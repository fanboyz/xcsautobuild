//
// Created by Sean Henry on 06/09/2016.
//

import Foundation

protocol BranchFilter {
    func filterBranches(_ branches: [Branch]) -> [Branch]
}
