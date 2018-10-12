//
//  GetMessagesOperation.swift
//  FSMessenger
//
//  Created by Илалов Динар on 24.08.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import Foundation
import Alamofire

class GetMessagesOperation: AsyncOperation {
    
    var responseJson: [String: Any]?
    
    weak var messageDataSource: MessagesDataSource?
    
    let offset: Int
    let count: Int
    let peerId: Int
    let peerType: String
    let loadingType: MessagesLoadingType
    
    var dataRequest: DataRequest?
    
    init(loadingType: MessagesLoadingType, peerType: String, peerId: Int) {
        
        self.loadingType = loadingType
        
        switch loadingType {
        case .last20:
            self.offset = 0
            self.count = 20
        case .next20:
            self.offset = -20
            self.count = 20
        case .previous20:
            self.offset = 0
            self.count = 21
        }
        self.peerId = peerId
        self.peerType = peerType
    }
    
    override func cancel() {
        dataRequest?.cancel()
        super.cancel()
    }
    
    override func main() {
        
        let startMessageId: Int?
        switch loadingType {
        case .previous20:
            startMessageId = messageDataSource?.oldestMessageId
        case .next20:
            startMessageId = messageDataSource?.newestMessageId
        default:
            startMessageId = nil
        }
        
        print("get \(loadingType) \(startMessageId)")
        dataRequest = VKApiService().getMessagesRequest(with: peerType, chatPeerId: peerId, offset: offset, count: count, start_message_id: startMessageId)
        
        guard let dataRequest = self.dataRequest else {
            self.state = .finished
            return
        }
        
        dataRequest.responseJSON(queue: .global(qos: .userInitiated)) { [weak self] response in
            self?.responseJson = response.value as? [String: Any]
            self?.state = .finished
            
            print("GetDataOperation \(String(describing: self?.loadingType))")
        }
    }
}
