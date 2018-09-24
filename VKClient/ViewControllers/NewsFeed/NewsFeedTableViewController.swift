//
//  NewsFeedTableViewController.swift
//  VKClient
//
//  Created by Илалов Динар on 15.08.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import UIKit

class NewsFeedTableViewController: UITableViewController {

    var newsfeed: [News] = []
    private var currentSearchOffset = 0
    private let searchResultCount = 30
    private var startFrom: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillTable()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsfeed.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let news = newsfeed[indexPath.row]
        
        return NewsFeedPostTableViewCell.getRowHeight(for: news, bounds: tableView.bounds)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let news = newsfeed[indexPath.row]
        
        if indexPath.row + 1 == newsfeed.count {
            fillTable()
        }
        
        if news.type == "post",
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? NewsFeedPostTableViewCell {
            cell.post = news
            return cell
        } else if news.type == "photo",
            let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as? NewsFeedPhotoTableViewCell {
            cell.post = news
            return cell
            
        }
        return UITableViewCell()
    }
    
    private func fillTable() {
        
        VKApiService().getNewsfeed(withOffset: currentSearchOffset, resultCount: searchResultCount, startFrom: startFrom) { [weak self] (newsfeed, startFrom) in
            guard let strongSelf = self else { return }
            strongSelf.startFrom = startFrom
            strongSelf.newsfeed += newsfeed
            strongSelf.tableView.reloadData()
        }
    }
}
