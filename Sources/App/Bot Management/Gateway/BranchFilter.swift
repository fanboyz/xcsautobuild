
import Foundation

protocol BranchFilter {
    func filter(_ branches: [Branch]) -> [Branch]
}
