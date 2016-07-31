//
//  Network.swift
//
//
//

import Foundation

protocol Network {
    func send(request: HTTPRequest)
    func send(request: HTTPRequest, completion: (NSData) -> ())
}
