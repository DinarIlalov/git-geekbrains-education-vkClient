//
//  Friends.swift
//  VKClient
//
//  Created by Константин Зонин on 24.07.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import Foundation
import RealmSwift

class Friend: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var avatarUrl: String = ""
    @objc dynamic var online: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init?(json: [String: Any]) {
        guard let name = json["first_name"] as? String,
            let id = json["id"] as? Int else { return nil }
        
        self.init()
        
        self.id = id
        self.name = "\(name) \(json["last_name"] ?? "")"
        self.avatarUrl = json["photo_50"] as? String ?? ""
        self.online = json["online"] as? Bool ?? false
    }
    
}
