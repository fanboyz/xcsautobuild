
import Foundation

class PlistXCSConfigurationDataStore {

    private let file: URL

    init(file: URL) {
        self.file = file
    }

    func load() -> XCSConfiguration? {
        guard let dictionary = NSDictionary(contentsOf: file) else { return nil }
        return XCSConfiguration(dictionary: dictionary)
    }

    func save(_ configuration: XCSConfiguration) {
        configuration.dictionary.write(to: file, atomically: true)
    }
}

extension XCSConfiguration {

    init?(dictionary: NSDictionary) {
        guard let host = dictionary["host"] as? String,
            let userName = dictionary["userName"] as? String,
            let password = dictionary["password"] as? String else { return nil }
        self.init(host: host, userName: userName, password: password)
    }

    var dictionary: NSDictionary {
        return [
            "host": host,
            "userName": userName,
            "password": password
        ]
    }
}
