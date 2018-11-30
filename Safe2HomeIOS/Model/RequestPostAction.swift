//
//  imageFeed.swift
//  SnapchatProject
//
//  Created by Akilesh Bapu on 2/27/17.
//  Copyright © 2017 org.iosdecal. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage


func addPost(client: Post) {
    let dbRef = Database.database().reference()
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.A"
    let dateString = dateFormatter.string(from: Date())
    
    let postDict: [String:AnyObject] = ["username": client.username as AnyObject,
                                        "date": dateString as AnyObject,
                                        "major": client.major as AnyObject,
                                        "gender": client.gender as AnyObject,
                                        "gender_pref": client.gender_pref as AnyObject,
                                        "major_pref": client.major_pref as AnyObject,
                                        "profile_image_url": client.profile_image_url as AnyObject,
                                        "start_lat": client.start_lat as AnyObject,
                                        "dest_lat": client.dest_lat as AnyObject,
                                        "start_lon": client.start_lon as AnyObject,
                                        "dest_lon": client.dest_lon as AnyObject,
                                        "affiliation": client.affiliation as AnyObject]
    
    print("inside addPost")
    print("postDict")
    dbRef.child(firPostsNode).child(client.username).setValue(postDict)
    
}


func addMatch(client1: Post, client2: Post, chatId:String) {
    let dbRef = Database.database().reference()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.A"
    let dateString = dateFormatter.string(from: Date())
    
    print("adding match for "+client1.username)
    
    let postDict: [String:AnyObject] = ["username": client2.username as AnyObject,
                                        "date": dateString as AnyObject,
                                        "major": client2.major as AnyObject,
                                        "gender": client2.gender as AnyObject,
                                        "gender_pref":client2.gender_pref as AnyObject,
                                        "major_pref":client2.major_pref as AnyObject,
                                        "profile_image_url":client2.profile_image_url as AnyObject,
                                        "start_lat": client2.start_lat as AnyObject,
                                        "dest_lat": client2.dest_lat as AnyObject,
                                        "start_lon": client2.start_lon as AnyObject,
                                        "dest_lon": client2.dest_lon as AnyObject,
                                        "chat_id": chatId as AnyObject,
                                        "affiliation": client2.affiliation as AnyObject]
    
    dbRef.child(firMatchNode).child(client1.username).setValue(postDict)
    //dbRef.child("Match").child(client1.username).setValue(postDict)
    //dbRef.child("Matching2").child("\(client1.username)").setValue(postDict)
    
    print(postDict)
}

func getPosts(completion: @escaping ([Post]?) -> Void) {
    let dbRef = Database.database().reference()
    var postArray: [Post] = []
    dbRef.child("Posts").observeSingleEvent(of: .value, with: { snapshot -> Void in
        if snapshot.exists() {
            if let posts = snapshot.value as? [String:AnyObject] {
                
                for postKey in posts.keys {
                    let postObject = posts[postKey]
                    var objectUserName = ""
                    var objectDate = ""
                    var objectGender = ""
                    var objectMajor = ""
                    var objectGenderPref = ""
                    var objectMajorPref = ""
                    var objectProfileImageUrl = ""
                    var objectAffiliation = ""
                    var objectStartLat = 0.0
                    var objectDestLat = 0.0
                    var objectStartLon = 0.0
                    var objectDestLon = 0.0
                    
                    objectUserName = postObject!.value(forKey: "username") as! String
                    objectDate = postObject!.value(forKey: "date") as! String
                    objectGender = postObject!.value(forKey: "gender") as! String
                    objectMajor = postObject!.value(forKey: "major") as! String
                    objectMajorPref = postObject!.value(forKey: "major_pref") as! String
                    objectGenderPref = postObject!.value(forKey: "gender_pref") as! String
                    objectProfileImageUrl = postObject!.value(forKey: "profile_image_url") as! String
                    objectStartLat = postObject!.value(forKey: "start_lat") as! Double
                    objectDestLat = postObject!.value(forKey: "dest_lat") as! Double
                    objectStartLon = postObject!.value(forKey: "start_lon") as! Double
                    objectDestLon = postObject!.value(forKey: "dest_lon") as! Double
                    objectAffiliation = postObject!.value(forKey: "affiliation") as! String
                    //??maybe figure out a way to build profile when waiting for Andy
                    print("before pp    ")
                    let pp = Post(username: objectUserName, dateString: objectDate, gender: objectGender, major: objectMajor, major_pref: objectMajorPref, gender_pref: objectGenderPref, profile_image_url: objectProfileImageUrl,affiliation: objectAffiliation,  start_lat:objectStartLat, dest_lat:objectDestLat, start_lon:objectStartLon, dest_lon:objectDestLon)
                    print(pp)
                    //this is sucessful
                    postArray.append(pp)
                }
                completion(postArray)
            } else {
                print("No Data Available Fount in Posts")
                completion(nil)
            }
        } else {
            print("SnapShot Does not Exist: ", snapshot)
            completion(nil)
        }
    })
}
func deletePost(username: String) {
    let dbRef = Database.database().reference()
    dbRef.child("Posts").child(username).setValue(nil)
}
func deleteMatch(username: String) {
    let dbRef = Database.database().reference()
    print("----------------------------------------------")
    dbRef.child(firMatchNode).child(username).setValue(nil)
}
func getMatches(client1Name: String, completion: @escaping ([Post]?) -> Void) {
    // this should return a Post array, containing one post obejct, which is client 2
    let dbRef = Database.database().reference()
    var postArray: [Post] = []
    dbRef.child(firMatchNode).observeSingleEvent(of: .value, with: { snapshot -> Void in
        
        if snapshot.exists() {
            if let posts = snapshot.value as? [String:AnyObject] {
                print("posts")
                
                for postKey in posts.keys {
                    let postObject = posts[postKey]
                    var objectUserName = ""
                    var objectDate = ""
                    var objectGender = ""
                    var objectMajor = ""
                    var objectGenderPref = ""
                    var objectMajorPref = ""
                    var objectProfileImageUrl = ""
                    var objectChatId = ""
                    var objectAffiliation = ""
                    var objectStartLat = 0.0
                    var objectDestLat = 0.0
                    var objectStartLon = 0.0
                    var objectDestLon = 0.0
                    
                    
                    objectUserName = postObject!.value(forKey: "username") as! String
                    objectDate = postObject!.value(forKey: "date") as! String
                    objectGender = postObject!.value(forKey: "gender") as! String
                    objectMajor = postObject!.value(forKey: "major") as! String
                    objectMajorPref = postObject!.value(forKey: "major_pref") as! String
                    objectGenderPref = postObject!.value(forKey: "gender_pref") as! String
                    objectProfileImageUrl = postObject!.value(forKey: "profile_image_url") as! String
                    objectAffiliation = postObject!.value(forKey: "affiliation") as! String
                    objectStartLat = postObject!.value(forKey: "start_lat") as! Double
                    objectDestLat = postObject!.value(forKey: "dest_lat") as! Double
                    objectStartLon = postObject!.value(forKey: "start_lon") as! Double
                    objectDestLon = postObject!.value(forKey: "dest_lon") as! Double
                    objectChatId = postObject!.value(forKey: "chat_id") as! String
                    
                    //??maybe figure out a way to build profile when waiting for Andy
                    let pp = Post(username: objectUserName, dateString: objectDate, gender: objectGender, major: objectMajor, major_pref: objectMajorPref, gender_pref: objectGenderPref, profile_image_url: objectProfileImageUrl,affiliation:objectAffiliation, start_lat:objectStartLat, dest_lat:objectDestLat, start_lon:objectStartLon, dest_lon:objectDestLon)
                    pp.chat_id = objectChatId
                    
                    print(client1Name, pp.username)
                    // Help!! I don't know how to get the post on branch
                    if (client1Name == postKey) {
                        postArray.append(pp)
                        print("client2:")
                        print("client1")
                        print(client1Name)
                        deleteMatch(username: client1Name)
                    }
                }
                completion(postArray)
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
    })
}


//
//func getPostFromIndexPath(indexPath: IndexPath) -> Post? {
//    let sectionName = threadNames[indexPath.section]
//    if let postsArray = threads[sectionName] {
//        return postsArray[indexPath.row]
//    }
//    print("No post at index \(indexPath.row)")
//    return nil
//}

/// Adds the given post to the thread associated with it
/// (the thread is set as an instance variable of the post)
///
/// - Parameter post: The post to be added to the model
//func addPostToThread(post: Post) {
//    threads[post.thread]?.append(post)
//}

//func clearThreads() {
//    threads = ["Memes": [], "Dog Spots": [], "Random": []]
//}

/*
 TODO:
 
 Store the data for a new post in the Firebase database.
 Make sure you understand the hierarchy of the Posts tree before attempting to write any data to Firebase!
 Each post node contains the following properties:
 
 - (string) imagePath: corresponds to the location of the image in the storage module. This is already defined for you below.
 - (string) thread: corresponds to which feed the image is to be posted to.
 - (string) username: corresponds to the display name of the current user who posted the image.
 - (string) date: the exact time at which the image is captured as a string
 Note: Firebase doesn't allow us to store Date objects, so we have to represent the date as a string instead. You can do this by creating a DateFormatter object, setting its dateFormat (check Constants.swift for the correct date format!) and then calling dateFormatter.string(from: Date()).
 
 Create a dictionary with these four properties and store it as a new child under the Posts node (you'll need to create a child using an auto ID)
 
 Finally, save the actual data to the storage module by calling the store function below.
 
 Remember, DO NOT USE ACTUAL STRING VALUES WHEN REFERENCING A PATH! YOU SHOULD ONLY USE THE CONSTANTS DEFINED IN STRINGS.SWIFT
 
 */
func addPost_scratch(username: String, comment: String) {
    // Uncomment the lines beneath this one if you've already connected Firebase:
    let dbRef = Database.database().reference()
    //    let data = UIImageJPEGRepresentation(postImage, 1.0)
    //    let path = "Images/\(UUID().uuidString)"
    //
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.A"
    let dateString = dateFormatter.string(from: Date())
    
    let postDict: [String:AnyObject] = ["username": username as AnyObject,
                                        "comment": comment as AnyObject,
                                        "date": dateString as AnyObject]
    // YOUR CODE HERE
    //    dbRef.child("Users/\(user.uid)").setValue(postDict)
    //
    //    child("Users").child(id!).child(firReadPostsNode).childByAutoId().setValue(postID, forKey: "postId")
    dbRef.child(firPostsNode).childByAutoId().setValue(postDict)
}


/*
 TODO:
 
 This function should query Firebase for all posts and return an array of Post objects.
 You should use the function 'observeSingleEvent' (with the 'of' parameter set to .value) to get a snapshot of all of the nodes under "Posts".
 If the snapshot exists, store its value as a dictionary of type [String:AnyObject], where the string key corresponds to the ID of each post.
 
 Then, make a query for the user's read posts ID's. In the completion handler, complete the following:
 - Iterate through each of the keys in the dictionary
 - For each key:
 
 
 - Create a new Post object, where Posts take in a key, username, imagepath, thread, date string, and read property. For the read property, you should set it to true if the key is contained in the user's read posts ID's and false otherwise.
 - Append the new post object to the post array.
 - Finally, call completion(postArray) to return all of the posts.
 - If any part of the function fails at any point (e.g. snapshot does not exist or snapshot.value is nil), call completion(nil).
 
 Remember to use constants defined in Strings.swift to refer to the correct path!
 */
//func getPosts_scratch(comment: String, completion: @escaping ([Post]?) -> Void) {
//    let dbRef = Database.database().reference()
//    var postArray: [Post] = []
//    dbRef.child("Posts").observeSingleEvent(of: .value, with: { snapshot -> Void in
//        if snapshot.exists() {
//            if let posts = snapshot.value as? [String:AnyObject] {
//
//                    for postKey in posts.keys {
//                        // COMPLETE THE CODE HERE
//                        let postObject = posts[postKey]
//                        var objectUserName = ""
//                        var objectComment = ""
//                        var objectDate = ""
//
//                        objectUserName = postObject!.value(forKey: "username") as! String
//                        objectComment = postObject!.value(forKey: "comment") as! String
//                        objectDate = postObject!.value(forKey: "date") as! String
//
//                        let pp = Post(username: objectUserName, dateString: objectDate, comments: objectComment)
//                        if pp.comment == comment {
//                            postArray.append(pp)
//                        }
//                    }
//                completion(postArray)
//            } else {
//                completion(nil)
//            }
//        } else {
//            completion(nil)
//        }
//    })
//
//}


