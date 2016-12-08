import Foundation

class Locations {
    
    static let botTemplateFile: URL = {
        directory.appendingPathComponent("botTemplate.json")
    }()
    
    static let synchronisedBotsFile: URL = {
        directory.appendingPathComponent("botDataStore.plist")
    }()

    static let patternFile: URL = {
        directory.appendingPathComponent("pattern.txt")
    }()

    static let xcsConfigurationFile: URL = {
        directory.appendingPathComponent("xcsConfiguration.plist")
    }()

    static let gitConfigurationFile: URL = {
        directory.appendingPathComponent("gitConfiguration.plist")
    }()

    static let directory: URL = {
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(Bundle.main.bundleIdentifier!)
    }()
}
