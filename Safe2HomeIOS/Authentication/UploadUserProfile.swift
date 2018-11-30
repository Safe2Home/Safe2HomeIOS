//
//  UploadUserProfile.swift
//  Safe2HomeIOS
//
//  Created by Cong Jin on 11/23/18.
//  Copyright © 2018 Safe2Home. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth


func createProfile(client: CurrentUser) {
    let dbRef = Database.database().reference()
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.A"
    _ = dateFormatter.string(from: Date())
    
    let postDict: [String:AnyObject] = ["uid": client.id as AnyObject,
                                        "Email": client.email as AnyObject,
                                        "Username": client.username as AnyObject,
                                        "Gender": client.gender as AnyObject,
                                        "Major": client.major as AnyObject,
                                        "Preferred_Gender": client.gender_pref as AnyObject,
                                        "Preferred_Major": client.major_pref as AnyObject,
                                        "Emergency_Phone_Number": client.emerg_phone as AnyObject,
                                        "profile_image_url": client.profile_image_url as AnyObject]
    
    print("createProfile")
    print("postDict")
    dbRef.child("Users").child(client.id).setValue(postDict)
    
}

func getProfile(uid: String, completion: @escaping (CurrentUser?) -> Void) {
    let dbRef = Database.database().reference()
    _ = Auth.auth().currentUser
    var user : CurrentUser = CurrentUser(id: "nil", email: "nil")
    var result : CurrentUser = CurrentUser(id: "nil", email: "nil")
    
    dbRef.child("Users").observeSingleEvent(of: .value, with: { snapshot -> Void in
        if snapshot.exists() {
            if let users = snapshot.value as? [String:AnyObject] {
                
                for userkey in users.keys {
                    let profileObject = users[userkey]
                    var objectuid = ""
                    var objectEmail = ""
                    var objectUserName = ""
                    var objectGender = ""
                    var objectMajor = ""
                    var objectPreferredGender = ""
                    var objectPreferredMajor = ""
                    var objectEmergencyPhone = ""
                    var objectImageURL = ""
                    
                    objectuid = profileObject!.value(forKey: "uid") as! String
                    
                    objectEmail = profileObject!.value(forKey: "Email") as! String
                    
                    objectUserName = profileObject!.value(forKey: "Username") as! String
                    
                    objectGender = profileObject!.value(forKey: "Gender") as! String
                    
                    objectMajor = profileObject!.value(forKey: "Major") as! String
                    
                    objectPreferredGender = profileObject!.value(forKey: "Preferred_Gender") as! String
                    
                    objectPreferredMajor = profileObject!.value(forKey: "Preferred_Major") as! String
                    
                    objectEmergencyPhone = profileObject!.value(forKey: "Emergency_Phone_Number") as! String
                    
                    objectImageURL = profileObject!.value(forKey: "profile_image_url") as! String
                    
                    
                    
                    //??maybe figure out a way to build profile when waiting for Andy
                    print("before pp    ")
                    user = CurrentUser(id: objectuid, email: objectEmail)
                    
                    user.username = objectUserName
                    user.gender = objectGender
                    user.major = objectMajor
                    user.major_pref = objectPreferredMajor
                    user.gender_pref = objectPreferredGender
                    user.emerg_phone = objectEmergencyPhone
                    user.profile_image_url = objectImageURL
                    
                    
                    if (uid == user.id) {
                        result = user
                        print(result.id)
                    }
                    //this is sucessful
                    
                }
                print(result.id)
                completion(result)
            } else {
                completion(nil)
            }
        } else {
            completion(nil)
        }
    })
}


