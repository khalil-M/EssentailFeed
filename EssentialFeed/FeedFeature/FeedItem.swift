//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by User on 14/12/2023.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
