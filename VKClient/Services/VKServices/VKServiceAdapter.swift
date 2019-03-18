//
//  VKServiceAdapter.swift
//  VKClient
//
//  Created by Dinar Ilalov on 15/03/2019.
//  Copyright © 2019 Фирма ЛИСТ. All rights reserved.
//

import Foundation
import RealmSwift

final class VKServiceAdapter {
    
    private let vkService = VKApiService()
    private var token: NotificationToken?
    
    func getFriends(completion: @escaping ([UserFriend]) -> Void) {
        
        guard let realm = try? Realm() else { return }
        let objects = realm.objects(Friend.self)
        
        token?.invalidate()
        
        token = objects.observe { [weak self] changes in
            guard let `self` = self else { return }
            
            switch changes {
            case .initial:
                break
            case .update(let rlmFriends, _, _, _):
                
                let userFriends: [UserFriend] = rlmFriends.compactMap(self.convertToUserFriends)
                self.token?.invalidate()
                completion(userFriends)
                
            case .error(let error):
                print(error)
            }
        }
        
        vkService.getCurrentUserFriends()
    }
    
    private func convertToUserFriends(_ rlmFriend: Friend) -> UserFriend {
        return UserFriend.init(id: rlmFriend.id, name: rlmFriend.name, avatarUrl: rlmFriend.avatarUrl, online: rlmFriend.online)
    }
    
}
