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
    var friendPhoto: [FriendsPhoto] = []
    
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
        return friendPhoto.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhotoCollectionViewCell", for: indexPath) as? FriendPhotoCollectionViewCell
            else { return UICollectionViewCell() }
    
        cell.avatarUrl = friendPhoto[indexPath.row].urlSizeM.isEmpty ? friendPhoto[indexPath.row].urlSizeO : friendPhoto[indexPath.row].urlSizeM
        
        return cell
    }
    
    // MARK: functions
    func fillPhotosArray() {
        VKApiService().getPhotosByUserId(userId) { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.friendPhoto = DataBase.getFriendsPhoto(forUserId: strongSelf.userId)
            strongSelf.collectionView?.reloadData()
        }
    }
}
