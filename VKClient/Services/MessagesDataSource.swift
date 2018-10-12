//
//  MessagesLoader.swift
//  FSMessenger
//
//  Created by Илалов Динар on 25/09/2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import Foundation
import RealmSwift

// 1. подгружаем 20 новых сообщений начиная с последнего id
// 2. подгружаем 20 сообщений до последнего
// 3. подгружаем при перемотке:
//      - вниз (к новым) по 20 начиная  с последнего id
//      - вверх (к старым) по 20 с последнего обновленного (внизу списка) в этом сеансе
// 4. останавливаем автоподгрузку при достижении потолка (дошли до последнего) и дна (дошли до первого)

class MessagesDataSource {
    
    private let tasksQueue: OperationQueue
    private var token: NotificationToken?
    private(set) var messages: Results<Message>?
    let chat: Chat
    let peerId: Int
    let peerType: String
    let chatLastMessageId: Int
    
    var numberOfLoadedMessages = 0
    
    var newestMessageId: Int = 0 // последнее подгруженное новое сообщение
    var oldestMessageId: Int = 0 // первое подгруженное старое сообщение
    
    init(chat: Chat) {
        tasksQueue = OperationQueue()
        tasksQueue.maxConcurrentOperationCount = 1
        
        self.chat = chat
        self.peerType = chat.peerType
        self.peerId = chat.peerId
        self.chatLastMessageId = chat.lastMessageId
        
        guard let realm = try? Realm() else { return }
        messages = realm
            .objects(Message.self)
            .filter(NSPredicate(format: "peerId == \(chat.peerId)"))
            .sorted(byKeyPath: "id", ascending: false)
        
        
        if let newestMessage = messages?.first {
            // в чате НЕ пусто
            newestMessageId = newestMessage.id
            oldestMessageId = newestMessage.id
            
            // сразу грузим новые 20 и обновляем существующие 20
            self.loadNext20()
            self.loadPrevious20()

        } else if chatLastMessageId > 0 {
            // грузим новые 20 и грузим еще 20
            self.oldestMessageId = -1 // первый раз надо попытаться загрузить в любом случае
            self.loadLast20()
            self.loadPrevious20()
        }
    }
    
    deinit {
        tasksQueue.cancelAllOperations()
    }
    
    private func loadLast20() {
        
        // сообщения отсортированы по id в порядке убывания. первым идет самое "свежее", вторым менее и т.д.
        print("Load last20")
        numberOfLoadedMessages += 20
        load(loadingType: .last20)
    }
    
    func loadNext20() {

        print("Load next20")
        // не грузим если загрузили последнее сообщение чата
        if newestMessageId == chat.lastMessageId {
            print("потолок")
            return
        }
        
        // сообщения отсортированы по id в порядке убывания. первым идет самое "свежее", вторым менее и т.д
        numberOfLoadedMessages += 20
        load(loadingType: .next20)
    }
    
    func loadPrevious20() {
        
        print("Load previous20")
        // не грузим если загрузили первое сообщение чата ()
        if oldestMessageId == 0 {
            print("дно")
            return
        }
        
        // сообщения отсортированы по id в порядке убывания. первым идет самое "свежее", вторым менее и т.д.
        numberOfLoadedMessages += 20
        load(loadingType: .previous20)
    }
    
    private func load(loadingType: MessagesLoadingType) {
        
        let getMessagesOperation = GetMessagesOperation(loadingType: loadingType, peerType: chat.peerType, peerId: chat.peerId)
        getMessagesOperation.messageDataSource = self
        tasksQueue.addOperation(getMessagesOperation)
        
        let parseJson = SaveMessagesOperation(loadingType: loadingType)
        parseJson.messageDataSource = self
        parseJson.addDependency(getMessagesOperation)
        
        parseJson.completionBlock = {
            print("done \(loadingType)")
        }
        tasksQueue.addOperation(parseJson)
        
    }
    
    func attachTo(tableView: UITableView) {
        
        token = messages?.observe { changes in
            
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                print(error)
            }
        }
    }
}

enum MessagesLoadingType {
    case previous20
    case next20
    case last20
}
