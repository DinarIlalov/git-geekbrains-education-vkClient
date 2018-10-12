//
//  ParseJsonAndSaveOperatios.swift
//  FSMessenger
//
//  Created by Илалов Динар on 11.09.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import Foundation
import RealmSwift

class SaveMessagesOperation: AsyncOperation {
    
    weak var messageDataSource: MessagesDataSource?
    let loadingType: MessagesLoadingType
    
    init(loadingType: MessagesLoadingType) {
        self.loadingType = loadingType
    }
    
    override func main() {
        
        guard let getDataOperation = dependencies.first as? GetMessagesOperation,
            let json = getDataOperation.responseJson,
            let response = json["response"] as? [String: Any],
            let items = response["items"] as? [[String:Any]],
            items.count > 0
            else {
                if loadingType == .previous20 {
                    messageDataSource?.oldestMessageId = 0
                }
                self.state = .finished
                return
        }
        
        let realm: Realm
        do {
            realm = try Realm()
        } catch {
            print(error)
            self.state = .finished
            return
        }
        
        let messages: [Message] = items.compactMap{ message in
            return updateOrAddMessage(realm: realm, json: message)
        }

        // - если загрузка в пустой чат (last20), то
        //      последнее полученное сообщение - oldestMessage
        //      первое полученное сообщение - newestMessage
        // - если загрузка новых 20 (next20), то
        //      последнее загруженное сообщение - не обновляем
        //      первое загруженное сообщение - newestMessage
        // - если загрузка старых 20 (previous20), то
        //      последнее загруженное сообщение - oldestMessage
        //      первое загруженное сообщение - не обновляем
        
        switch loadingType {
        case .last20:
            messageDataSource?.newestMessageId = messages.first?.id ?? 0
            messageDataSource?.oldestMessageId = messages.last?.id ?? 0
        case .next20:
            messageDataSource?.newestMessageId = messages.first?.id ?? 0
        case .previous20:
            messageDataSource?.oldestMessageId = messages.last?.id ?? 0
        }
    
        messageDataSource?.numberOfLoadedMessages -= 20
        messageDataSource?.numberOfLoadedMessages += messages.count
        if loadingType == .previous20 {
            messageDataSource?.numberOfLoadedMessages -= 1 // для previous20 грузятся 21 сообщений, включая lastMessage
        }
        
        print("SaveMessagesOperation newId \(messageDataSource?.newestMessageId)")
        print("SaveMessagesOperation oldId \(messageDataSource?.oldestMessageId)")
        print("SaveMessagesOperation number \(messageDataSource?.numberOfLoadedMessages)")
        print("SaveMessagesOperation \(String(describing: self.loadingType))")
        self.state = .finished

    }
    
    private func updateOrAddMessage(realm: Realm, json: [String: Any]) -> Message? {
        
        guard let id = json["id"] as? Int,
            let authorId = json["from_id"] as? Int
            else {
                return nil
        }
        
        let objects = realm.objects(Message.self).filter(NSPredicate(format: "id = \(id)"))
        
        // new message
        guard let message = objects.first
            else {
                if let message = Message(json: json) {
                    do {
                        try realm.write {
                            realm.add(message)
                        }
                        return message
                    } catch {
                        return nil
                    }
                } else {
                    return nil
                }
        }
        
        let peerId = json["peer_id"] as? Int ?? 0
        let unixDate = json["date"] as? Int ?? 0
        let text = json["text"] as? String ?? ""
        
        // not changed
        if message.authorId == authorId,
            message.peerId == peerId,
            message.text == text,
            message.unixDate == unixDate {
            return message
        // changed
        } else {
            do {
                try realm.write {
                    message.authorId = authorId
                    message.peerId = peerId
                    message.text = text
                    message.unixDate = unixDate
                }
                return message
            } catch {
                return nil
            }
            
        }
    }
}
