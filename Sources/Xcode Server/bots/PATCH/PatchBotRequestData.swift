
import Foundation

struct PatchBotRequestData: Equatable {
    var id: String
    var dictionary: [String: Any]
}

func ==(lhs: PatchBotRequestData, rhs: PatchBotRequestData) -> Bool {
    return lhs.id == rhs.id
        && lhs.dictionary as NSDictionary == rhs.dictionary as NSDictionary
}
