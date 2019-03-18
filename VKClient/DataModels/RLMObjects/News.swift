//
//  News.swift
//  VKClient
//
//  Created by Илалов Динар on 15.08.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import Foundation

class News {
    
    var id: Int = 0
    var postId: Int = 0
    var type: String = ""
    var date: Date = Date()
    var stringRuDate: String = ""
    var text: String = ""
    var photoUrl: String = ""
    var firstAttachmentUrl: String = ""
    var attachmentHeight: Double = 320
    var attachmentWidth: Double = 450
    var commentsCount: Int = 0
    var likesCount: Int = 0
    var repostsCount: Int = 0
    var viewsCount: Int = 0
    var ownerId: Int = 0
    var ownerType: String = "" // group/profile
    var ownerName: String = ""
    var ownerAvatarUrl: String = ""
    
    var postTextHeight: Double = 0
    
    convenience init?(json: [String: Any], profiles: [[String: Any]], groups: [[String: Any]]) {
        guard let type = json["type"] as? String
            else {
                return nil
        }
        self.init()
        
        if type == "photo" {
            
            if let photos = json["photos"] as? [String: Any],
                let items = photos["items"] as? [[String: Any]],
                items.count > 0,
                let sizes = items[0]["sizes"] as? [[String: Any]] {
                
                let qSize = sizes.filter { (size) -> Bool in
                    return (size["type"] as? String) == "q"
                }
                
                if qSize.count > 0 {
                    self.photoUrl = qSize[0]["url"] as? String ?? ""
                    self.attachmentWidth = qSize[0]["width"] as? Double ?? 0
                    self.attachmentHeight = qSize[0]["height"] as? Double ?? 0
                }
            }
            
        } else if type == "post" {
            
            self.text = json["text"] as? String ?? ""
            if let comments = json["comments"] as? [String: Any] {
                self.commentsCount = comments["count"] as? Int ?? 0
            }
            if let likes = json["likes"] as? [String: Any] {
                self.likesCount = likes["count"] as? Int ?? 0
            }
            if let reposts = json["reposts"] as? [String: Any] {
                self.repostsCount = reposts["count"] as? Int ?? 0
            }
            if let views = json["views"] as? [String: Any] {
                self.viewsCount = views["count"] as? Int ?? 0
            }
            
            if let attachments = json["attachments"] as? [[String: Any]],
                attachments.count > 0 {
                
                let photos = attachments.compactMap { (attachment) -> [String: Any]? in
                   
                    if (attachment["type"] as? String) == "photo",
                        let photo = attachment["photo"] as? [String: Any],
                        let sizes = photo["sizes"] as? [[String: Any]],
                        sizes.count > 0 {
                        
                        let qSize = sizes.filter { (size) -> Bool in
                            return (size["type"] as? String) == "q"
                        }
                        if qSize.count > 0 {
                            return ["url": qSize[0]["url"] ?? "",
                                    "width": qSize[0]["width"] ?? 0,
                                    "height": qSize[0]["height"] ?? 0]
                        }
                    }
                    return nil
                }
                if let attachment = photos.first {
                    self.firstAttachmentUrl = attachment["url"] as? String ?? ""
                    self.attachmentWidth = attachment["width"] as? Double ?? 0
                    self.attachmentHeight = attachment["height"] as? Double ?? 0
                }
            }
            
        } else {
            return nil
        }
        
        self.type = type
        self.date = Date(timeIntervalSince1970: TimeInterval(json["date"] as? Int ?? 0))
        self.stringRuDate = self.date.toRuDateString()
        self.postId = json["post_id"] as? Int ?? 0
        fillOwner(ownerIdFromJson: json["source_id"] as? Int ?? 0, profiles: profiles, groups: groups)
        self.id = Int("\(self.ownerId)\(self.postId)") ?? 0
        
    }
    
    private func fillOwner(ownerIdFromJson: Int, profiles: [[String: Any]], groups: [[String: Any]]) {
        
        var ownerId = ownerIdFromJson
        
        if ownerId >= 0 {
            let findedOwner = profiles.filter { (profileDict) -> Bool in
                if let profileId = profileDict["id"] as? Int {
                    return profileId == ownerId
                }
                return false
            }
            if findedOwner.count > 0 {
                self.ownerType = "profile"
                self.ownerId = ownerId
                self.ownerName = "\(findedOwner[0]["first_name"] as? String ?? "") \(findedOwner[0]["last_name"] as? String ?? "")"
                self.ownerAvatarUrl = findedOwner[0]["photo_50"] as? String ?? ""
            }
        } else {
            ownerId = ownerId * -1
            let findedOwner = groups.filter { (groupDict) -> Bool in
                if let groupId = groupDict["id"] as? Int {
                    return groupId == ownerId
                }
                return false
            }
            if findedOwner.count > 0 {
                self.ownerType = "group"
                self.ownerId = ownerId
                self.ownerName = findedOwner[0]["name"] as? String ?? ""
                self.ownerAvatarUrl = findedOwner[0]["photo_50"] as? String ?? ""
            }
        }
    }
}
