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
    var groups: [[String: String]] = []
    var filteredGroups: [[String: String]] = []
    
    // MARK: Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: class funs
    override func viewDidLoad() {
        super.viewDidLoad()

        fillGroupsData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (searchBar.text ?? "").isEmpty ? groups.count : filteredGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupsTableViewCell", for: indexPath) as? AllGroupsTableViewCell
            else { return UITableViewCell() }
        
        // без фильтра
        if (searchBar.text ?? "").isEmpty {
            if let imageName = groups[indexPath.row]["avatar"] {
                cell.groupImage.image = UIImage(named: imageName)
            }
            cell.groupNameLabel.text = groups[indexPath.row]["name"]
            cell.usersCountLabel.text = "В группе состоит \(groups[indexPath.row]["usersCount"] ?? "0") пользователей"
        } else {
            if let imageName = filteredGroups[indexPath.row]["avatar"] {
                cell.groupImage.image = UIImage(named: imageName)
            }
            cell.groupNameLabel.text = filteredGroups[indexPath.row]["name"]
            cell.usersCountLabel.text = "В группе состоит \(filteredGroups[indexPath.row]["usersCount"] ?? "0") пользователей"
        }
        
        return cell
    }
    
    // MARK: - Functions
    private func fillGroupsData() {
        
        groups = [
            ["name": "Первый канал", "avatar": "ic_groupImage1", "usersCount": "100"],
            ["name": "Россия 1", "avatar": "ic_groupImage2", "usersCount": "200"],
            ["name": "Матч ТВ", "avatar": "ic_groupImage1", "usersCount": "300"],
            ["name": "Рен ТВ", "avatar": "ic_groupImage2", "usersCount": "200"],
            ["name": "Первый развлекательный", "avatar": "ic_groupImage3", "usersCount": "1200"],
            ["name": "Муз ТВ", "avatar": "ic_groupImage3", "usersCount": "1100"],
            ["name": "СТС", "avatar": "ic_groupImage2", "usersCount": "1040"],
            ["name": "ТНТ", "avatar": "ic_groupImage1", "usersCount": "1001"],
            ["name": "Канал с длинным наименованием", "avatar": "ic_groupImage1", "usersCount": "103"],
            ["name": "Канал 1", "avatar": "ic_groupImage3", "usersCount": "1200"],
            ["name": "Канал с названием На Две Строчки", "avatar": "ic_groupImage1", "usersCount": "12300"]
        ]
    }

}

// MARK: - Search Bar delegate
extension AllGroupsTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredGroups = []
        } else {
            filteredGroups = groups.filter({ (group) -> Bool in
                let range = group["name"]?.range(of: searchText, options: String.CompareOptions.caseInsensitive)
                return range != nil
            })
        }
        tableView.reloadData()
    }
    
}
