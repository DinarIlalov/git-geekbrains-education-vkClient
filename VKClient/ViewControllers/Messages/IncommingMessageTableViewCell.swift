//
//  IncommingMessageTableViewCell.swift
//  VKClient
//
//  Created by Илалов Динар on 24/09/2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import UIKit

class IncommingMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel! {
        didSet {
//            messageLabel.round()
        }
    }
    
    var message: Message? {
        didSet {
            messageLabel.text = message?.text
        }
    }
}
