//
//  Friends.swift
//  VKClient
//
//  Created by Константин Зонин on 24.07.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import Foundation

// TODO: переделать на классы
class Friend {
    
    let id: String
    let name: String
    let avatarUrl: String
    
    init(id: String, name: String, avatarUrl: String) {
        self.id = id
        self.name = name
        self.avatarUrl = avatarUrl
    }
    
    convenience init?(json: [String: Any]) {
        
        guard let name = json["title"] as? String,
            let id = json["id"] as? String else { return nil }
        
        self.init(id: id, name: name, avatarUrl: json["photo_50"] as? String ?? "")
        
    }
    
}
