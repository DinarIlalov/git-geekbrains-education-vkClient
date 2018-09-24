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
    @IBOutlet weak var groupImage: UIImageView! {
        didSet {
            groupImage.round()
        }
    }
    @IBOutlet weak var memberCountLabel: UILabel!
    
    var group: Group? {
        didSet {
            configure()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        groupImage.kf.cancelDownloadTask()
        groupImage.image = nil
    }
    
    private func configure() {
        groupNameLabel.text = group?.name
        memberCountLabel.text = "\(group?.members_count ?? 0) подписчик"
        if let avatarUrl = group?.avatarUrl {
            let url = URL(string: avatarUrl)
            groupImage.kf.setImage(with: url)
        }
        
    }
}
