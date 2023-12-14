//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by User on 14/12/2023.
//

import Foundation


enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}


protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
