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
    NSApplication.sharedApplication()
    NSApp.delegate = NSProcessInfo.processInfo().environment["TEST"] != nil ? TestAppDelegate() : AppDelegate()
    NSApplicationMain(Process.argc, Process.unsafeArgv)
}
