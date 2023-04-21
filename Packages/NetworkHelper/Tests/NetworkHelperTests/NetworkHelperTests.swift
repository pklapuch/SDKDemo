import XCTest
import NetworkHelper

final class NetworkHelperTests: XCTestCase {
    override func setUp() {
        super.setUp()
        URLProtocolSpy.startInterceptingRequests()
    }
    
    override func tearDown() {
        super.tearDown()
        URLProtocolSpy.stopInterceptingRequests()
    }
    
    func test_init_doesNotTriggerExecuteRequest() {
        _ = makeSUT()
        XCTAssertTrue(URLProtocolSpy.receivedRequests.isEmpty)
    }
    
    func test_execute_forwardsRequestToURLSessionOnce() async {
        _ = await resultErrorFor(data: nil, response: nil, error: anyNSError())
        
        XCTAssertEqual(URLProtocolSpy.receivedRequests.count, 1)
    }
    
    func test_execute_deliversErrorOnURLSessionError() async {
        let executeError = anyNSError()
        let receivedError = await resultErrorFor(data: nil, response: nil, error: executeError)
        
        XCTAssertEqual((receivedError as? NSError)?.domain, executeError.domain)
        XCTAssertEqual((receivedError as? NSError)?.code, executeError.code)
    }
    
    func test_execute_deliversSuccessOnURLSessionSuccess() async {
        let data = anyData()
        let response = anyHTTPURLResponse()
        
        let result = await resultValuesFor(data: data, response: response, error: nil)
        
        XCTAssertEqual(result?.data, data)
        XCTAssertEqual(result?.response.url, response.url)
        XCTAssertEqual(result?.response.statusCode, response.statusCode)
    }

    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> URLSessionNetworkGateway {
        let sut = URLSessionNetworkGateway()
        trackForMmeoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func resultErrorFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) async -> Error? {
        URLProtocolSpy.stub(data: data, response: response, error: error)
        do {
            _ = try await resultFor(data: data, response: response, error: error, file: file, line: line)
            return nil
        } catch {
            return error
        }
    }
    
    func resultValuesFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) async -> NetworkGateway.Result? {
        URLProtocolSpy.stub(data: data, response: response, error: error)
        
        do {
            return try await resultFor(data: data, response: response, error: error, file: file, line: line)
        } catch {
            XCTFail("expected success, got: \(error) instead", file: file, line: line)
            return nil
        }
    }
    
    private func resultFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) async throws -> NetworkGateway.Result {
        URLProtocolSpy.stub(data: data, response: response, error: error)
        let sut = makeSUT(file: file, line: line)
        return try await sut.execute(request: anyRequest())
    }
    
    private func anyRequest() -> URLRequest {
        var request = URLRequest(url: anyURL())
        request.httpMethod = "GET"
        return request
    }
    
    private func anyURL() -> URL {
        return URL(string: "https://any-url.com")!
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any", code: 0)
    }
    
    private func anyData() -> Data {
        return Data("any".utf8)
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
}
