//
//  Chat.swift
//  VKClient
//
//  Created by Илалов Динар on 16.08.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import Foundation
import RealmSwift

class Chat: Object {
    
    @objc dynamic var peerId: Int = 0
    @objc dynamic var peerType: String = "" //user, chat, group, email
    @objc dynamic var title: String = ""
    @objc dynamic var avatarUrl: String = ""
    @objc dynamic var lastMessageId: Int = 0
    @objc dynamic var lastMessageText: String = ""
    @objc dynamic var lastMessageDate: Date?
    @objc dynamic var lastMessageOwnerId: Int = 0
    @objc dynamic var lastMessageOwnerName: String = ""
    @objc dynamic var lastMessageOwnerUrl: String = ""
    @objc dynamic var lastReadedMessageId: Int = 0
    
    
    override static func primaryKey() -> String? {
        return "peerId"
    }
    
    convenience init?(json: [String: Any], profiles: [[String: Any]], groups: [[String: Any]]) {
        guard let conversation = json["conversation"] as? [String: Any],
            let peer = conversation["peer"] as? [String: Any],
            let peerId = peer["local_id"] as? Int,
            let peerType = peer["type"] as? String else { return nil }
        
        self.init()
        
        self.peerId = peerId
        self.peerType = peerType
        self.lastReadedMessageId = conversation["in_read"] as? Int ?? 0
        self.lastMessageId = conversation["last_message_id"] as? Int ?? 0
            
        fillChatInfo(chatSettings: conversation["chat_settings"] as? [String: Any] ?? [:], profiles: profiles, groups: groups)
        
        if let lastMessage = json["last_message"] as? [String: Any]{
            fillLastMessageOwner(ownerIdFromJson: lastMessage["from_id"] as? Int, profiles: profiles, groups: groups)
            self.lastMessageText = lastMessage["text"] as? String ?? ""
            self.lastMessageDate = Date(timeIntervalSince1970: TimeInterval(lastMessage["date"] as? Int ?? 0))
        }
    }
    
    private func fillChatInfo(chatSettings: [String: Any], profiles: [[String: Any]], groups: [[String: Any]]) {
        
        if self.peerType == "user" {
            let findedOwner = profiles.filter { (profileDict) -> Bool in
                if let profileId = profileDict["id"] as? Int {
                    return profileId == self.peerId
                }
                return false
            }
            if findedOwner.count > 0 {
                self.title = "\(findedOwner[0]["first_name"] as? String ?? "") \(findedOwner[0]["last_name"] as? String ?? "")"
                self.avatarUrl = findedOwner[0]["photo_50"] as? String ?? ""
            }
        } else if self.peerType == "group" {
            let findedOwner = groups.filter { (groupDict) -> Bool in
                if let groupId = groupDict["id"] as? Int {
                    return groupId == self.peerId
                }
                return false
            }
            if findedOwner.count > 0 {
                self.title = findedOwner[0]["name"] as? String ?? ""
                self.avatarUrl = findedOwner[0]["photo_50"] as? String ?? ""
            }
        } else if self.peerType == "chat" {
            self.title = chatSettings["title"] as? String ?? ""
            if let photo = chatSettings["photo"] as? [String: Any],
                let photo50 = photo["photo_50"] as? String {
                self.avatarUrl = photo50
            }
        }
    }
    
    private func fillLastMessageOwner(ownerIdFromJson: Int?, profiles: [[String: Any]], groups: [[String: Any]]) {
        
        guard var ownerId = ownerIdFromJson else {
            return
        }
        
        if ownerId >= 0 {
            let findedOwner = profiles.filter { (profileDict) -> Bool in
                if let profileId = profileDict["id"] as? Int {
                    return profileId == ownerId
                }
                return false
            }
            if findedOwner.count > 0 {
                self.lastMessageOwnerId = ownerId
                self.lastMessageOwnerName = "\(findedOwner[0]["first_name"] as? String ?? "") \(findedOwner[0]["last_name"] as? String ?? "")"
                self.lastMessageOwnerUrl = findedOwner[0]["photo_50"] as? String ?? ""
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
                self.lastMessageOwnerId = ownerId
                self.lastMessageOwnerName = findedOwner[0]["name"] as? String ?? ""
                self.lastMessageOwnerUrl = findedOwner[0]["photo_50"] as? String ?? ""
            }
        }
    }
}
