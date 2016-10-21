
import ObjectiveGit

struct Configuration {
    static let xcsHostName = ""
    static let xcsUserName = ""
    static let xcsPassword = ""
    static let gitRemoteName = ""
    static let gitDirectory = ""
    static let gitCredentialProvider = GTCredentialProvider { _ in
        return GTCredential()
    }
}
