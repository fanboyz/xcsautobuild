
import ObjectiveGit

struct Configuration {
    static let xcsHostName = "test-host"
    static let xcsUserName = "xcs_username"
    static let xcsPassword = "xcs_password"
    static let gitRemoteName = ""
    static let gitDirectory = ""
    static let gitCredentialProvider = GTCredentialProvider { _ in GTCredential() }
}
