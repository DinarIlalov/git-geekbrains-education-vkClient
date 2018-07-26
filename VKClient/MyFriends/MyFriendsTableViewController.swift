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
    private var friends: [[String: String]] = []
    private var vkServise = VKApiService()
    
    // MARK: class funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillFriendsData()
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

        if let imageName = friends[indexPath.row]["avatar"] {
            cell.avatarImageView.image = UIImage(named: imageName)
        }
        cell.userNameLabel.text = friends[indexPath.row]["name"]
        
        return cell
    }

    // MARK: - Functions
    private func fillFriendsData() {
        
        vkServise.getCurrentUserFriends()
        
        // TODO: переделать на классы
        friends = [
            ["name": "Иван", "avatar": "ic_userAvatar"],
            ["name": "Степан", "avatar": "ic_userAvatar"],
            ["name": "Николай", "avatar": "ic_userAvatarMale"],
            ["name": "Петр", "avatar": "ic_userAvatarMale"],
            ["name": "Дженифер Лопес", "avatar": "ic_userAvatarFemale"],
            ["name": "Николай Басков", "avatar": "ic_userAvatar"],
            ["name": "Иоган Себастьян Бах", "avatar": "ic_userAvatarMale"],
            ["name": "Людвиг Ван Бетховен", "avatar": "ic_userAvatar"],
            ["name": "Корнита Анжелика Феррейро Роше", "avatar": "ic_userAvatarFemale"],
            ["name": "Имя 1", "avatar": "ic_userAvatarFemale"],
            ["name": "Имя Фамилия Отчество На Две Строчки", "avatar": "ic_userAvatar"]
        ]
    }
    
}
