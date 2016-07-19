//
//  NewBranchesFetcher.swift
//
//
//

import Foundation

protocol NewBranchesFetcher {
    func fetchNewBranches(completion: ([Branch]) -> ())
}
