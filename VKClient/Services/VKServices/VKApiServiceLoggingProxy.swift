//
//  VKApiServiceLoggingProxy.swift
//  VKClient
//
//  Created by Dinar Ilalov on 26/03/2019.
//  Copyright © 2019 Фирма ЛИСТ. All rights reserved.
//

import Foundation
import Alamofire

class VKApiServiceLoggingProxy: VKApiServiceInterface {
    
    let vkApiService: VKApiServiceInterface = VKApiService()
    
    func getMessagesRequest(with chatPeerType: String, chatPeerId: Int, offset: Int, count: Int, start_message_id: Int?) -> DataRequest? {
        log("getMessagesRequest")
        return vkApiService.getMessagesRequest(with: chatPeerType, chatPeerId: chatPeerId, offset: offset, count: count, start_message_id: start_message_id)
    }
    
    func getCurrentUserCredentianals(completion: @escaping () -> Void) {
        log("getCurrentUserCredentianals")
        vkApiService.getCurrentUserCredentianals(completion: completion)
    }
    
    func getCurrentUserFriends() {
        log("getCurrentUserFriends")
        vkApiService.getCurrentUserFriends()
    }
    
    func getCurrentUserGroups() {
        log("getCurrentUserGroups")
        vkApiService.getCurrentUserGroups()
    }
    
    func getPhotosByUserId(_ userId: Int) {
        log("getPhotosByUserId")
        vkApiService.getPhotosByUserId(userId)
    }
    
    func searchGroup(byName groupName: String, withOffset offset: Int, resultCount: Int, completion: @escaping ([Group], Int) -> Void) {
        log("searchGroup")
        vkApiService.searchGroup(byName: groupName, withOffset: offset, resultCount: resultCount, completion: completion)
    }
    
    func getNewsfeed(withOffset offset: Int, resultCount: Int, startFrom: String, completion: @escaping ([News], String) -> Void) {
        log("getNewsfeed")
        vkApiService.getNewsfeed(withOffset: offset, resultCount: resultCount, startFrom: startFrom, completion: completion)
    }
    
    func getChatsList() {
        log("getChatsList")
        vkApiService.getChatsList()
    }
    
    func getMessages(from chat: Chat, offset: Int, count: Int, start_message_id: Int) {
        log("getMessages")
        vkApiService.getMessages(from: chat, offset: offset, count: count, start_message_id: start_message_id)
    }
    
    
    private func log(_ text: String) {
        // не стал заморчаиваться с логгированием
        print(text)
    }
}
