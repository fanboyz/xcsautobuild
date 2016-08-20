//
//  CommandLine.swift
//
//
//

import Foundation

struct CommandLine {

    private(set) var directory: String

    init(directory: String) {
        self.directory = directory
    }

    func execute(command: String) -> String {
        let components = command.componentsSeparatedByString(" ")

        let task = NSTask()
        task.currentDirectoryPath = directory
        task.launchPath = self.command(from: components)
        task.arguments = arguments(from: components)

        let pipe = NSPipe()
        task.standardOutput = pipe

        task.launch()
        task.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: NSUTF8StringEncoding)!
    }

    mutating func cd(path: String) {
        let result = execute("/usr/bin/cd \(path)")
        if result == "" {
            directory += "/" + path
        }
    }

    func mkdir(path: String) {
        execute("/bin/mkdir \(path)")
    }

    private func command(from components: [String]) -> String {
        return components.first ?? ""
    }

    private func arguments(from components: [String]) -> [String] {
        let count = components.count
        if count > 1 {
            return Array(components[1..<components.count])
        }
        return []
    }
}
