//
//  GroupTableViewCell.swift
//  VKClient
//
//  Created by Константин Зонин on 20.07.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupImage: UIImageView!

    var group: Group? {
        didSet {
            configure()
        }
    }
    
    private func configure() {
        groupNameLabel.text = group?.name
        if let avatarUrl = group?.avatarUrl {
            let url = URL(string: avatarUrl)
            groupImage.kf.setImage(with: url)
        }
        
    }
}
