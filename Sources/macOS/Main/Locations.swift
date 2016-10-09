import Foundation

class Locations {
    
    static let botTemplateFile: URL = {
        directory.appendingPathComponent("templates")
    }()
    
    static let branchesDataStore: URL = {
        directory.appendingPathComponent("branchesData")
    }()
    
    private static let directory: URL = {
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("codes.seanhenry.xcsautobuild")
    }()
}
