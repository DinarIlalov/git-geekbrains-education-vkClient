//
//  ChatsViewController.swift
//  VKClient
//
//  Created by Илалов Динар on 16.08.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    var dataSource = DataSource(realmObjectType: Chat.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillTableData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "chatMessagesSegue":
            
            if let messagesController = segue.destination as? MessagesViewController,
                let tableCell = sender as? ChatsTableViewCell,
                let chat = tableCell.chat {
                messagesController.chat = chat
            }
            
        default:
            break
        }
    }
    
    // MARK: - Functions
    private func fillTableData() {
        VKApiService().getChatsList()
        dataSource.attachTo(tableView: tableView)
    }
}

// MARK: - UITableViewDataSource
extension ChatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.objects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ChatsTableViewCell else { return UITableViewCell() }
        
        cell.chat = dataSource.objects?[indexPath.row]
        cell.dateLabel.text = (cell.chat?.lastMessageDate ?? Date()).toRuDateString()
        return cell
    }
    

}
