//
//  NSURLSessionNetwork.swift
//
//
//

import Foundation

class NSURLSessionNetwork: Network {

    struct Configuration {
        let username: String
        let password: String
    }

    private let configuration: Configuration
    let session: NSURLSession
    let delegate: NSURLSessionDelegate

    init(session: NSURLSession, configuration: Configuration) {
        delegate = NSURLSessionNetworkDelegate()
        self.session = session
        self.configuration = configuration
    }

    init(configuration: Configuration) {
        let delegate = NSURLSessionNetworkDelegate()
        session = NSURLSession(configuration: .defaultSessionConfiguration(), delegate: delegate, delegateQueue: nil)
        self.delegate = delegate
        self.configuration = configuration
    }

    func send(request: HTTPRequest, completion: ((NSData) -> ())?) {
        let task = session.dataTaskWithRequest(buildRequest(request)) { data, _, _ in
            completion?(data ?? NSData())
        }
        task.resume()
    }

    private func buildRequest(httpRequest: HTTPRequest) -> NSURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: httpRequest.url)!)
        request.HTTPBody = body(from: httpRequest)
        request.HTTPMethod = httpRequest.method.rawValue
        request.addValue("5", forHTTPHeaderField: "X-XCSClientVersion")
        request.addValue("Basic \(encodedCredentials())", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }

    private func encodedCredentials() -> String {
        let data = "\(configuration.username):\(configuration.password)".dataUsingEncoding(NSUTF8StringEncoding)!
        return data.base64EncodedStringWithOptions([])
    }

    private func body(from request: HTTPRequest) -> NSData? {
        guard let json = request.jsonBody where request.method == .post else { return nil }
        return try? NSJSONSerialization.dataWithJSONObject(json, options: [])
    }
}

private class NSURLSessionNetworkDelegate: NSObject, NSURLSessionDelegate {

    @objc func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        let credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
        completionHandler(.UseCredential, credential)
    }
}
