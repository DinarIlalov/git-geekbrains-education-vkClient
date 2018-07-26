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
    let idApi: String
    let apiVersion: String
    
    convenience init() {
        self.init("https://api.vk.com/method")
    }
    
    init(_ url: String) {
        pathUrl = url
        idApi = "6641335"
        apiVersion = "5.80"
    }
    
    func сreateRequestAndGetResponse(_ parameters: Parameters, _ method: String, completion: @escaping (DataResponse<Any>) -> Void) {
        guard let url = URL(string: pathUrl) else {
            return
        }
        Alamofire.request(url.appendingPathComponent(method), method: .get, parameters: parameters).responseJSON(queue: .global(qos: .userInitiated)) { response in
            
            completion(response)
        }
    }
    
    func createRequestAndGetImage(from url: String, completion: @escaping (Data?)->Void) {
        guard let url = URL(string: url) else {
            return
        }
        
        Alamofire.request(url, method: .get, parameters: nil).responseData(queue: .global(qos: .userInitiated)) { response in
            
            completion(response.data)
        }
    }
    
    func getCurrentUserCredentianals() {
        
        let parameters: Parameters = [
            "access_token": UserData.GetToken() ?? "",
            "v": apiVersion
        ]
        
        сreateRequestAndGetResponse(parameters, "users.get") { (response) in
            
            if let json = response.value as? [String: Any] {
                print(json)
            }
        }
    }
    
    func getCurrentUserFriends() {
        let parameters: Parameters = [
            "access_token": UserData.GetToken() ?? "",
            "v": apiVersion,
            "fields": "city,domain,photo_50"
        ]
        
        сreateRequestAndGetResponse(parameters, "friends.get") { (response) in
            if let json = response.value as? [String: Any] {
                print(json)
            }
        }
    }
    
    func getCurrentUserGroups() {
        
        let parameters: Parameters = [
            "access_token": UserData.GetToken() ?? "",
            "v": apiVersion,
            "extended": 1
        ]
        
        сreateRequestAndGetResponse(parameters, "groups.get") { (response) in
            if let json = response.value as? [String: Any] {
                print(json)
            }
        }
    }
    
    func searchGroup(byName groupName: String, withOffset offset: Int, resultCount: Int, completion: @escaping ([Group], Int)->Void) {
        let parameters: Parameters = [
            "access_token": UserData.GetToken() ?? "",
            "v": apiVersion,
            "q": groupName,
            "offset": offset,
            "count": resultCount
        ]
        
        сreateRequestAndGetResponse(parameters, "groups.search") { (response) in
            
            if let json = response.value as? [String: [String: Any]],
                let jsonResponse = json["response"],
                let totalNumber = jsonResponse["count"] as? Int,
                let items = jsonResponse["items"] as? [[String: Any]] {
                
                print(json)
                
                let groups = items.compactMap{ Group(json: $0) }
                completion(groups, totalNumber)
            } else {
                completion([], 0)
            }
        }
    }
}
