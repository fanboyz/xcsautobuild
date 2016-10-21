
import Foundation

struct Branch: Equatable {
    let name: String
}

func ==(lhs: Branch, rhs: Branch) -> Bool {
    return lhs.name == rhs.name
}
