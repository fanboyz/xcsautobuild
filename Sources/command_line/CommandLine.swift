//
//  CommandLine.swift
//
//
//

import Foundation

func system(command: String, arguments: String...) -> String? {
    let task = NSTask()
    task.launchPath = command
    task.arguments = arguments

    let pipe = NSPipe()
    task.standardOutput = pipe

    task.launch()
    task.waitUntilExit()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    return String(data: data, encoding: NSUTF8StringEncoding)
}
