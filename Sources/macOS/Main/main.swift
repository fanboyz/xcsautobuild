
import Foundation
import AppKit

class TestAppDelegate: NSResponder, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {}
}

autoreleasepool {
    let application = NSApplication.shared()
    let delegate: NSApplicationDelegate = ProcessInfo.processInfo.environment["TEST"] != nil ? TestAppDelegate() : AppDelegate()
    application.delegate = delegate
    application.run()
}
