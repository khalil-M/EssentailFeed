//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by User on 06/10/2024.
//

import UIKit

final public class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching {
//    private var feedloader: FeedLoader?
    private var refreshController: FeedRefreshViewController?
    var isViewAppeared = false
    
//    private var cellControllers = [IndexPath: FeedImageCellController]()
    var tableModel = [FeedImageCellController]() {
        didSet { tableView.reloadData() }
    }
    
    
    convenience init(refreshController: FeedRefreshViewController) {
        self.init()
        self.refreshController = refreshController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.prefetchDataSource = self
        refreshControl = refreshController?.view
        refreshController?.refresh()
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        if !isViewAppeared {
            refreshController?.view.beginRefreshing()
            isViewAppeared = true
        }
    }
    
    
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view()
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
        //we moved the responsability to the cellController
//        cancelTask(forRowAt: indexPath)
//        cellControllers[indexPath] = nil
        //        let cellModel = tableModel[indexPath.row]
        //        imageLoader?.cancelImageDataLoad(from: cellModel.url)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            _ = cellController(forRowAt: indexPath).preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
//        let cellModel = tableModel[indexPath.row]
//        let cellController = FeedImageCellController(model: cellModel, imageLoader: imageLoader!)
//        cellControllers[indexPath] = cellController
        return tableModel[indexPath.row]
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
//        tasks[indexPath]?.cancel()
//        tasks[indexPath] = nil
        // free up the memory and stop the task
        cellController(forRowAt: indexPath).cancelLoad()
    }
}

class FakeRefreshControll: UIRefreshControl {
    private var _isRefreshing = false
    
    override var isRefreshing: Bool { _isRefreshing }
    
    override func beginRefreshing() {
        _isRefreshing = true
    }
    
    override func endRefreshing() {
        _isRefreshing = false
    }
}
