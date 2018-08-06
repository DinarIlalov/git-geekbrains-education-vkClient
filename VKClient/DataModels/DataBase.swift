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
        do {
            let realm = try Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
            
            realm.beginWrite()
            realm.add(group)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    static func getGroups() -> [Group] {
        return getDataForType(Group.self)
    }
    
    static func saveFriendsPhoto(_ photos: [FriendsPhoto], userId: Int) {
        saveDataForType(FriendsPhoto.self, data: photos, filteredBy: NSPredicate(format: "userId = \(userId)"))
    }
    
    static func getFriendsPhoto(forUserId userId: Int) -> [FriendsPhoto] {
        return getDataForType(FriendsPhoto.self, filteredBy: NSPredicate(format: "userId = \(userId)"))
    }
    
    private static func getDataForType<Element: Object>(_ type: Element.Type, filteredBy predicate: NSPredicate? = nil) -> [Element] {
        do {
            let realm = try Realm()
            
            if let predicate = predicate {
                let objects = realm.objects(type).filter(predicate)
                return Array(objects)
            } else {
                let objects = realm.objects(type)
                return Array(objects)
            }
        } catch {
            print(error)
            return []
        }
    }
    
    private static func saveDataForType<Element: Object>(_ type: Element.Type, data: [Object], filteredBy predicate: NSPredicate? = nil) {
        do {
            
            let realm = try Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
            
            print(realm.configuration.fileURL as Any)
            
            var oldData: Results<Element>
            if let predicate = predicate {
                oldData = realm.objects(type).filter(predicate)
            } else {
                oldData = realm.objects(type)
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
