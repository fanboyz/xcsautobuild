//
//  BotFetcher.swift
//
//
//

import Foundation

protocol BotTemplatesFetcher {
    func fetchBotTemplates(completion: ([BotTemplate]) -> ())
}
