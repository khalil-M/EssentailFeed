//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by User on 12/01/2024.
//

import Foundation

public final class LocalFeedLoader {
    
    private let store: FeedStore
    private let currentDate: () -> Date
    private let calender = Calendar(identifier: .gregorian)
    
    public typealias SaveResult = Error?
    public typealias LoadResult = LoadFeedResult
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.deledCachedFeed { [weak self] error in
            guard let self = self else { return }
            if let cacheDeletionerror = error {
                completion(cacheDeletionerror)
            } else {
                self.cache(feed, completion: completion)
            }
        }
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                self.store.deledCachedFeed(completion: {_ in })
                completion(.failure(error))
            case let .found(feed: feed, timestamp) where self.validate(timestamp):
                completion(.success(feed.toModels()))
            case .found:
                self.store.deledCachedFeed(completion: {_ in })
                completion(.success([]))
            case .empty:
                completion(.success([]))
            }
        })
    }
    
    private var maxCachedAgeIndays: Int {
        return 7
    }
    
    private func validate(_ timestamp: Date) -> Bool {
        guard let maxCacheAge = calender.date(byAdding: .day, value: 7, to: timestamp) else { return  false }
        return currentDate() < maxCacheAge
    }
    
    private func cache(_ feed: [FeedImage], completion: @escaping(SaveResult) -> Void) {
        store.insert(feed.toLocal(), timestamp: currentDate(), completion: { [weak self] error in
            guard let self = self else { return }
            completion(error)
        })
    }
}

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        return map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)}
    }
}

private extension Array where Element == LocalFeedImage {
    func toModels() -> [FeedImage] {
        return map { FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)}
    }
}


