//
//  HTTPRequest.swift
//
//
//

import Foundation

typealias URL = String
enum HTTPMethod {
    case get
    case post
    case delete
}

struct HTTPRequest: Equatable {
    var url: URL
    var method: HTTPMethod
    var jsonBody: [String: AnyObject]?
}

func ==(lhs: HTTPRequest, rhs: HTTPRequest) -> Bool {
    return lhs.url == rhs.url
        && lhs.method == rhs.method
        && lhs.jsonBody as NSDictionary? == rhs.jsonBody
}
