//
//  TextFieldBotTemplateView.swift
//
//
//

import Foundation
import AppKit

class TextFieldBotTemplateView: NSView {

    var eventHandler: BotTemplateEventHandler!
    @IBOutlet var botNameField: NSTextField!
    @IBOutlet var resultLabel: NSTextField!

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        resultLabel.hidden = true
    }

    @IBAction func didClickActionButton(sender: AnyObject) {
        eventHandler.create(templateFromName: botNameField.stringValue)
    }
}

extension TextFieldBotTemplateView: BotTemplateView {

    func showFailure() {
        resultLabel.hidden = false
        resultLabel.stringValue = "❌"
    }

    func showSuccess() {
        resultLabel.hidden = false
        resultLabel.stringValue = "✅"
    }
}
