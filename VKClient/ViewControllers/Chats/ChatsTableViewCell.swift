//
//  ChatsTableViewCell.swift
//  VKClient
//
//  Created by Илалов Динар on 16.08.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import UIKit

class ChatsTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.round()
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lastMessageOwnerAvatarImageView: UIImageView! {
        didSet {
            lastMessageOwnerAvatarImageView.round()
        }
    }
    @IBOutlet weak var lastMessageTextLabel: UILabel!
    @IBOutlet weak var unreadedCountLabel: UILabel!
    
    var chat: Chat? {
        didSet {
            configure()
        }
    }
    
    override func prepareForReuse() {
        avatarImageView.kf.cancelDownloadTask()
        avatarImageView.image = nil
        
        lastMessageOwnerAvatarImageView.kf.cancelDownloadTask()
        lastMessageOwnerAvatarImageView.image = nil
    }
    private func configure() {
        
        titleLabel.text = chat?.title
//        dateLabel.text = chat?.lastMessageDate?.toRuDateString()
        lastMessageTextLabel.text = chat?.lastMessageText
        
        let unreadedCount = (chat?.lastMessageId ?? 0) - (chat?.lastReadedMessageId ?? 0)
        unreadedCountLabel.text = unreadedCount > 0 ? "\(unreadedCount)" : nil
        
        if let avatarUrl = chat?.avatarUrl {
            avatarImageView.kf.setImage(with: URL(string: avatarUrl))
        }
        if chat?.peerId != chat?.lastMessageOwnerId,
            let avatarUrl = chat?.lastMessageOwnerUrl {
            lastMessageOwnerAvatarImageView.kf.setImage(with: URL(string: avatarUrl))
        } else {
            lastMessageOwnerAvatarImageView.image = nil
        }
        
    }
}
