//
//  MainThreadCompletable.swift
//
//
//

import Foundation

protocol MainThreadCompletable {
    func wrapInMainThread<T>(closure: ((T) -> ())?) -> (T) -> ()
}
