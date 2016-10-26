
import Foundation
import ObjectiveGit

struct GitConfiguration: Equatable {

    enum Credential: Equatable {
        case http(userName: String, password: String)
        case ssh(userName: String, password: String, publicKeyFile: URL, privateKeyFile: URL)
    }

    let directory: URL
    let remoteName: String
    let credential: Credential

    func credentialProvider() throws -> GTCredentialProvider {
        return try GTCredentialProvider { _ in
            switch self.credential {
                case let .http(userName, password):
                    return try GTCredential(userName: userName, password: password)
                case let .ssh(userName, password, publicKeyFile, privateKeyFile):
                    return try GTCredential(userName: userName, publicKeyURL: publicKeyFile, privateKeyURL: privateKeyURL, passphrase: password)
            }
        }
    }
}

func ==(lhs: GitConfiguration, rhs: GitConfiguration) -> Bool {
    return lhs.directory == rhs.directory
        && lhs.remoteName == rhs.remoteName
        && lhs.credential == rhs.credential
}

func ==(lhs: GitConfiguration.Credential, rhs: GitConfiguration.Credential) -> Bool {
    switch (lhs, rhs) {
        case let (.http(lhsUserName, lhsPassword), .http(rhsUserName, rhsPassword)):
            return lhsUserName == rhsUserName
                && lhsPassword == rhsPassword
        case let (.ssh(lhsUserName, lhsPassword, lhsPublicKeyFile, lhsPrivateKeyFile), .ssh(rhsUserName, rhsPassword, rhsPublicKeyFile, rhsPrivateKeyFile)):
            return lhsUserName == rhsUserName
                && lhsPassword == rhsPassword
                && lhsPublicKeyFile == rhsPublicKeyFile
                && lhsPrivateKeyFile == rhsPrivateKeyFile
        default:
            return false
    }
}
