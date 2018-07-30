//
//  File.swift
//  VKClient
//
//  Created by Константин Зонин on 24.07.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import Foundation

class Group: Hashable{
    var hashValue: Int { return id }
    
    static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    let id: Int
    let name: String
    let avatarUrl: String
    let type: GroupsType
    
    init(id: Int, name: String, avatarUrl: String, type: GroupsType) {
        self.id = id
        self.name = name
        self.avatarUrl = avatarUrl
        self.type = type
    }
    
    init?(json: [String: Any]) {
        
       guard let name = json["name"] as? String,
            let id = json["id"] as? Int
            else {
                return nil
        }
        
        self.name = name
        self.id = id
        self.avatarUrl = json["photo_50"] as? String ?? ""
        self.type = GroupsType(rawValue: json["type"] as? String ?? "group") ?? GroupsType.group
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
