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
    private var dataSource: MessagesDataSource?
    
    let currentUserId = UserData.GetCurrentUserId() ?? 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = chat.title
        fillTableData()
    }
    
    // MARK: - Functions
    private func fillTableData() {
//        9134708
    
        dataSource = MessagesDataSource(chat: chat)
        dataSource?.attachTo(tableView: tableView)
    }

    @IBAction func clearMessagesCashButtonDidTap(_ sender: UIBarButtonItem) {
        DataBase.clearMessages(for: chat.peerId)
    }
}

// MARK: - UITableViewDataSource
extension MessagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let message = dataSource?.messages?[indexPath.row] else { return UITableViewCell() }
        
        print(indexPath)
        
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

extension MessagesViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        // - подгружаем next20 если доходим до первой ячйки
        // - подгружаем previos20:
        //      - первое срабатывание
        //          если загрузка в пустой чат, то загрузится 20 самых новых, и 20 предыдущих = 40
        //              если 40 и при префетчинге достигли 40ой, то грузим еще 20
        //              если меньше 40, то при префетчинг мы до 40ой не дойдем, следовательно не грузим
        //          если чат не пустой, то грузится next20 и previous20
        //              если 40 (в чате было <=20 сообщений), то сценарий такой же
        //              если >40, то сценарий такой же
        //      - последующие срабатывания:
        //          срабатываем на 40, 60, 80 и т.д. сообщениях
        //
        
        if isFirstIndexPathInclude(indexPaths) {
            print("first \(indexPaths.first)")
            dataSource?.loadNext20()
        }
        
        if isCanPrefetch(indexPaths) {
            print("isCanPrefetch")
            print(indexPaths)
            dataSource?.loadPrevious20()
        }
        
        print("prefetching \(indexPaths)")
    }
    
    private func isLastIndexPathInclude(_ indexPaths: [IndexPath]) -> Bool {
        
        let lastSectionIndex = tableView.numberOfSections-1
        let lastRowInSection = tableView.numberOfRows(inSection: lastSectionIndex)-1
        
        return indexPaths.contains(IndexPath(row: lastRowInSection, section: lastSectionIndex))
    }
    private func isFirstIndexPathInclude(_ indexPaths: [IndexPath]) -> Bool {
        return indexPaths.contains(IndexPath(row: 0, section: 0))
    }
    private func isCanPrefetch(_ indexPaths: [IndexPath]) -> Bool {
        guard let numberOfLoadedMessages = dataSource?.numberOfLoadedMessages else { return false }
        
        if numberOfLoadedMessages > 0 {
            return indexPaths.contains(IndexPath(row: numberOfLoadedMessages-1, section: 0))
        } else {
            // префетчинг 20ой ячейки срабатывает быстрее (если ячейки узские)
            return false
        }
    }
    
}
