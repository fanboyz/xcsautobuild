//
//  BotsFetcher.swift
//
//
//

import Foundation

protocol BotsFetcher {
    func getBots(completion: (([RemoteBot]) -> ()))
}
