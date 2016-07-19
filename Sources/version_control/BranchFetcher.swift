//
//  BranchFetcher.swift
//
//
//

import Foundation

protocol BranchFetcher {
    func getRemoteBranchNames() -> [String]
}
