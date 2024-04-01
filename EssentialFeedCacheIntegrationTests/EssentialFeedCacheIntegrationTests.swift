//
//  EssentialFeedCacheIntegrationTests.swift
//  EssentialFeedCacheIntegrationTests
//
//  Created by User on 01/04/2024.
//

import XCTest
import EssentialFeed

final class EssentialFeedCacheIntegrationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }

    func test_load_deliversNoItemsOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toLoad: [])
    }
    
    func test_load_deliversItemsSavedOnSeparateInstance() {
        let sutToPerformSave = makeSUT()
        let sutToPerforomLoad = makeSUT()
        
        let feed = uniqueImageFeed().models
        
        let saveExp = expectation(description: "Wait for save completion")
        sutToPerformSave.save(feed) { saveError in
            XCTAssertNil(saveError, "Expected to save successfully")
            saveExp.fulfill()
        }
        
        wait(for: [saveExp], timeout: 1.0)
        
        expect(sutToPerforomLoad, toLoad: feed)
    }
    
    func test_save_overridesItemsSavedOnASeparateInstance() {
        let sutToPerformFirstSave = makeSUT()
        let sutToPerformLastSave = makeSUT()
        let sutToPerformLoad = makeSUT()
        let firstFeed = uniqueImageFeed().models
        let latestFeed = uniqueImageFeed().models
        
        let saveExp1 = expectation(description: "Wait for save completion")
        sutToPerformFirstSave.save(firstFeed) { saveError in
            XCTAssertNil(saveError, "Expectated to save feed successfully")
            saveExp1.fulfill()
        }
        wait(for: [saveExp1], timeout: 1.0)
        
        let saveExp2 = expectation(description: "Wait for save completion")
        sutToPerformLastSave.save(latestFeed) { saveError in
            XCTAssertNil(saveError, "Expectated to save feed successfully")
            saveExp2.fulfill()
        }
        wait(for: [saveExp2], timeout: 1.0)
        
        expect(sutToPerformLoad, toLoad: latestFeed)
    }
    
    // MARK: Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> LocalFeedLoader {
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let storeURl = testSpecificStoreURL()
        let store = try! CoreDataFeedStore(storeURL: storeURl, bundle: storeBundle)
        let sut = LocalFeedLoader(store: store, currentDate: Date.init)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func expect(_ sut: LocalFeedLoader, toLoad expectedFeed: [FeedImage], file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        sut.load { result in
            switch result {
            case let .success(imageFeed):
                XCTAssertEqual(imageFeed, expectedFeed, file: file, line: line)
                
            case let .failure(error):
                XCTFail("Expected successful feed result, got \(error) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    private func testSpecificStoreURL() -> URL{
        return cacheDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cacheDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }

}
