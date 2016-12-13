import Foundation

protocol GitConfigurationViewEventHandler {
    func refresh()
    func changedDirectory(_ directory: URL)
    func changedRemoteName(_ remoteName: String)
    func changedCredential(_ credential: GitConfiguration.Credential)
}
