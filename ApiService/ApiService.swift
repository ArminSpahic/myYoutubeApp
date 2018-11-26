//
//  ApiService.swift
//  myYoutube
//
//  Created by Armin Spahic on 12/11/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import UIKit

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    
    let baseUrl = "https://s3-us-west-2.amazonaws.com/youtubeassets"
    
    func fetchVideos(completionHandler: @escaping ([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseUrl)/home.json", completionHandler: completionHandler)
    }
    
    func fetchTrendingVideos(completionHandler: @escaping ([Video]) -> ()) {
       fetchFeedForUrlString(urlString: "\(baseUrl)/trending.json", completionHandler: completionHandler)
    }
    
    func fetchSubscriptionsVideos(completionHandler: @escaping ([Video]) -> ()) {
       fetchFeedForUrlString(urlString: "\(baseUrl)/subscriptions.json", completionHandler: completionHandler)
    }
    
    func fetchFeedForUrlString(urlString: String, completionHandler: @escaping ([Video]) -> ()) {
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                var videos = [Video]()
                for dictionary in json as! [[String:Any]] {
                    let video = Video()
                    video.titleString = dictionary["title"] as? String
                    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
                    
                    let channelDictionary = dictionary["channel"] as! [String:AnyObject]
                    let channel = Channel()
                    channel.profileImageName = channelDictionary["profile_image_name"] as? String
                    channel.channelName = channelDictionary["name"] as? String
                    video.channel = channel
                    videos.append(video)
                }
                DispatchQueue.main.async {
                    completionHandler(videos)
                }
                
                print(json)
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }
    
}
