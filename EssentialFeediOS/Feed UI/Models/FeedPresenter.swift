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
    // since we don't have a reference to the the feedLoader we need a way to know when the
    // loading begins and ends
    
    func didStartLoadingFeed() {
        loadingView?.display(FeedLoadingViewModel(isLoading: true))
    }
    
    func didFinshLoadingFeed(with feed: [FeedImage]) {
        feedView?.display(FeedViewModel(feed: feed))
        loadingView?.display(FeedLoadingViewModel(isLoading: false))
    }
    
    func didFinshLoadingFeed(with error: Error) {
        loadingView?.display(FeedLoadingViewModel(isLoading: false))
    }
    
    
    var feedView: FeedView?
    var loadingView: FeedLoadingView?

//    func loadFeed() {
//        //define the state transition
////        state = .loading
//        loadingView?.display(FeedLoadingViewModel(isLoading: true))
//        feedLoader.load { [weak self] result in
//            if let feed = try? result.get() {
//                //                self?.state = .loaded(feed)
//                self?.feedView?.display(FeedViewModel(feed: feed))
//            }
//            self?.loadingView?.display(FeedLoadingViewModel(isLoading: false))
//            
//        }
//    }
}
