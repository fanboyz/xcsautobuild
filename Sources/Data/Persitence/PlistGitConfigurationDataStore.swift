
import Foundation

class PlistGitConfigurationDataStore: DataStore {

    private let file: URL

    init(file: URL) {
        self.file = file
    }

    func load() -> GitConfiguration? {
        guard let dictionary = NSDictionary(contentsOf: file) else { return nil }
        return GitConfiguration(dictionary: dictionary)
    }

    func save(_ data: GitConfiguration) {
        data.dictionary.write(to: file, atomically: true)
    }
}

extension GitConfiguration {

    fileprivate init?(dictionary: NSDictionary) {
        guard let directory = dictionary["directory"] as? String,
            let remoteName = dictionary["remoteName"] as? String,
            let credentialDictionary = dictionary["credential"] as? NSDictionary,
            let credential = GitConfiguration.Credential(dictionary: credentialDictionary) else { return nil }
        self.init(directory: URL(fileURLWithPath: directory), remoteName: remoteName, credential: credential)
    }

    fileprivate var dictionary: NSDictionary {
        return [
            "directory": directory.path,
            "remoteName": remoteName,
            "credential": credential.dictionary
        ]
    }
}

extension GitConfiguration.Credential {

    private typealias Credential = GitConfiguration.Credential

    fileprivate init?(dictionary: NSDictionary) {
        if let http = dictionary["http"] as? NSDictionary,
           let (userName, password) = Credential.httpCredential(from: http) {
            self = .http(userName: userName, password: password)
        } else if let ssh = dictionary["ssh"] as? NSDictionary,
                  let (userName, password, publicKeyFile, privateKeyFile) = Credential.sshCredential(from: ssh) {
            self = .ssh(userName: userName, password: password, publicKeyFile: publicKeyFile, privateKeyFile: privateKeyFile)
        } else {
            return nil
        }
    }

    private static func httpCredential(from dictionary: NSDictionary) -> (userName: String, password: String)? {
        guard let userName = dictionary["userName"] as? String,
              let password = dictionary["password"] as? String else { return nil }
        return (userName: userName, password: password)
    }

    private static func sshCredential(from dictionary: NSDictionary) -> (userName: String, password: String, publicKeyFile: URL, privateKeyFile: URL)? {
        guard let userName = dictionary["userName"] as? String,
              let password = dictionary["password"] as? String,
              let publicKeyFile = dictionary["publicKeyFile"] as? String,
              let privateKeyFile = dictionary["privateKeyFile"] as? String else { return nil }
        return (userName: userName, password: password, publicKeyFile: URL(fileURLWithPath: publicKeyFile), privateKeyFile: URL(fileURLWithPath: privateKeyFile))
    }

    fileprivate var dictionary: NSDictionary {
        switch self {
        case let .http(userName, password):
            return [
                "http": [
                    "userName": userName,
                    "password": password
                ]
            ]
        case let .ssh(userName, password, publicKeyFile, privateKeyFile):
            return [
                "ssh": [
                    "userName": userName,
                    "password": password,
                    "publicKeyFile": publicKeyFile.path,
                    "privateKeyFile": privateKeyFile.path
                ]
            ]
        }
    }
}
