//
//  FriendPhotoCollectionViewCell.swift
//  VKClient
//
//  Created by Константин Зонин on 23.07.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import UIKit

class FriendPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var avatarUrl: String = "" {
        didSet {
            let url = URL(string: avatarUrl)
            photoImageView.kf.setImage(with: url)
        }
    }
}
