//
//  MyFriendPhotoCollectionViewController.swift
//  VKClient
//
//  Created by Константин Зонин on 23.07.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import UIKit

class MyFriendPhotoCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var userId: Int = 0
    private var dataSource: DataSource<FriendsPhoto>?
    
    // MARK: Class funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillPhotosArray()
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let halfScreenSize = view.frame.width/2 - 8
        
        return CGSize(width: halfScreenSize, height: halfScreenSize)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.objects?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhotoCollectionViewCell", for: indexPath) as? FriendPhotoCollectionViewCell
            else { return UICollectionViewCell() }
    
        if let friendPhoto = dataSource?.objects {
            cell.avatarUrl = friendPhoto[indexPath.row].urlSizeM.isEmpty ? friendPhoto[indexPath.row].urlSizeO : friendPhoto[indexPath.row].urlSizeM
        }
        return cell
    }
    
    // MARK: functions
    private func fillPhotosArray() {
        
        dataSource = DataSource(realmObjectType: FriendsPhoto.self, filteredBy: "userId == \(userId)")
        VKApiService().getPhotosByUserId(userId)
        if let collectionView = collectionView {
            dataSource?.attachTo(collectionView: collectionView)
        }
    }
}
