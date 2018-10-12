//
//  DataBase.swift
//  VKClient
//
//  Created by Константин Зонин on 05.08.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import Foundation
import RealmSwift

class DataBase {
    
    static func saveFriends(_ friends: [Friend]) {
        saveDataForType(Friend.self, data: friends)
    }
    
    static func getFriends() -> [Friend] {
        return getDataForType(Friend.self)
    }
    
    static func getFriendById(_ id: Int) -> Friend? {
        do {
            let realm = try Realm()
            let object = realm.object(ofType: Friend.self, forPrimaryKey: id)
            return object
        } catch {
            print(error)
            return nil
        }
    }
    
    static func saveGroups(_ groups: [Group]) {
        saveDataForType(Group.self, data: groups)
    }
    
    static func saveGroup(_ group: Group) {
        saveDataForType(Group.self, data: [group], filteredBy: "id = \(group.id)")
    }
    
    static func getGroups() -> [Group] {
        return getDataForType(Group.self)
    }
    
    static func removeGroup(_ group: Group) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.delete(group)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    static func saveFriendsPhoto(_ photos: [FriendsPhoto], userId: Int) {
        saveDataForType(FriendsPhoto.self, data: photos, filteredBy: "userId = \(userId)")
    }
    
    static func getFriendsPhoto(forUserId userId: Int) -> [FriendsPhoto] {
        return getDataForType(FriendsPhoto.self, filteredBy: "userId = \(userId)")
    }
    
    static func saveChats(_ chats: [Chat]) {
        saveDataForType(Chat.self, data: chats)
    }
    
    static func getChats() -> [Chat] {
        return getDataForType(Chat.self)
    }
    
    static func saveMessages(_ messages: [Message], peerId: Int) {
        saveDataForType(Message.self, data: messages, filteredBy: "peerId = \(peerId)")
    }
    
    static func getMessages(for peerId: Int) -> [Message] {
        return getDataForType(Message.self, filteredBy: "peerId = \(peerId)")
    }
    
    static func clearMessages(for peerId: Int) {
        do {
            let realm = try Realm()
            
            var oldData = realm.objects(Message.self)
            oldData = oldData.filter(NSPredicate(format: "peerId = \(peerId)"))
            realm.beginWrite()
            realm.delete(oldData)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    static func getMessage(byId id: Int) -> Message? {
        return getDataForType(Message.self, filteredBy: "id = \(id)").first
    }
    
    private static func getDataForType<Element: Object>(_ type: Element.Type, filteredBy condition: String? = nil) -> [Element] {
        do {
            let realm = try Realm()
            
            var objects = realm.objects(type)
            if let condition = condition {
                objects = objects.filter(NSPredicate(format: condition))
            }
            return Array(objects)
        } catch {
            print(error)
            return []
        }
    }
    
    private static func saveDataForType<Element: Object>(_ type: Element.Type, data: [Object], filteredBy condition: String? = nil) {
        do {
            // для миграции
//            let realm = try Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
            let realm = try Realm()
            
            print(realm.configuration.fileURL as Any)
            
            var oldData = realm.objects(type)
            if let condition = condition {
                oldData = oldData.filter(NSPredicate(format: condition))
            }
            realm.beginWrite()
            realm.delete(oldData)
            realm.add(data)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}
