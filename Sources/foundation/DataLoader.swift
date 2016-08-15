//
//  DataLoader.swift
//
//
//

import Foundation

protocol DataLoader {
    func loadData(from file: String) -> NSData?
}

class DefaultDataLoader: DataLoader {

    func loadData(from file: String) -> NSData? {
        return NSData(contentsOfFile: file)
    }
}
