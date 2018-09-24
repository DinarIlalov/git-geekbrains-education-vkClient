//
//  NewsFeedPostTableViewCell.swift
//  VKClient
//
//  Created by Илалов Динар on 15.08.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import UIKit

class NewsFeedPostTableViewCell: UITableViewCell {

    @IBOutlet weak var ownerAvatarImageView: UIImageView! {
        didSet {
            ownerAvatarImageView.round()
        }
    }
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var attachmentImageView: UIImageView!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var repostsCountLabel: UILabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var likesImageView: UIImageView!
    @IBOutlet weak var commentsImageView: UIImageView!
    @IBOutlet weak var repostsImageView: UIImageView!
    @IBOutlet weak var viewsImageView: UIImageView!
    
    var post: News? {
        didSet {
            configure()
        }
    }
    
    let insets: CGFloat = 8
    
    override func prepareForReuse() {
        super.prepareForReuse()
        attachmentImageView.kf.cancelDownloadTask()
        attachmentImageView.image = nil
        
        ownerAvatarImageView.kf.cancelDownloadTask()
        ownerAvatarImageView.image = nil
    }
    
    private func configure() {
        
        ownerNameLabel.text = post?.ownerName
        dateLabel.text = post?.stringRuDate
        postTextLabel.text = post?.text
        likesCountLabel.text = "\(post?.likesCount ?? 0)"
        commentsCountLabel.text = "\(post?.commentsCount ?? 0)"
        repostsCountLabel.text = "\(post?.repostsCount ?? 0)"
        viewsCountLabel.text = "\(post?.viewsCount ?? 0)"
        
        if let avatarUrl = post?.ownerAvatarUrl {
            ownerAvatarImageView.kf.setImage(with: URL(string: avatarUrl))
        } else {
            ownerAvatarImageView.image = nil
        }
        if let attachmentUrl = post?.firstAttachmentUrl,
            !attachmentUrl.isEmpty {
            attachmentImageView.kf.setImage(with: URL(string: attachmentUrl), placeholder: nil, options: nil, progressBlock: nil) { (image, error, cacheType, URL) in
                self.setNeedsLayout()
            }
        } else {
            attachmentImageView.image = #imageLiteral(resourceName: "unsupportedMedia")
        }
        
        arrangeElements()
    }
    
    private func arrangeElements() {
        
        calculateAvatarImageViewFrame()
        calculateNameLabelFrame()
        calculatedateLabelFrame()
        calculatePostTextLabelFrame()
        calculateAttachmentImageViewFrame()
        calculateLikesViewsCommentsRepostsFrame()
        
    }
    
    private func calculateAvatarImageViewFrame() {
        ownerAvatarImageView.frame = CGRect(x: insets, y: insets, width: 50, height: 50)
    }
    
    private func calculateNameLabelFrame() {
        ownerNameLabel.frame = CGRect(x: ownerAvatarImageView.frame.maxX + insets,
                                      y: 8,
                                      width: bounds.width - ownerAvatarImageView.frame.maxX - insets*2,
                                      height: 18)
    }
    
    private func calculatedateLabelFrame() {
        dateLabel.frame = CGRect(x: ownerAvatarImageView.frame.maxX + insets,
                                 y: ownerNameLabel.frame.maxY + insets,
                                 width: ownerNameLabel.frame.width,
                                 height: 16)
    }
    
    private func calculatePostTextLabelFrame() {
        
        let labelSize = CGSize(width: bounds.width - insets*2, height: CGFloat(post?.postTextHeight ?? 0))
        let labelOrigin = CGPoint(x: insets, y: ownerAvatarImageView.frame.maxY + 18)
        
        postTextLabel.frame = CGRect(origin: labelOrigin, size: labelSize)
    }
    
    private func calculateAttachmentImageViewFrame() {
        
        let attchWidth: CGFloat = bounds.width - insets*2
        let sizeRatio: CGFloat = attchWidth/CGFloat(post?.attachmentWidth ?? Double(attchWidth))
        
        let attchHeight: CGFloat = CGFloat(post?.attachmentHeight ?? 0) * sizeRatio
        
        attachmentImageView.frame = CGRect(x: insets,
                                     y: postTextLabel.frame.maxY + insets,
                                     width: attchWidth,
                                     height: attchHeight)
    }
    
    private func calculateLikesViewsCommentsRepostsFrame() {
        
        let iconHeight: CGFloat = 25
        let yPosition: CGFloat = attachmentImageView.frame.maxY + insets
        var xPosition: CGFloat = insets
        
        let widthForAll = bounds.width - insets*2
        let widthForPair = ceil(widthForAll/4)
        let widthForLabel = widthForPair - iconHeight
        
        let elementsArray: [UIView] =
            [
                likesImageView,
                likesCountLabel,
                commentsImageView,
                commentsCountLabel,
                repostsImageView,
                repostsCountLabel,
                viewsImageView,
                viewsCountLabel
            ]
        
        for viewElement in elementsArray {
        
            let elementWidth: CGFloat = ((viewElement as? UIImageView) == nil) ? widthForLabel : iconHeight
                
            viewElement.frame = CGRect(x: xPosition,
                                          y: yPosition,
                                          width: elementWidth,
                                          height: iconHeight)
            xPosition = viewElement.frame.maxX
        }
    }
}

extension NewsFeedPostTableViewCell {
    
    static func getRowHeight(for news: News, bounds: CGRect) -> CGFloat {
        
        let textHeight = getLabelSize(text: news.text, font: UIFont.systemFont(ofSize: 16), bounds: bounds).height
        
        let attchWidth: CGFloat = bounds.width - 8*2
        let sizeRatio: CGFloat = attchWidth/CGFloat(news.attachmentWidth)
        let attchHeight: CGFloat = CGFloat(news.attachmentHeight) * sizeRatio
        
        let rowHeight: CGFloat = 8 +
                                50 +
                                18 +
                                textHeight +
                                8 +
                                attchHeight +
                                25 +
                                8
        
        news.postTextHeight = Double(textHeight)
        return rowHeight
    }
    
    private static func getLabelSize(text: String, font: UIFont, bounds: CGRect) -> CGSize {
        
        if text.isEmpty {
            return CGSize(width: 0, height: 0)
        }
        
        let maxWidth = bounds.width - 8*2
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let width = Double(rect.width)
        let height = Double(rect.height)
        
        let size = CGSize(width: ceil(width), height: ceil(height))
        
        return size
    }
}
