//
//  MessagesViewController.swift
//  VKClient
//
//  Created by Илалов Динар on 24/09/2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    var chat: Chat!
    private var dataSource: DataSource<Message>?
    
    let currentUserId = UserData.GetCurrentUserId() ?? 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = chat.title
        fillTableData()
    }
    
    // MARK: - Functions
    private func fillTableData() {
        dataSource = DataSource(realmObjectType: Message.self, filteredBy: "peerId == \(chat.peerId)")
        VKApiService().getMessages(from: chat, offset: 0, count: 30, start_message_id: 0)
        dataSource?.attachTo(tableView: tableView)
    }

}

// MARK: - UITableViewDataSource
extension MessagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.objects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let message = dataSource?.objects?[indexPath.row] else { return UITableViewCell() }
        
        if message.authorId == currentUserId,
            let cell = tableView.dequeueReusableCell(withIdentifier: "outcommingCell", for: indexPath) as? OutcommingMessageTableViewCell {
            cell.message = message
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: "incommingCell", for: indexPath) as? IncommingMessageTableViewCell {
            cell.message = message
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}

// MARK: - UITabBarDelegate
extension MessagesViewController: UITabBarDelegate {
    
}
