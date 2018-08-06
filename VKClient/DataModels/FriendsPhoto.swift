//
//  FriendsPhoto.swift
//  VKClient
//
//  Created by Константин Зонин on 06.08.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import Foundation
import RealmSwift

class FriendsPhoto: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var urlSizeM: String = ""
    @objc dynamic var urlSizeO: String = ""
    @objc dynamic var userId = 0
    
//    override static func primaryKey() -> String? {
//        return "id"
//    }
    
    convenience init?(json: [String: Any], userId: Int) {
        guard let id = json["id"] as? Int else { return nil }
        
        self.init()
        
        self.id = id
        self.userId = userId
        
        if let sizes = json["sizes"] as? [[String: Any]] {
            for sizeType in sizes {
                if sizeType["type"] as? String == "m" {
                    self.urlSizeM = sizeType["url"] as? String ?? ""
                } else if sizeType["type"] as? String == "o" {
                    self.urlSizeO = sizeType["url"] as? String ?? ""
                }
            }
        }
    }
}
