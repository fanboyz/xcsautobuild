
import Foundation

protocol BotsFetcher {
    func getBots(_ completion: (([RemoteBot]) -> ()))
}
