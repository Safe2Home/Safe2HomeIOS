//
//  Post.swift
//  SnapchatProject
//
//  Created by Paige Plander on 3/11/17.
//  Copyright © 2017 org.iosdecal. All rights reserved.
//

import Foundation
import UIKit

class Post {
    
    /// Boolean indicating whether or not the post has been read
    var read: Bool = false
    
    /// Username of the poster
    let username: String
    
    /// The thread the the post was added to
    let thread: String
    
    /// The date that the snap was posted
    let date: Date
    
    /// The image path of the post
    let postImagePath: String
    
    /// The ID of the post, generated automatically on Firebase
    let postId: String
    
    
    /// Designated initializer for posts
    ///
    /// - Parameters:
    ///   - username: The name of the user making the post
    ///   - postImage: The image that will show up in the post
    ///   - thread: The thread that the image should be posted to
    init(id: String, username: String, postImagePath: String, thread: String, dateString: String, read: Bool) {
        self.postImagePath = postImagePath
        self.username = username
        self.thread = thread
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.A"
        self.date = dateFormatter.date(from: dateString)!
        self.read = read
        self.postId = id
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
