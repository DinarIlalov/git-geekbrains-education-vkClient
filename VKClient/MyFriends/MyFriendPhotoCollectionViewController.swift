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
    var imagesUrls: [String] = []
    
    // MARK: Class funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillImagesArray()
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
        return imagesUrls.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhotoCollectionViewCell", for: indexPath) as? FriendPhotoCollectionViewCell
            else { return UICollectionViewCell() }
    
        cell.avatarUrl = imagesUrls[indexPath.row]
        
        return cell
    }
    
    // MARK: functions
    func fillImagesArray() {
        VKApiService().getPhotosByUserId(userId) { [weak self] (photos) in
            self?.imagesUrls = photos
            self?.collectionView?.reloadData()
        }
    }
}
