//
// Created by Sean Henry on 11/09/2016.
//

import Foundation

struct XCSBranch: Equatable {
    let name: String
    let botID: String?
}

func ==(lhs: XCSBranch, rhs: XCSBranch) -> Bool {
    return lhs.name == rhs.name
        && lhs.botID == rhs.botID
}
