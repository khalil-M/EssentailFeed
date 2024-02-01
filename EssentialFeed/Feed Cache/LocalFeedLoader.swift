//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by User on 12/01/2024.
//

import Foundation

private final class FeedCachePolicy {
    
    private init() {}
    
    private static let calender = Calendar(identifier: .gregorian)
    
    
    
    private static var maxCachedAgeIndays: Int {
        return 7
    }
    
    static func validate(_ timestamp: Date, agains date: Date) -> Bool {
        guard let maxCacheAge = calender.date(byAdding: .day, value: 7, to: timestamp) else { return  false }
        return date < maxCacheAge
    }
}

public final class LocalFeedLoader {
    
    private let store: FeedStore
    private let currentDate: () -> Date
    
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalFeedLoader {
    
    public typealias SaveResult = Error?
    
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
    
    private func cache(_ feed: [FeedImage], completion: @escaping(SaveResult) -> Void) {
        store.insert(feed.toLocal(), timestamp: currentDate(), completion: { [weak self] error in
            guard let self = self else { return }
            completion(error)
        })
    }
}
    
extension LocalFeedLoader: FeedLoader {
    public typealias LoadResult = LoadFeedResult
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .found(feed: feed, timestamp) where FeedCachePolicy.validate(timestamp, agains: currentDate()):
                completion(.success(feed.toModels()))
                //when the cache is invalid they do exactly the same
            case .found, .empty:
                completion(.success([]))
            }
        })
    }
}

extension LocalFeedLoader {
    
    public func validateCache() {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure:
                self.store.deledCachedFeed(completion: {_ in})
                
            case let .found(feed: _, timestamp) where !FeedCachePolicy.validate(timestamp, agains: currentDate()):
                self.store.deledCachedFeed(completion: {_ in})
                
            case .empty, .found: break
            }
        }
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


