//
//  Video.swift
//  myYoutube
//
//  Created by Armin Spahic on 09/11/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import UIKit

class Video: NSObject {
    
    var thumbnailImageName: String?
    var titleString: String?
    var numberOfViews: NSNumber?
    var uploadDate: NSDate?
    
    var channel: Channel?
    
    
}

class Channel: NSObject {
    
    var channelName: String?
    var profileImageName: String?
    
}
