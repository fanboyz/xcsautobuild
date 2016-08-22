//
//  main.swift
//
//
//

import Foundation
import AppKit

class TestAppDelegate: NSResponder, NSApplicationDelegate {
    func applicationDidFinishLaunching(notification: NSNotification) {}
}

autoreleasepool {
    let application = NSApplication.sharedApplication()
    let delegate: NSApplicationDelegate = NSProcessInfo.processInfo().environment["TEST"] != nil ? TestAppDelegate() : AppDelegate()
    application.delegate = delegate
    application.run()
}
