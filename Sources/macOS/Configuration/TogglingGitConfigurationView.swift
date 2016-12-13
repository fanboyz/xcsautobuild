
import Foundation
import AppKit

class TogglingGitConfigurationView: NSView, GitConfigurationView, NSTextFieldDelegate {

    var eventHandler: GitConfigurationViewEventHandler! {
        didSet {
            eventHandler.refresh()
        }
    }
    @IBOutlet private var directoryField: NSTextField!
    @IBOutlet private var remoteNameField: NSTextField!
    @IBOutlet private var userNameField: NSTextField!
    @IBOutlet private var passwordField: NSTextField!
    @IBOutlet private var publicKeyFileField: NSTextField!
    @IBOutlet private var privateKeyFileField: NSTextField!
    @IBOutlet private var credentialTypePopUpButton: NSPopUpButton!
    @IBOutlet private var publicKeyFileButton: NSButton!
    @IBOutlet private var privateKeyFileButton: NSButton!
    @IBOutlet private var publicKeyFileLabel: NSTextField!
    @IBOutlet private var privateKeyFileLabel: NSTextField!
    private let httpPopUpButtonIndex = 0
    private let sshPopUpButtonIndex = 1
    
    private var sshViews: [NSView] {
        return [
            publicKeyFileField,
            privateKeyFileField,
            publicKeyFileButton,
            privateKeyFileButton,
            publicKeyFileLabel,
            privateKeyFileLabel
        ]
    }

    func showDirectory(_ directory: URL) {
        directoryField.stringValue = directory.path
    }

    func showRemoteName(_ remoteName: String) {
        remoteNameField.stringValue = remoteName
    }

    func show(userName: String, password: String) {
        userNameField.stringValue = userName
        passwordField.stringValue = password
        credentialTypePopUpButton.selectItem(at: httpPopUpButtonIndex)
    }

    func show(userName: String, password: String, publicKeyFile: URL, privateKeyFile: URL) {
        userNameField.stringValue = userName
        passwordField.stringValue = password
        publicKeyFileField.stringValue = publicKeyFile.path
        privateKeyFileField.stringValue = privateKeyFile.path
        credentialTypePopUpButton.selectItem(at: sshPopUpButtonIndex)
    }
    
    override func controlTextDidEndEditing(_ obj: Notification) {
        let textField = obj.object! as! NSTextField
        let text = textField.stringValue
        if textField == directoryField {
            eventHandler.changedDirectory(URL(fileURLWithPath: text))
        } else if textField == remoteNameField {
            eventHandler.changedRemoteName(text)
        } else if textField == userNameField
               || textField == passwordField {
            didChangeCredential()
        }
    }

    private func didChangeCredential() {
        let credential: GitConfiguration.Credential
        if credentialTypePopUpButton.indexOfSelectedItem == httpPopUpButtonIndex {
            credential = .http(
                userName: userNameField.stringValue,
                password: passwordField.stringValue
            )
        } else {
            credential = .ssh(
                userName: userNameField.stringValue,
                password: passwordField.stringValue,
                publicKeyFile: URL(fileURLWithPath: publicKeyFileField.stringValue),
                privateKeyFile: URL(fileURLWithPath: privateKeyFileField.stringValue)
            )
        }
        eventHandler.changedCredential(credential)
    }
    
    @IBAction private func didChangeCredentialType(_ sender: NSPopUpButton) {
        let isHidden = sender.indexOfSelectedItem == httpPopUpButtonIndex
        sshViews.forEach { $0.isHidden = isHidden }
        didChangeCredential()
    }
    
    @IBAction func didClickDirectoryButton(_ sender: Any) {
        choose(allowFiles: false, message: "Choose your git directory.") { [unowned self] url in
            self.eventHandler.changedDirectory(url)
        }
    }
    
    @IBAction func didClickPublicFileButton(_ sender: Any) {
        choose(allowFiles: true, message: "Choose your public ssh key.") { [unowned self] url in
            self.publicKeyFileField.stringValue = url.path
            self.didChangeCredential()
        }
    }
    
    @IBAction func didClickPrivateFileButton(_ sender: Any) {
        choose(allowFiles: true, message: "Choose your private ssh key.") { [unowned self] url in
            self.privateKeyFileField.stringValue = url.path
            self.didChangeCredential()
        }
    }
    
    private func choose(allowFiles: Bool, message: String, completion: @escaping (URL) -> ()) {
        let panel = NSOpenPanel()
        panel.canChooseFiles = allowFiles
        panel.canChooseDirectories = !allowFiles
        panel.allowsMultipleSelection = false
        panel.message = message
        panel.beginSheetModal(for: window!) { _ in
            if let url = panel.urls.first {
                completion(url)
            }
        }
    }
}
