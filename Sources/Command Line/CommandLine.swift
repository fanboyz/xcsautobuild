//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

struct CommandLine {

    private(set) var directory: String

    init(directory: String) {
        self.directory = directory
    }

    func execute(_ command: String) -> String {
        let components = command.components(separatedBy: " ")

        let task = Process()
        task.currentDirectoryPath = directory
        task.launchPath = self.command(from: components)
        task.arguments = arguments(from: components)

        let pipe = Pipe()
        task.standardOutput = pipe

        task.launch()
        task.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: String.Encoding.utf8)!
    }

    mutating func cd(_ path: String) {
        let result = execute("/usr/bin/cd \(path)")
        if result == "" {
            directory += "/" + path
        }
    }

    func mkdir(_ path: String) {
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
