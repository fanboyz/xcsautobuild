//
//  ShouldCreateTemplateFromBotName.swift
//
//
//

import Foundation

@objc(ShouldCreateTemplateFromBotName)
class ShouldCreateTemplateFromBotName: NSObject, SlimDecisionTable {

    // MARK: - input
    var botName: String!
    var availableBots: String!

    // MARK: - output
    var createdTemplate: String!

    // MARK: - test
    func reset() {
        botName = nil
        availableBots = nil
        createdTemplate = nil
    }

    func execute() {
        let interactor = BotTemplateCreatingInteractor(botTemplatesFetcher: Xcode)
        interactor.output = self
        interactor.execute()
    }
}

extension ShouldCreateTemplateFromBotName: BotTemplateCreatingInteractorOutput {

    func didCreateTemplate() {
        createdTemplate = yes
    }
}
