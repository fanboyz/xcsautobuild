
import Foundation

struct Bot: Equatable {
    let branchName: String
    let id: String?
}

func ==(lhs: Bot, rhs: Bot) -> Bool {
    return lhs.branchName == rhs.branchName
        && lhs.id == rhs.id
}
