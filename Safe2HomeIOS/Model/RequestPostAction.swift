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


//var ref: DatabaseReference!
//
//ref = Database.database().reference()


//class MyDatabase {
//    var ref: DatabaseReference!
//
//}



//var threads: [String: [Post]] = ["Memes": [], "Dog Spots": [], "Random": []]
//
//
//let threadNames = ["Memes", "Dog Spots", "Random"]
//
//var allImages: [UIImage] = [#imageLiteral(resourceName: "cutePuppy"), #imageLiteral(resourceName: "berkAtNight"), #imageLiteral(resourceName: "meme1"), #imageLiteral(resourceName: "Campanile"), #imageLiteral(resourceName: "meme2"), #imageLiteral(resourceName: "dankMeme2"), #imageLiteral(resourceName: "amazingCutePuppy"), #imageLiteral(resourceName: "cutePuppy"), #imageLiteral(resourceName: "dirks"), #imageLiteral(resourceName: "dankMeme3")]
//
//
//func getPostFromIndexPath(indexPath: IndexPath) -> Post? {
//    let sectionName = threadNames[indexPath.section]
//    if let postsArray = threads[sectionName] {
//        return postsArray[indexPath.row]
//    }
//    print("No post at index \(indexPath.row)")
//    return nil
//}
//
///// Adds the given post to the thread associated with it
///// (the thread is set as an instance variable of the post)
/////
///// - Parameter post: The post to be added to the model
//func addPostToThread(post: Post) {
//    threads[post.thread]?.append(post)
//}
//
//func clearThreads() {
//    threads = ["Memes": [], "Dog Spots": [], "Random": []]
//}
//
///*
// TODO:
//
// Store the data for a new post in the Firebase database.
// Make sure you understand the hierarchy of the Posts tree before attempting to write any data to Firebase!
// Each post node contains the following properties:
//
// - (string) imagePath: corresponds to the location of the image in the storage module. This is already defined for you below.
// - (string) thread: corresponds to which feed the image is to be posted to.
// - (string) username: corresponds to the display name of the current user who posted the image.
// - (string) date: the exact time at which the image is captured as a string
// Note: Firebase doesn't allow us to store Date objects, so we have to represent the date as a string instead. You can do this by creating a DateFormatter object, setting its dateFormat (check Constants.swift for the correct date format!) and then calling dateFormatter.string(from: Date()).
//
// Create a dictionary with these four properties and store it as a new child under the Posts node (you'll need to create a child using an auto ID)
//
// Finally, save the actual data to the storage module by calling the store function below.
//
// Remember, DO NOT USE ACTUAL STRING VALUES WHEN REFERENCING A PATH! YOU SHOULD ONLY USE THE CONSTANTS DEFINED IN STRINGS.SWIFT
//
// */
//func addPost(postImage: UIImage, thread: String, username: String) {
//    // Uncomment the lines beneath this one if you've already connected Firebase:
//    let dbRef = Database.database().reference()
//    let data = UIImageJPEGRepresentation(postImage, 1.0)
//    let path = "Images/\(UUID().uuidString)"
//
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.A"
//    let dateString = dateFormatter.string(from: Date())
//    let postDict: [String:AnyObject] = ["imagePath": path as AnyObject,
//                                        "username": username as AnyObject,
//                                        "thread": thread as AnyObject,
//                                        "date": dateString as AnyObject]
//    // YOUR CODE HERE
////    dbRef.child("Users/\(user.uid)").setValue(postDict)
////
////    child("Users").child(id!).child(firReadPostsNode).childByAutoId().setValue(postID, forKey: "postId")
//
//    // actually I don't know what this firPostsNode is ??
//    dbRef.child(firPostsNode).childByAutoId().setValue(postDict)
//    //print("Post success.")
//    store(data: data, toPath: path)
//}
//
//
//// TODO:
//// Uncomment the lines inside this function. This is the function that actually sends
//// your data to Firebase's Storage to store it using the given 'path' as it's
//// reference.
////
//func store(data: Data?, toPath path: String) {
//    let storageRef = Storage.storage().reference()
//    storageRef.child(path).putData(data!, metadata: nil) { (metadata, error) in
//        if let error = error {
//            print(error)
//        }
//    }
//}
//
//
//
//
///*
// TODO:
//
// This function should query Firebase for all posts and return an array of Post objects.
// You should use the function 'observeSingleEvent' (with the 'of' parameter set to .value) to get a snapshot of all of the nodes under "Posts".
// If the snapshot exists, store its value as a dictionary of type [String:AnyObject], where the string key corresponds to the ID of each post.
//
// Then, make a query for the user's read posts ID's. In the completion handler, complete the following:
// - Iterate through each of the keys in the dictionary
// - For each key:
//
//
// - Create a new Post object, where Posts take in a key, username, imagepath, thread, date string, and read property. For the read property, you should set it to true if the key is contained in the user's read posts ID's and false otherwise.
// - Append the new post object to the post array.
// - Finally, call completion(postArray) to return all of the posts.
// - If any part of the function fails at any point (e.g. snapshot does not exist or snapshot.value is nil), call completion(nil).
//
// Remember to use constants defined in Strings.swift to refer to the correct path!
// */
//func getPosts(user: CurrentUser, completion: @escaping ([Post]?) -> Void) {
//    let dbRef = Database.database().reference()
//    var postArray: [Post] = []
//    dbRef.child("Posts").observeSingleEvent(of: .value, with: { snapshot -> Void in
//        if snapshot.exists() {
//            if let posts = snapshot.value as? [String:AnyObject] {
//                user.getReadPostIDs(completion: { (ids) in
//                    for postKey in posts.keys {
//                        // COMPLETE THE CODE HERE
//                        let postObject = posts[postKey]
//                        var objectUser = ""
//                        var objectImage = ""
//                        var objectThread = ""
//                        var objectDate = ""
//
//                        objectUser = postObject!.value(forKey: firUsernameNode) as! String
//                        objectImage = postObject!.value(forKey: firImagePathNode) as! String
//                        objectThread = postObject!.value(forKey: firThreadNode) as! String
//                        objectDate = postObject!.value(forKey: firDateNode) as! String
//
//                        let if_read = ids.contains(postKey)
//
//                        let pp = Post(id: postKey, username: objectUser, postImagePath: objectImage, thread: objectThread, dateString: objectDate, read: if_read)
//                        postArray.append(pp)
//
//                    }
//                    completion(postArray)
//                })
//            } else {
//                completion(nil)
//            }
//        } else {
//            completion(nil)
//        }
//    })
//
//}
//
//// TODO:
//// Uncomment the lines in the function when you reach the appriopriate par in the README.
//func getDataFromPath(path: String, completion: @escaping (Data?) -> Void) {
//    let storageRef = Storage.storage().reference()
//    storageRef.child(path).getData(maxSize: 5 * 1024 * 1024) { (data, error) in
//        if let error = error {
//            print(error)
//        }
//        if let data = data {
//            completion(data)
//        } else {
//            completion(nil)
//        }
//    }
//}
//
