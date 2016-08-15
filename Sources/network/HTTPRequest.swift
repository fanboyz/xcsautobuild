//
//  HTTPRequest.swift
//
//
//

import Foundation

typealias URL = String
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
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
