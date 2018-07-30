//
//  AllGroupsTableViewCell.swift
//  VKClient
//
//  Created by Константин Зонин on 20.07.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import UIKit
import Kingfisher

class AllGroupsTableViewCell: UITableViewCell {

    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupTypeLabel: UILabel!

    var group: Group? {
        didSet {
            configure()
        }
    }
    
    private func configure() {
        groupNameLabel.text = group?.name
        groupTypeLabel.text = group?.type.description
        
        loadAvatarImageForGroup()
    }
    
    private func loadAvatarImageForGroup() {
        groupImage.image = nil
        if let avatarUrl = group?.avatarUrl {
            let url = URL(string: avatarUrl)
            groupImage.kf.setImage(with: url)
        }
    }
}
