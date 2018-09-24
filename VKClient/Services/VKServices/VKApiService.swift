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
    
    func getCurrentUserCredentianals(completion: @escaping () -> Void) {
        let parameters: Parameters = [
            "access_token": accessToken,
            "v": apiVersion
        ]
        
        сreateRequestAndGetResponse(parameters, "users.get") { (response) in
            if let json = response.value as? [String: Any] {
                UserData.saveCurrentUserCredentials(json)
                print(json)
                completion()
            }
        }
    }
    
    func getCurrentUserFriends() {
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
                }
            }
        }
    }
    
    func getCurrentUserGroups() {
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
                }
            }
        }
    }
    
    func getPhotosByUserId(_ userId: Int) {
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
    
    func getNewsfeed(withOffset offset: Int, resultCount: Int, startFrom: String, completion: @escaping ([News], String)->Void) {
        let parameters: Parameters = [
            "access_token": accessToken,
            "v": apiVersion,
            "filter": "post, photo",
            "fields": "photo",
            "count": resultCount,
            "start_from": startFrom
        ]
        
        сreateRequestAndGetResponse(parameters, "newsfeed.get") { (response) in
            if let json = response.value as? ResponseJSONFormat,
                let response = json["response"],
                let items = response["items"] as? [[String:Any]] {
                
                let newsfeed = items.compactMap{ News(json: $0, profiles: response["profiles"] as? [[String:Any]] ?? [], groups: response["groups"] as? [[String:Any]] ?? []) }
                
                DispatchQueue.main.async {
                    completion(newsfeed, response["next_from"] as? String ?? "")
                }
            } else {
                DispatchQueue.main.async {
                    completion([], "")
                }
            }
        }
    }
    
    func getChatsList() {
        let parameters: Parameters = [
            "access_token": accessToken,
            "v": apiVersion,
            "extended": 1,
            "filter": "all",
            "offset": 0,
            "count": 30
        ]
        
        сreateRequestAndGetResponse(parameters, "messages.getConversations") { (response) in
            if let json = response.value as? ResponseJSONFormat,
                let response = json["response"],
                let items = response["items"] as? [[String:Any]] {
                
                let chats = items.compactMap{ Chat(json: $0, profiles: response["profiles"] as? [[String:Any]] ?? [], groups: response["groups"] as? [[String:Any]] ?? []) }
                
                DispatchQueue.main.async {
                    DataBase.saveChats(chats)
                }
            }
        }
    }
    
    func getMessages(from chat: Chat, offset: Int, count: Int, start_message_id: Int) {
        
        let peerId: Int
        if chat.peerType == "user" {
            peerId = chat.peerId
        } else if chat.peerType == "group" {
            peerId = chat.peerId * (-1)
        } else if chat.peerType == "chat" {
            peerId = chat.peerId + 2000000000
        } else {
            peerId = 0
        }
        
        let parameters: Parameters = [
            "access_token": accessToken,
            "v": apiVersion,
            "extended": 1,
            "offset": offset,
            "count": count,
            //"start_message_id": start_message_id,
            "peer_id": peerId,
            "rev": 0
        ]
        
        сreateRequestAndGetResponse(parameters, "messages.getHistory") { (response) in
            if let json = response.value as? ResponseJSONFormat,
                let response = json["response"],
                let items = response["items"] as? [[String:Any]] {
                
                let messages = items.compactMap{ Message(json: $0) }
                
                DispatchQueue.main.async {
                    DataBase.saveMessages(messages, peerId: chat.peerId)
                }
            }
        }
    }
}
