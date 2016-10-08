//
//  Copyright (c) 2016 Sean Henry
//

import Foundation

class NSURLSessionNetwork: Network {

    struct Configuration {
        let username: String
        let password: String
    }

    private let configuration: Configuration
    let session: URLSession
    let delegate: URLSessionDelegate

    init(session: URLSession, configuration: Configuration) {
        delegate = NSURLSessionNetworkDelegate()
        self.session = session
        self.configuration = configuration
    }

    init(configuration: Configuration) {
        let delegate = NSURLSessionNetworkDelegate()
        session = URLSession(configuration: .default, delegate: delegate, delegateQueue: OperationQueue())
        self.delegate = delegate
        self.configuration = configuration
    }

    func send(_ request: HTTPRequest, completion: ((Data?, Int?) -> ())?) {
        let task = session.dataTask(with: buildRequest(request), completionHandler: { data, response, _ in
            let httpResponse = response as? HTTPURLResponse
            completion?(data, httpResponse?.statusCode)
        }) 
        task.resume()
    }

    private func buildRequest(_ httpRequest: HTTPRequest) -> URLRequest {
        var request = URLRequest(url: URL(string: httpRequest.url)!)
        request.httpBody = body(from: httpRequest)
        request.httpMethod = httpRequest.method.rawValue
        request.addValue("5", forHTTPHeaderField: "X-XCSClientVersion")
        request.addValue("Basic \(encodedCredentials())", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }

    private func encodedCredentials() -> String {
        let data = "\(configuration.username):\(configuration.password)".data(using: String.Encoding.utf8)!
        return data.base64EncodedString(options: [])
    }

    private func body(from request: HTTPRequest) -> Data? {
        guard let json = request.jsonBody , request.method == .post else { return nil }
        return try? JSONSerialization.data(withJSONObject: json, options: [])
    }
}

private class NSURLSessionNetworkDelegate: NSObject, URLSessionDelegate {

    @objc func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, credential)
    }
}
