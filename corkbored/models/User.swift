//
//  UserModel.swift
//  corkbored
//
//  Created by Jackson Meyer on 12/6/17.
//  Copyright © 2017 Jackson Meyer. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

class User {
    var acceptedTerms: Bool!
    var bio: String!
    var birthday: String!
    var currentCity: String!
    var currentState: String!
    var dms: Array<String>!
    var email: String!
    var facebookId: String!
    var firstName: String!
    var hashtags: Array<String>!
    var lastName: String!
    var posts: Array<String>!
    var profilePic: String!
    var replies: Array<String>!
   
    
    init(acceptedTerms: Bool, bio: String, birthday: String, currentCity: String, currentState: String, dms: Array<String>, email: String, facebookId: String, firstName: String, hashtags: Array<String>, lastName: String, posts: Array<String>, profilePic: String, replies: Array<String>) {
        self.acceptedTerms = acceptedTerms
        self.bio = bio
        self.birthday = birthday
        self.currentCity = currentCity
        self.currentState = currentState
        self.dms = dms
        self.email = email
        self.facebookId = facebookId
        self.firstName = firstName
        self.hashtags = hashtags
        self.lastName = lastName
        self.posts = posts
        self.profilePic = profilePic
        self.replies = replies
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as? NSDictionary
        
        self.acceptedTerms = snapshotValue!["acceptedTerms"] as! Bool
        self.bio = snapshotValue!["bio"] as! String
        self.birthday = snapshotValue!["birthday"] as! String
        self.currentCity = snapshotValue!["currentCity"] as! String
        self.currentState = snapshotValue!["currentState"] as! String
        self.dms = snapshotValue!["dms"] as! Array
        self.email = snapshotValue!["email"] as! String
        self.facebookId = snapshotValue!["facebookId"] as! String
        self.firstName = snapshotValue!["firstName"] as! String
        self.hashtags = snapshotValue!["hashtags"] as! Array
        self.lastName = snapshotValue!["lastName"] as! String
        self.posts = snapshotValue!["posts"] as! Array
        self.profilePic = snapshotValue!["profilePic"] as! String
        self.replies = snapshotValue!["replies"] as! Array
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return ["acceptedTerms": acceptedTerms as AnyObject, "bio": bio as AnyObject, "birthday": birthday as AnyObject, "currentCity": currentCity as AnyObject, "currentState": currentState as AnyObject, "dms": dms as AnyObject, "facebookId": facebookId as AnyObject, "firstName": firstName as AnyObject, "hashtags": hashtags as AnyObject, "lastName": lastName as AnyObject, "posts": posts as AnyObject, "profilePic": profilePic as AnyObject, "replies": replies as AnyObject]
    }
}
