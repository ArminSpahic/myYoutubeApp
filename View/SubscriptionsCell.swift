//
//  SubscriptionsCell.swift
//  myYoutube
//
//  Created by Armin Spahic on 12/11/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import UIKit

class SubscriptionsCell: HomeCell {
    
    override func fetchVideos() {
        ApiService.sharedInstance.fetchSubscriptionsVideos { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
    
}
