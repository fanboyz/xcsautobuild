import Foundation

class Locations {
    
    static let botTemplateFile: URL = {
        directory.appendingPathComponent("templates")
    }()
    
    static let botDataStore: URL = {
        directory.appendingPathComponent("botDataStore")
    }()

    static let patternFile: URL = {
        directory.appendingPathComponent("pattern")
    }()
    
    static let directory: URL = {
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(Bundle.main.bundleIdentifier!)
    }()
}
