//
//  Post.swift
//  SnapchatProject
//
//  Created by Paige Plander on 3/11/17.
//  Copyright © 2017 org.iosdecal. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class Post {
    /// Username of the poster
    let username: String
    
    /// The date that the snap was posted
    let date: Date
    
    /// The ID of the post, generated automatically on Firebase
    //    let postId: String
    let gender: String
    
    let major: String
    
    let major_pref: String
    
    let gender_pref: String
    
    let affiliation: String
    
    let profile_image_url: String
    
    let start_lat: Double
    
    let start_lon: Double
    
    let dest_lat: Double
    
    let dest_lon: Double
    
    var chat_id: String?
    /// Designated initializer for posts
    ///
    /// - Parameters:
    ///   - username: The name of the user making the post
    ///   - postImage: The image that will show up in the post
    ///   - thread: The thread that the image should be posted to
    init(username: String, dateString: String, gender: String, major: String, major_pref: String, gender_pref: String, profile_image_url:String,affiliation: String,  start_lat:Double, dest_lat:Double, start_lon:Double, dest_lon:Double) {
        
        self.username = username
        
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.A"
        //
        //        self.date = dateFormatter.date(from: dateString)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.A"
        let dateString = dateFormatter.string(from: Date())
        self.date = dateFormatter.date(from: dateString)!
        
        
        
        //no use of ids for now??
        //        self.postId = id
        self.gender = gender
        self.major = major
        self.gender_pref = gender_pref
        self.major_pref = major_pref
        self.profile_image_url = profile_image_url
        self.affiliation = affiliation
        self.start_lat = start_lat
        self.dest_lat = dest_lat
        self.start_lon = start_lon
        self.dest_lon = dest_lon
        
    }
    
    
    
    func getTimeElapsedString() -> String {
        let secondsSincePosted = -date.timeIntervalSinceNow
        let minutes = Int(secondsSincePosted / 60)
        if minutes == 1 {
            return "\(minutes) minute ago"
        } else if minutes < 60 {
            return "\(minutes) minutes ago "
        } else if minutes < 120 {
            return "1 hour ago"
        } else if minutes < 24 * 60 {
            return "\(minutes / 60) hours ago"
        } else if minutes < 48 * 60 {
            return "1 day ago"
        } else {
            return "\(minutes / 1440) days ago"
        }
        
    }
    
}
