//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

struct HTTPRequest: Equatable {
    var url: String
    var method: HTTPMethod
    var jsonBody: [String: Any]?
}

func ==(lhs: HTTPRequest, rhs: HTTPRequest) -> Bool {
    return lhs.url == rhs.url
        && lhs.method == rhs.method
        && lhs.jsonBody as NSDictionary? == rhs.jsonBody as NSDictionary?
}
