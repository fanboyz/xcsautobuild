
import Foundation

protocol BotTemplatesFetcher {
    func fetchBotTemplates(_ completion: @escaping ([BotTemplate]) -> ())
}
