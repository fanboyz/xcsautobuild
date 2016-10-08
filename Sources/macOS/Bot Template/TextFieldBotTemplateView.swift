//
//  Copyright (c) 2016 Sean Henry
//

import Foundation
import AppKit

class TextFieldBotTemplateView: NSView {

    var eventHandler: BotTemplateEventHandler!
    @IBOutlet var botNameField: NSTextField!
    @IBOutlet var resultLabel: NSTextField!

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        resultLabel.isHidden = true
    }

    @IBAction func didClickActionButton(_ sender: AnyObject) {
        eventHandler.create(templateFromName: botNameField.stringValue)
    }
}

extension TextFieldBotTemplateView: BotTemplateView {

    func showFailure() {
        resultLabel.isHidden = false
        resultLabel.stringValue = "❌"
    }

    func showSuccess() {
        resultLabel.isHidden = false
        resultLabel.stringValue = "✅"
    }
}
