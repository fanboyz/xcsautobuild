
import Foundation

struct BotTemplate: Equatable {
    let name: String
    let data: Data
}

func ==(lhs: BotTemplate, rhs: BotTemplate) -> Bool {
    return lhs.name == rhs.name
        && lhs.data == rhs.data
}
