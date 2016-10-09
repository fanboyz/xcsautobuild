import Foundation

class BotNameConverter {
    
    static func convertToBotName(branchName: String) -> String {
        return "xcsautobuild [\(branchName)]"
    }
}
