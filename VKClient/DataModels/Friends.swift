//
//  Friends.swift
//  VKClient
//
//  Created by Константин Зонин on 24.07.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import Foundation

class Friend {
    
    let id: Int
    let name: String
    let avatarUrl: String
    var online: Bool = false
    
    init(id: Int, name: String, avatarUrl: String) {
        self.id = id
        self.name = name
        self.avatarUrl = avatarUrl
    }
    
    init?(json: [String: Any]) {
        
        guard let name = json["first_name"] as? String,
            let id = json["id"] as? Int else { return nil }
        
        self.id = id
        self.name = "\(name) \(json["last_name"] ?? "")"
        self.avatarUrl = json["photo_50"] as? String ?? ""
        self.online = json["online"] as? Bool ?? false
    }
    
}
