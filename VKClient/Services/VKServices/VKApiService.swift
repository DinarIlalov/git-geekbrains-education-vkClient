//
//  VKApiService.swift
//  VKClient
//
//  Created by Константин Зонин on 24.07.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import Foundation
import Alamofire

class VKApiService {
    let pathUrl: String
    let idApi: String = "6641335"
    let apiVersion: String = "5.80"
    private let accessToken: String = UserData.GetToken() ?? ""
    
    private typealias ResponseJSONFormat = [String: [String: Any]]
    
    convenience init() {
        self.init("https://api.vk.com/method")
    }
    
    init(_ url: String) {
        pathUrl = url
    }
    
    private func сreateRequestAndGetResponse(_ parameters: Parameters, _ method: String, completion: @escaping (DataResponse<Any>) -> Void) {
        guard let url = URL(string: pathUrl) else {
            return
        }
        Alamofire.request(url.appendingPathComponent(method), method: .get, parameters: parameters).responseJSON(queue: .global(qos: .userInitiated)) { response in
            
            completion(response)
        }
    }
    
    func getCurrentUserCredentianals() {
        let parameters: Parameters = [
            "access_token": accessToken,
            "v": apiVersion
        ]
        
        сreateRequestAndGetResponse(parameters, "users.get") { (response) in
            if let json = response.value as? [String: Any] {
                print(json)
            }
        }
    }
    
    func getCurrentUserFriends(completion: @escaping ()->Void) {
        let parameters: Parameters = [
            "access_token": accessToken,
            "v": apiVersion,
            "fields": "city,domain,photo_50"
        ]
        
        сreateRequestAndGetResponse(parameters, "friends.get") { (response) in
            if let json = response.value as? ResponseJSONFormat,
                let response = json["response"],
                let items = response["items"] as? [[String:Any]] {
                
                let friends = items.compactMap{ Friend(json: $0) }
                
                DispatchQueue.main.async {
                    DataBase.saveFriends(friends)
                    completion()
                }
            } else {
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    func getCurrentUserGroups(completion: @escaping ()->Void) {
        let parameters: Parameters = [
            "access_token": accessToken,
            "v": apiVersion,
            "extended": 1,
            "fields": "members_count"
        ]

        сreateRequestAndGetResponse(parameters, "groups.get") { (response) in
            if let json = response.value as? ResponseJSONFormat,
                let response = json["response"],
                let items = response["items"] as? [[String:Any]] {
                
                let groups = items.compactMap{ Group(json: $0) }
                
                DispatchQueue.main.async {
                    DataBase.saveGroups(groups)
                    completion()
                }
                
            } else {
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    func getPhotosByUserId(_ userId: Int, completion: @escaping ()->Void) {
        let parameters: Parameters = [
            "access_token": accessToken,
            "v": apiVersion,
            "owner_id": userId,
            "offset": 0,
            "count": 30
        ]
        
        сreateRequestAndGetResponse(parameters, "photos.getAll") { (response) in
            if let json = response.value as? ResponseJSONFormat,
                let response = json["response"],
                let items = response["items"] as? [[String:Any]] {
                
                let photos = items.compactMap{ FriendsPhoto(json: $0, userId: userId) }
                
                DispatchQueue.main.async {
                    DataBase.saveFriendsPhoto(photos, userId: userId)
                    completion()
                }
            } else {
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    func searchGroup(byName groupName: String, withOffset offset: Int, resultCount: Int, completion: @escaping ([Group], Int)->Void) {
        let parameters: Parameters = [
            "access_token": accessToken,
            "v": apiVersion,
            "q": groupName,
            "offset": offset,
            "count": resultCount,
            "fields": "members_count"
        ]
        
        сreateRequestAndGetResponse(parameters, "groups.search") { (response) in
            if let json = response.value as? ResponseJSONFormat,
                let jsonResponse = json["response"],
                let totalNumber = jsonResponse["count"] as? Int,
                let items = jsonResponse["items"] as? [[String: Any]] {
                
                let groups = items.compactMap{ Group(json: $0) }
                DispatchQueue.main.async {
                    completion(groups, totalNumber)
                }
            } else {
                DispatchQueue.main.async {
                    completion([], 0)
                }
            }
        }
    }
}
