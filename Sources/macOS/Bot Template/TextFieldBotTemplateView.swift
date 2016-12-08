
import Foundation
import AppKit

class TextFieldBotTemplateView: NSView {

    var eventHandler: BotTemplateEventHandler!
    @IBOutlet var botNameField: NSTextField!
    @IBOutlet var resultLabel: NSTextField!
    @IBOutlet var actionButton: NSButton!

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        resultLabel.isHidden = true
    }

    @IBAction func didClickActionButton(_ sender: AnyObject) {
        eventHandler.createTemplate(fromName: botNameField.stringValue)
    }

    var isEnabled: Bool = true {
        didSet {
            botNameField.isEnabled = isEnabled
            actionButton.isEnabled = isEnabled
        }
    }
    
    func display(botName: String) {
        botNameField.stringValue = botName
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
