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
    private let currentDate: () -> Date
    init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    func save(_ items: [FeedItem], completion: @escaping (Error?) -> Void) {
        store.deledCachedFeed { [unowned self] error in
            if error == nil {
                self.store.insert(items, timestamp: self.currentDate(), completion: { error in
                        completion(error)
                })
            } else {
                completion(error)
            }
        }
    }
}

class FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
//    var deleteCachedFeedCallcount = 0
//    var insertions = [(items: [FeedItem], timestamp: Date)]()
    
    enum RecievedMessage: Equatable {
        case deleteCachedFeed
        case insert([FeedItem], Date)
    }
    
    private(set) var recievedMessages = [RecievedMessage]()
    
    private var deletionCompletions = [DeletionCompletion]()
    private var insertionCompletions = [InsertionCompletion]()
    func deledCachedFeed(completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        recievedMessages.append(.deleteCachedFeed)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func insert(_ items: [FeedItem], timestamp: Date, completion: @escaping InsertionCompletion) {
        insertionCompletions.append(completion)
        recievedMessages.append(.insert(items, timestamp))
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }
}
class CacheFeeUseCaseTests: XCTestCase {
    
    // 1 delete old cache
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertEqual(store.recievedMessages, [])
    }
    
    func test_save_requestsCacheDeletion() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()
        sut.save(items) { _ in}
        XCTAssertEqual(store.recievedMessages, [.deleteCachedFeed])
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        sut.save(items) { _ in}
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.recievedMessages, [.deleteCachedFeed])
    }
    
    
    func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion() {
        let timestamp = Date()
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT(currentDate: { timestamp})
        sut.save(items) { _ in}
        store.completeDeletionSuccessfully()
        XCTAssertEqual(store.recievedMessages, [.deleteCachedFeed, .insert(items, timestamp)])
    }
    
    func test_save_failsOnInsertionError() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        let exp = expectation(description: "wait for save completion")
        
        var receivedError: Error?
        sut.save(items) { error in
            receivedError = error
            exp.fulfill()
        }
        store.completeDeletionSuccessfully()
        store.completeInsertion(with: insertionError)
        wait(for: [exp], timeout: 1.0)
        
//        XCTAssertEqual(store.recievedMessages, [.deleteCachedFeed])
        XCTAssertEqual(receivedError as! NSError, insertionError)
    }
    
    func test_save_failsOnDeletionError() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        let exp = expectation(description: "wait for save completion")
        
        var receivedError: Error?
        sut.save(items) { error in
            receivedError = error
            exp.fulfill()
        }
        store.completeDeletion(with: deletionError)
        wait(for: [exp], timeout: 1.0)
        
//        XCTAssertEqual(store.recievedMessages, [.deleteCachedFeed])
        XCTAssertEqual(receivedError as! NSError, deletionError)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
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
