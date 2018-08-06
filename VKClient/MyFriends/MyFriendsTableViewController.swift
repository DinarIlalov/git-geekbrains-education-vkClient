//
//  MyFriendsTableViewController.swift
//  VKClient
//
//  Created by Константин Зонин on 20.07.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import UIKit

class MyFriendsTableViewController: UITableViewController {

    // MARK: Properties
    private var friends: [Friend] = []
    
    // MARK: class funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillFriendsData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let photoCollectionController = segue.destination as? MyFriendPhotoCollectionViewController,
            let cell = sender as? FriendTableViewCell {
            photoCollectionController.userId = cell.friend?.id ?? 0
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as? FriendTableViewCell
            else { return UITableViewCell() }

        cell.friend = friends[indexPath.row]
        return cell
    }

    // MARK: - Functions
    private func fillFriendsData() {
        
        VKApiService().getCurrentUserFriends() { [weak self] in
            self?.friends = DataBase.getFriends()
            self?.tableView.reloadData()
        }
    }
    
}
