
import XCTest
@testable import xcsautobuild

class XCSHTTPRequestSenderTests: XCTestCase {
    
    var requestSender: XCSHTTPRequestSender!
    var mockedSession: MockNSURLSession!
    let encodedCredentials = "dXNlcm5hbWU6cGFzc3dvcmQ="
    let configuration = XCSHTTPRequestSender.Configuration(baseURL: testURL, username: "username", password: "password")
    
    override func setUp() {
        super.setUp()
        mockedSession = MockNSURLSession()
        requestSender = XCSHTTPRequestSender(session: mockedSession, configuration: configuration)
    }

    // MARK: - session

    func test_session_shouldSetDelegate() {
        requestSender = XCSHTTPRequestSender(configuration: configuration)
        XCTAssert(requestSender.session.delegate === requestSender.delegate)
    }
    
    // MARK: - sendRequest
    
    func test_sendRequest_shouldRunDataTask() {
        sendRequest()
        XCTAssert(mockedSession.didCreateDataTask)
        XCTAssert(mockedSession.stubbedDataTask.didResume)
    }

    func test_sendRequest_shouldCompleteWithNoData_whenNoData() {
        mockedSession.stubbedData = nil
        XCTAssertNil(sendRequest().data)
    }

    func test_sendRequest_shouldCompleteWithData() {
        mockedSession.stubbedData = testData
        XCTAssertEqual(sendRequest().data, testData)
    }

    func test_sendRequest_shouldSetHeaders() {
        sendRequest()
        let headers = mockedSession.invokedRequest?.allHTTPHeaderFields
        XCTAssertEqual(headers?["X-XCSClientVersion"], "6") 
        XCTAssertEqual(headers?["Authorization"], "Basic \(encodedCredentials)")
        XCTAssertEqual(headers?["Content-Type"], "application/json")
    }

    func test_sendRequest_shouldSetHTTPMethod() {
        requestSender.send(createPostRequest(), completion: nil)
        XCTAssertEqual(mockedSession.invokedRequest?.httpMethod, "POST")
        sendRequest()
        XCTAssertEqual(mockedSession.invokedRequest?.httpMethod, "GET")
    }

    func test_sendRequest_shouldSetBody_whenPOST() {
        requestSender.send(createPostRequest(), completion: nil)
        XCTAssertEqual(mockedSession.invokedRequest?.httpBody, jsonData())
    }

    func test_sendRequest_shouldSetBody_whenPATCH() {
        requestSender.send(createPatchRequest(), completion: nil)
        XCTAssertEqual(mockedSession.invokedRequest?.httpBody, jsonData())
    }

    func test_sendRequest_shouldNotSetBody_whenGET() {
        requestSender.send(createGetRequestWithJSON(), completion: nil)
        XCTAssertNil(mockedSession.invokedRequest?.httpBody)
    }

    func test_sendRequest_shouldSetURL() {
        sendRequest()
        XCTAssertEqual(mockedSession.invokedRequest?.url, URL(string: configuration.baseURL.absoluteString + testRequest.path))
    }

    func test_sendRequest_shouldReturnNilStatusCode_whenResponseIsNil() {
        XCTAssertNil(sendRequest().statusCode)
    }

    func test_sendRequest_shouldReturnNilStatusCode_whenWrongType() {
        mockedSession.stubbedResponse = URLResponse(url: testURL, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        XCTAssertNil(sendRequest().statusCode)
    }

    // MARK: - Helpers

    @discardableResult func sendRequest() -> (data: Data?, statusCode: Int?) {
        var response: (Data?, Int?)!
        requestSender.send(testRequest) { r in
            response = r
        }
        return response
    }

    func createPostRequest() -> HTTPRequest {
        return HTTPRequest(path: testRequest.path, method: .post, jsonBody: json())
    }

    func createPatchRequest() -> HTTPRequest {
        return HTTPRequest(path: testRequest.path, method: .patch, jsonBody: json())
    }

    func createGetRequestWithJSON() -> HTTPRequest {
        return HTTPRequest(path: testRequest.path, method: .get, jsonBody: json())
    }

    func json() -> [String: Any] {
        return [
            "hello": "world"
        ]
    }

    func jsonData() -> Data {
        return try! JSONSerialization.data(withJSONObject: json(), options: [])
    }
}
