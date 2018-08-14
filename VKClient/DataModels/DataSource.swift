//
//  DataSource.swift
//  VKClient
//
//  Created by Константин Зонин on 07.08.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import UIKit
import RealmSwift

class DataSource<Element: Object> {
    
    var token: NotificationToken?
    var objects: Results<Element>?
    
    init(realmObjectType: Element.Type, filteredBy condition: String? = nil) {
        guard let realm = try? Realm() else { return }
        objects = realm.objects(realmObjectType)
        if let condition = condition {
            objects = objects?.filter(NSPredicate(format: condition))
        }
    }
    
    func attachTo(tableView: UITableView) {
        
        token = objects?.observe { changes in
            
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
    
    func attachTo(collectionView: UICollectionView) {
        
        token = objects?.observe { changes in
            
            switch changes {
            case .initial:
                collectionView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                collectionView.performBatchUpdates({
                
                collectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
                collectionView.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0) }))
                collectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
                }, completion: nil)
                
            case .error(let error):
                print(error)
            }
        }
    }
    
}
