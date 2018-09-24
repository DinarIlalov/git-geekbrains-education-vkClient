//
//  FirebaseService.swift
//  VKClient
//
//  Created by Илалов Динар on 07.09.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import Foundation
import Firebase

class FirebaseService {
    
    static var databaseTree: String {
        guard let userName = UserData.getCurrentUserName(), !userName.isEmpty else {
            return "users/unknown"
        }
        return "users/\(userName)"
    }
    
    static func saveLoginInfo() {
    
        DispatchQueue.global().async {
            let dbLink = Database.database().reference()
            dbLink.child(databaseTree).updateChildValues(["lastLogin": Date().description(with: Locale.current)])
            
            dbLink.child("\(databaseTree)/loginhistory")
                .updateChildValues([Date().description(with: Locale.current): "login"])
        }
    }
    
    static func saveUserGroups() {
        
        DispatchQueue.global().async {
            
            let dbLink = Database.database().reference()
            
            var groups: [String: String] = [:]
            if let groupsObjects = DataSource(realmObjectType: Group.self).objects {
                groups = Dictionary(uniqueKeysWithValues: Array(groupsObjects).map{ ($0.id.description, $0.name) })
            }
            
            dbLink.child("\(databaseTree)/groups").setValue(groups)
        }
    }
    
}
