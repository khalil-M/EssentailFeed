//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by User on 20/11/2024.
//

import EssentialFeed

struct FeedLoadingViewModel {
    let isLoading: Bool
}

// 1 reference to the view
protocol FeedLoadingView {
    // 2 we need a way to notify
    func display(_ viewModel: FeedLoadingViewModel)
}

struct FeedViewModel {
    let feed: [FeedImage]
}

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

final class FeedPresenter {
    typealias Observer<T> = (T) -> Void
    //since the viewModel manage the feedLoading state
    
    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var feedView: FeedView?
    var loadingView: FeedLoadingView?

    func loadFeed() {
        //define the state transition
//        state = .loading
        loadingView?.display(FeedLoadingViewModel(isLoading: true))
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                //                self?.state = .loaded(feed)
                self?.feedView?.display(FeedViewModel(feed: feed))
            }
            self?.loadingView?.display(FeedLoadingViewModel(isLoading: false))
            
        }
    }
}
