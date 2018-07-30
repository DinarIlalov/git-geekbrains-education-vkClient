//
//  UserData.swift
//  VKClient
//
//  Created by Константин Зонин on 24.07.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import Foundation

class UserData {
    
    // TODO: переделать на Keychain
    static func SaveData(token: String, userId: Int) {
        UserDefaults.standard.set(token, forKey: "Token")
        UserDefaults.standard.set(userId, forKey: "UserId")
    }
    
    static func GetToken() -> String? {
        return UserDefaults.standard.string(forKey: "Token")
    }
    
    static func GetCurrentUserId() -> Int? {
        return UserDefaults.standard.integer(forKey: "UserId")
    }
}
