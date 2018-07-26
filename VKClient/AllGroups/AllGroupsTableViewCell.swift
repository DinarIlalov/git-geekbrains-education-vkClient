//
//  AllGroupsTableViewCell.swift
//  VKClient
//
//  Created by Константин Зонин on 20.07.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import UIKit

class AllGroupsTableViewCell: UITableViewCell {

    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupTypeLabel: UILabel!

    var groupId: Int?
    var groupAvatarUrl: String? {
        didSet {
            groupImage.image = nil
            loadAvatarImageForGroup()
        }
    }
    
    private func loadAvatarImageForGroup() {
        
        if let url = groupAvatarUrl {
            VKApiService().createRequestAndGetImage(from: url) { (response) in
                
                if url == self.groupAvatarUrl,
                    let data = response {
                    DispatchQueue.main.async {
                        self.groupImage.image = UIImage(data: data)
                    }
                }
            }
        }
        
    }
}
