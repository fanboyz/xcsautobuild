//
//  Network.swift
//
//
//

import Foundation

protocol Network {
    func send(request: HTTPRequest, completion: ((NSData) -> ())?)
}
