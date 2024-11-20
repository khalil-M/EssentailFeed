//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by User on 20/11/2024.
//

import EssentialFeed

// 1 reference to the view
protocol FeedLoadingView: class {
    // 2 we need a way to notify
    func display(isLoading: Bool)
}

protocol FeedView {
    func display(feed: [FeedImage])
}

final class FeedPresenter {
    typealias Observer<T> = (T) -> Void
    //since the viewModel manage the feedLoading state
    
    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var feedView: FeedView?
    weak var loadingView: FeedLoadingView?

    func loadFeed() {
        //define the state transition
//        state = .loading
        loadingView?.display(isLoading: true)
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                //                self?.state = .loaded(feed)
                self?.feedView?.display(feed: feed)
            }
            self?.loadingView?.display(isLoading: false)
            
        }
    }
}
