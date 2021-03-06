//
//  Message.swift
//  VKClient
//
//  Created by Илалов Динар on 24/09/2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import Foundation
import RealmSwift

typealias MessageRef = ThreadSafeReference<Message>

class Message: Object {

    @objc dynamic var id: Int = 0
    @objc dynamic var peerId: Int = 0
    @objc dynamic var unixDate: Int = 0
    @objc dynamic var authorId: Int = 0
    @objc dynamic var text: String = ""
    
    var ref: MessageRef {
        return ThreadSafeReference(to: self)
    }
    static func instance(from ref: MessageRef?) -> Message? {
        guard let ref = ref,
            let realm = try? Realm() else { return nil }
        
        return realm.resolve(ref)
    }
    
    convenience init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
            let authorId = json["from_id"] as? Int
            else {
                return nil
        }
        self.init()
        
        self.id = id
        self.peerId = json["peer_id"] as? Int ?? 0
        self.unixDate = json["date"] as? Int ?? 0
        self.authorId = authorId
        self.text = json["text"] as? String ?? ""
    }    
}
