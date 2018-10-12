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
    
    private var dataRequest: DataRequest?
    var responseJson: [String: Any]?
    var offset: Int = 0
    
    override init() {
        <#code#>
    }
    
    override func cancel() {
        dataRequest?.cancel()
        super.cancel()
    }
    
    override func main() {
        
        guard let request = VKApiService().getMessagesRequest(with: peerType, chatPeerId: peerId, offset: offset, count: count, start_message_id: startMessageId) else { return }
        
        guard let dataRequest = self.dataRequest else {
            self.state = .finished
            return
        }
        
        dataRequest.responseJSON(queue: .global(qos: .userInitiated)) { [weak self] response in
            self?.responseJson = response.value as? [String: Any]
            self?.state = .finished
            
            print("GetDataOperation \(self?.offset) finished")
        }
    }
    
    init(dataRequest: DataRequest) {
        self.dataRequest = dataRequest
    }
}
