//
//  MyFriendPhotoCollectionViewController.swift
//  VKClient
//
//  Created by Константин Зонин on 23.07.2018.
//  Copyright © 2018 Фирма ЛИСТ. All rights reserved.
//

import UIKit

class MyFriendPhotoCollectionViewController: UICollectionViewController {

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhotoCollectionViewCell", for: indexPath) as? FriendPhotoCollectionViewCell
            else { return UICollectionViewCell() }
    
        cell.photoImageView.image = #imageLiteral(resourceName: "ic_userAvatar")
        
        return cell
    }
}
