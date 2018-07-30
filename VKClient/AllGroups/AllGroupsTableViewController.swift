//
//  AllGroupsTableViewController.swift
//  VKClient
//
//  Created by Константин Зонин on 20.07.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import UIKit

class AllGroupsTableViewController: UITableViewController {

    // MARK: Properties
    var filteredGroups: [Group] = []
    private var totalNumberOfGroup: Int = 0
    private var currentSearchOffset = 0
    private let searchResultCount = 30
    
    // MARK: Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: class funs

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchBar.text ?? "").isEmpty {
            return 0
        } else {
            return filteredGroups.count + 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // строка если ничего не найдено
        if !(searchBar.text ?? "").isEmpty, filteredGroups.count == 0 {
            let cell = UITableViewCell.init(style: .default, reuseIdentifier: "")
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
            cell.textLabel?.text = "По поиску \(searchBar.text ?? "") ничего не найдено"
            return cell
        }
        // строка для продолжения поиска "Показать еще"
        if indexPath.row+1 > filteredGroups.count {
            let cell = UITableViewCell.init(style: .default, reuseIdentifier: "")
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = "Показать еще \(searchResultCount)"
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupsTableViewCell", for: indexPath) as? AllGroupsTableViewCell
            else { return UITableViewCell() }
        
        cell.group = filteredGroups[indexPath.row]
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row+1 > filteredGroups.count {
            currentSearchOffset = currentSearchOffset + searchResultCount
            searchGroups(byName: searchBar.text)
        }
        
    }
    
    // MARK: - Functions
    private func searchGroups(byName groupName: String?) {
        
        if let groupName = groupName, !groupName.isEmpty {
            VKApiService().searchGroup(byName: groupName, withOffset: currentSearchOffset, resultCount: searchResultCount) { [weak self] (groups, totalNumber) in
                
                // новый поиск
                if self?.currentSearchOffset == 0 {
                    self?.totalNumberOfGroup = totalNumber
                    self?.filteredGroups = groups
                } else {
                    self?.filteredGroups += groups
                }
                self?.tableView.reloadData()
            }
        } else {
            filteredGroups = []
            totalNumberOfGroup = 0
            tableView.reloadData()
        }
    }
}

// MARK: - Search Bar delegate
extension AllGroupsTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchGroups(byName: searchBar.text)
        view.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        currentSearchOffset = 0
        totalNumberOfGroup = 0
    }
    
}
