//
//  BranchPersister.swift
//
//
//

import Foundation

protocol BranchPersister {
    func load() -> [String]
    func save(branches: [String])
}
