//
//  MyGroupsTableViewController.swift
//  VKClient
//
//  Created by Константин Зонин on 20.07.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import UIKit

class MyGroupsTableViewController: UITableViewController {

    // MARK: Properties
    //var myGroups: [Group] = []
    private var dataSource = DataSource(realmObjectType: Group.self)
    
    // MARK: Class funcs
    override func viewDidLoad() {
        super.viewDidLoad()

        fillMyGroupsData()
    }

     // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.objects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell", for: indexPath) as? GroupTableViewCell
            else { return UITableViewCell() }
        
        cell.group = dataSource.objects?[indexPath.row]
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            if let group = dataSource.objects?[indexPath.row] {
                DataBase.removeGroup(group)
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func unwindToMyGroups(_ sender: UIStoryboardSegue) {
        
        switch sender.identifier {
        case "unwindToMyGroupsSegue":
            
            guard let allGroupsController = sender.source as? AllGroupsTableViewController,
                let selectedGroupIndexPath = allGroupsController.tableView.indexPathForSelectedRow
                else {
                    return
            }
            
            let selectedGroup = allGroupsController.filteredGroups[selectedGroupIndexPath.row]
            DataBase.saveGroup(selectedGroup)
            
        default:
            return
        }
    }
    
    // MARK: - Functions
    private func fillMyGroupsData() {
        
        VKApiService().getCurrentUserGroups()
        dataSource.attachTo(tableView: tableView)
    }
}
