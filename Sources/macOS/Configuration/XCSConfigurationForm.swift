import AppKit

class XCSConfigurationForm: NSView, XCSConfigurationView, NSTextFieldDelegate {

    @IBOutlet private var hostField: NSTextField!
    @IBOutlet private var userNameField: NSTextField!
    @IBOutlet private var passwordField: NSTextField!

    var eventHandler: XCSConfigurationViewEventHandler! {
        didSet {
            eventHandler.refresh()
        }
    }

    func showHost(_ host: String) {
        hostField.stringValue = host
    }

    func showUserName(_ userName: String) {
        userNameField.stringValue = userName
    }

    func showPassword(_ password: String) {
        passwordField.stringValue = password
    }

    override func controlTextDidEndEditing(_ obj: Notification) {
        let textField = obj.object! as! NSTextField
        let text = textField.stringValue
        if textField == hostField {
            eventHandler.didChangeHost(text)
        } else if textField == userNameField {
            eventHandler.didChangeUserName(text)
        } else if textField == passwordField {
            eventHandler.didChangePassword(text)
        }
    }
}
