//
//  SubscriptionsCell.swift
//  myYoutube
//
//  Created by Armin Spahic on 12/11/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import UIKit

//
//  HomeCell.swift
//  myYoutube
//
//  Created by Armin Spahic on 12/11/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import UIKit

class SubscriptionsCell: HomeCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var homeController: HomeController?
    
    var videos: [Video]?
    
    let cellId = "cellId"
    
    func loadHomeVideos() {
        ApiService.sharedInstance.fetchVideos { (videos) in
            self.videos = videos
            self.homeCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VideoCell
        if let video = videos?[indexPath.item] {
            cell.video = video
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (frame.width - 12 - 12) * 9 / 16
        return CGSize(width: frame.width, height: height + 16 + 88)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    lazy var homeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor.clear
        cv.contentInset = UIEdgeInsets(top: -15, left: 0, bottom: 0, right: 0)
        cv.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        return cv
    }()
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        homeController?.scrollViewDidScroll(scrollView)
    }
    
    override func setupViews() {
        loadHomeVideos()
        homeCollectionView.register(VideoCell.self, forCellWithReuseIdentifier: cellId)
        addSubview(homeCollectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: homeCollectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: homeCollectionView)
    }
}

