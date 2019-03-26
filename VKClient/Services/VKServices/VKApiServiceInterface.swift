//
//  VKApiServiceInterface.swift
//  VKClient
//
//  Created by Dinar Ilalov on 26/03/2019.
//  Copyright © 2019 Фирма ЛИСТ. All rights reserved.
//

import Foundation
import Alamofire

protocol VKApiServiceInterface {
    
    func getMessagesRequest(with chatPeerType: String, chatPeerId: Int, offset: Int, count: Int, start_message_id: Int?) -> DataRequest?
    
    func getCurrentUserCredentianals(completion: @escaping () -> Void)
    
    func getCurrentUserFriends()
    
    func getCurrentUserGroups()
    
    func getPhotosByUserId(_ userId: Int)
    
    func searchGroup(byName groupName: String, withOffset offset: Int, resultCount: Int, completion: @escaping ([Group], Int)->Void)
    
    func getNewsfeed(withOffset offset: Int, resultCount: Int, startFrom: String, completion: @escaping ([News], String)->Void)
    
    func getChatsList()
    
    func getMessages(from chat: Chat, offset: Int, count: Int, start_message_id: Int)
}

extension VKApiServiceInterface {
    func getMessagesRequest(with chatPeerType: String, chatPeerId: Int, offset: Int, count: Int) -> DataRequest? {
        return getMessagesRequest(with: chatPeerType, chatPeerId: chatPeerId, offset: offset, count: count, start_message_id: nil)
    }
}
