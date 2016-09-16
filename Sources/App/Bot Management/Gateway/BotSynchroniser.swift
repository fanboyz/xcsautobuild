//
// Created by Sean Henry on 12/09/2016.
//

import Foundation

protocol BotSynchroniser {
    func synchroniseBot(fromBranch branch: XCSBranch, completion: (XCSBranch) -> ())
    func deleteBot(fromBranch branch: XCSBranch, completion: (Bool) -> ())
}
