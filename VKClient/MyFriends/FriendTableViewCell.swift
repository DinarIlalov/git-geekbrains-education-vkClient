//
//  FriendTableViewCell.swift
//  VKClient
//
//  Created by Константин Зонин on 20.07.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userStatusLabel: UILabel!
    
    var friend: Friend? {
        didSet {
            configure()
        }
    }
    
    private func configure() {
        userNameLabel.text = friend?.name
        userStatusLabel.text = (friend?.online ?? false) ? "online" : "offline"
        userStatusLabel.textColor = (friend?.online ?? false) ? UIColor.green : UIColor.red
        
        if let avatarURL = friend?.avatarUrl {
            let url = URL(string: avatarURL)
            avatarImageView.kf.setImage(with: url)
        }
    }
    
}
