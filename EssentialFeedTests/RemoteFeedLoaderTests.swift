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
        sut.load()
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load()
        sut.load()
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load { capturedErrors.append($0) }
        let clientError = NSError(domain: "Test", code: 0)
        //invoking completion block
        client.complete(with: clientError)
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string:"https://a-given-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
       
        
        private var messages = [(url: URL, completion:(Error) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        func get(from url: URL, completion: @escaping (Error) -> Void) {
            messages.append((url, completion))
        }
        
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(error)
        }
    }

}
