//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by User on 15/12/2023.
//

import XCTest
import EssentialFeed

final class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRquestDataFromURL() {
        let (_, client) = makeSUT()
        
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    
    // load item command
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load { _ in }
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load { _ in }
        sut.load { _ in }
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithError: .connectivity) {
            let clientError = NSError(domain: "Test", code: 0)
            //invoking completion block
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        
        //invoking completion block
//        client.complete(withStatusCode: 400)
        let samples = [199, 200, 300, 400, 500]
//        samples.enumerated().forEach { index, code in
//            var capturedErrors = [RemoteFeedLoader.Error]()
//            sut.load { capturedErrors.append($0) }
//            client.complete(withStatusCode: code, at: index)
//            XCTAssertEqual(capturedErrors, [.invalidData])
//            capturedErrors = []
//        }
        
        samples.enumerated().forEach { index, code in
            var capturedErrors = [RemoteFeedLoader.Error]()
            expect(sut, toCompleteWithError: .invalidData) {
                client.complete(withStatusCode: code, at: index)
            }
            capturedErrors = []
        }
        
    }
    
    func test_load_deliversOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithError: .invalidData) {
            let invalidJSON = Data(bytes: "Invalid json".utf8)
              client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string:"https://a-given-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWithError error: RemoteFeedLoader.Error, when action: () -> Void, file: StaticString = #filePath,
                        line: UInt = #line) {
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load { capturedErrors.append($0) }
        
        action()
        XCTAssertEqual(capturedErrors, [error], file: file, line: line)
    }
    
    private class HTTPClientSpy: HTTPClient {
       
        
        private var messages = [(url: URL, completion:(HTTPClientResult) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
    }

}
