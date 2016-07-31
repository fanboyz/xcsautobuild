//
//  Network.swift
//
//
//

import Foundation

protocol Network {
    func sendRequest(request: HTTPRequest)
    func sendRequest(request: HTTPRequest, completion: (NSData) -> ())
}
