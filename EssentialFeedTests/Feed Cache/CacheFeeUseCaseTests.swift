//
//  CacheFeeUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by User on 07/01/2024.
//

import XCTest
import EssentialFeed
class LocalFeedLoader {
    
    let store: FeedStore
    
    init(store: FeedStore) {
        self.store = store
    }
    
    func save(_ itesm: [FeedItem]) {
        store.deledCachedFeed()
    }
}

class FeedStore {
    var deleteCachedFeedCallcount = 0
    var insertCallCount = 0
    func deledCachedFeed() {
        deleteCachedFeedCallcount += 1
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        
    }
}
class CacheFeeUseCaseTests: XCTestCase {
    
    // 1 delete old cache
    func test_init_doesNotDeleteCacheUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.deleteCachedFeedCallcount, 0)
    }
    
    func test_save_requestsCacheDeletion() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()
        sut.save(items)
        XCTAssertEqual(store.deleteCachedFeedCallcount, 1)
    }
    
    func test_doesNotRequestCacheInsertiononDeletionError() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        sut.save(items)
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.insertCallCount, 0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func uniqueItem() -> FeedItem {
        return FeedItem(id: UUID(), description: "any", location: "any", imageURL: anyURL())
    }
    
    private func anyURL() -> URL {
        let url = URL(string: "https://any-url.com")!
        return url
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 1)
    }
}
