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
    
    let id: String
    var email: String
    
    /// Username of the User
    var username: String
    
    
    /// The ID of the post, generated automatically on Firebase
    //    let postId: String
    var gender: String
    
    //let preferredGender : String
    
    var major: String
    
    var major_pref : String
    var gender_pref : String
    var profile_image_url : String
    var emerg_phone : String
    /// Designated initializer for posts
    ///
    /// - Parameters:
    ///   - username: The name of the user making the post
    ///   - postImage: The image that will show up in the post
    ///   - thread: The thread that the image should be posted to
    let dbRef = Database.database().reference()
    
    init(id: String){
        self.id = id
        //        gender = currentUser?.gender
        //        major = currentUser?.major
        self.email = "loading"
        self.username = "loading"
        self.gender = "loading"
        self.major = "loading"
        self.major_pref = "loading"
        self.gender_pref = "loading"
        self.profile_image_url = "loading"
        self.emerg_phone = "loading"
        syncData()
    }
    
    init(id: String, email: String){
        self.id = id
        self.email = email
        //        gender = currentUser?.gender
        //        major = currentUser?.major
        
        self.username = "loading"
        self.gender = "loading"
        self.major = "loading"
        self.major_pref = "loading"
        self.gender_pref = "loading"
        self.emerg_phone = "loading"
        self.profile_image_url = "loading"
        syncData()
    }
    
    func syncData(){
        print("Syncing "+self.id)
        dbRef.child("Users").child(self.id).observeSingleEvent(of: .value, with: { snapshot -> Void in
            if snapshot.exists() {
                if let profile = snapshot.value as? [String:AnyObject] {
                    
                    self.username = profile["Username"] as! String
                    self.gender = profile["Gender"] as! String
                    self.major = profile["Major"] as! String
                    self.major_pref = profile["Preferred_Major"] as! String
                    self.gender_pref = profile["Preferred_Gender"] as! String
                    self.profile_image_url = profile["profile_image_url"] as! String
                    self.email = profile["Email"] as! String
                    self.emerg_phone =  profile["Emergency_Phone_Number"] as! String
                    
                }
            }else{
                print("Warning: userID not recognized in firebase")
            }
            
        })
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
