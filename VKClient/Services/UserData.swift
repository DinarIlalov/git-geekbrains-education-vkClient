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
    
    static func saveCurrentUserCredentials(_ json: [String: Any]) {
        if let response = json["response"] as? [[String: Any]],
            response.count > 0 {
            let userInfo = response[0]
            let userName = "\(userInfo["first_name"] as? String ?? "") \(userInfo["last_name"] as? String ?? "")"
            UserDefaults.standard.set(userName, forKey: "userName")
        } else {
            UserDefaults.standard.set("unknown", forKey: "userName")
        }
    }
    
    static func getCurrentUserName() -> String? {
        return UserDefaults.standard.string(forKey: "userName")
    }
}
