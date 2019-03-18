//
//  File.swift
//  VKClient
//
//  Created by Константин Зонин on 24.07.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import Foundation
import RealmSwift

class Group: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var avatarUrl: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var members_count: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init?(json: [String: Any]) {
        guard let name = json["name"] as? String,
            let id = json["id"] as? Int
            else {
                return nil
        }
        self.init()
        
        self.name = name
        self.id = id
        self.avatarUrl = json["photo_50"] as? String ?? ""
        self.type = json["type"] as? String ?? "group"
        self.members_count = json["members_count"] as? Int ?? 0
    }
}

enum GroupsType: String {
    case page
    case group
    case event
    
    var description: String {
        switch self {
        case .page:
            return "Страница"
        case .event:
            return "Мероприятие"
        default:
            return "Группа"
        }
    }
}
