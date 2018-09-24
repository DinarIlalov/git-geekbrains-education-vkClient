//
//  NewsFeedPhotoTableViewCell.swift
//  VKClient
//
//  Created by Илалов Динар on 15.08.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import UIKit

class NewsFeedPhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var ownerAvatarImageView: UIImageView!{
        didSet {
            ownerAvatarImageView.round()
        }
    }
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var post: News? {
        didSet {
            configure()
        }
    }
    
    var height: CGFloat = 50
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.kf.cancelDownloadTask()
        photoImageView.image = nil
        
        ownerAvatarImageView.kf.cancelDownloadTask()
        ownerAvatarImageView.image = nil
    }
    private func configure() {
        ownerNameLabel.text = post?.ownerName
        dateLabel.text = post?.stringRuDate
        
        if let avatarUrl = post?.ownerAvatarUrl {
            ownerAvatarImageView.kf.setImage(with: URL(string: avatarUrl))
        }
        
        if let photoUrl = post?.photoUrl,
            !photoUrl.isEmpty {
             photoImageView.kf.setImage(with: URL(string: photoUrl), placeholder: nil, options: nil, progressBlock: nil) { (image, error, cacheType, URL) in
                self.setNeedsLayout()
            }
        } else {
            photoImageView.image = nil
        }
        
    }
}
