//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by User on 14/12/2023.
//

import Foundation


public enum LoadFeedResult{
    case success([FeedImage])
    case failure(Error)
}


public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
