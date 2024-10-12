//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by User on 06/10/2024.
//

import UIKit
import EssentialFeed

final public class FeedViewController: UITableViewController{
    private var loader: FeedLoader?
    var isViewAppeared = false
    private var tableModel = [FeedImage]()
    public convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = FakeRefreshControll()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
//        refreshControl?.beginRefreshing()
        load()
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        if !isViewAppeared {
            refreshControl?.beginRefreshing()
            isViewAppeared = true
        }
        
    }
    
    @objc private func load() {
        refreshControl?.beginRefreshing()
        loader?.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.tableModel = feed
                self?.tableView.reloadData()
                self?.refreshControl?.endRefreshing()
                
            case .failure: break
            }
        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = tableModel[indexPath.row]
        let cell = FeedImageCell()
        cell.locationContainer.isHidden = (cellModel.location == nil)
        cell.locationLabel.text = cellModel.location
        cell.descriptionLabel.text = cellModel.description
        return cell
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
