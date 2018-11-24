//
//  CurrentUser.swift
//  SnapchatProject
//
//  Created by Daniel Phiri on 10/17/17.
//  Copyright © 2017 org.iosdecal. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth






class CurrentUser {
    
    var id: String!
    
    /// Username of the User
    var username: String!
    
    
    /// The ID of the post, generated automatically on Firebase
    //    let postId: String
    var gender: String!
    
    var major: String!
    
    var preferredmajor : String!
    /// Designated initializer for posts
    ///
    /// - Parameters:
    ///   - username: The name of the user making the post
    ///   - postImage: The image that will show up in the post
    ///   - thread: The thread that the image should be posted to
    let dbRef = Database.database().reference()
    
    
    init() {
        let currentUser = Auth.auth().currentUser
        id = currentUser?.uid
        username = "John Doe"
        //        gender = currentUser?.gender
        //        major = currentUser?.major
    }

    /*
     TODO:
     
     Retrieve a list of post ID's that the user has already opened and return them as an array of strings.
     Note that our database is set up to store a set of ID's under the readPosts node for each user.
     Make a query to Firebase using the 'observeSingleEvent' function (with 'of' parameter set to .value) and retrieve the snapshot that is returned. If the snapshot exists, store its value as a [String:AnyObject] dictionary and iterate through its keys, appending the value corresponding to that key to postArray each time. Finally, call completion(postArray).
     */
    
    
    /*
     TODO:
     
     Adds a new post ID to the list of post ID's under the user's readPosts node.
     This should be fairly simple - just create a new child by auto ID under the readPosts node and set its value to the postID (string).
     Remember to be very careful about following the structure of the User node before writing any data!
     */
//    func addNewReadPost(postID: String) {
//        // YOUR CODE HERE
//        let userID = Auth.auth().currentUser?.uid
//        readPostIDs?.append(postID)
//
////        dbRef.child("Users").child(id!).child(firReadPostsNode).childByAutoId().setValue(userID)
//    }
    
}
