//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by User on 14/01/2024.
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
