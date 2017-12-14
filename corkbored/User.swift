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
    var name: String!
    var username: String!
    var currentCity: String!
    var profilePic: String!
    var posts: Array<String>!
    var birthday: String!
    var bio: String!
    
    init(name: String, username: String, currentCity: String, profilePic: String, posts: Array<String>, birthday: String, bio: String) {
        self.name = name
        self.username = username
        self.currentCity = currentCity
        self.profilePic = profilePic
        self.posts = posts
        self.birthday = birthday
        self.bio = bio
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as? NSDictionary
        
        self.name = snapshotValue!["name"] as! String
        self.username = snapshotValue!["username"] as! String
        self.currentCity = snapshotValue!["currentCity"] as! String
        self.profilePic = snapshotValue!["profilePic"] as! String
        self.posts = snapshotValue!["posts"] as! Array
        self.birthday = snapshotValue!["birthday"] as! String
        self.bio = snapshotValue!["bio"] as! String
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return ["name": name as AnyObject, "username": username as AnyObject, "currentCity": currentCity as AnyObject, "profilePic": profilePic as AnyObject, "posts": posts as AnyObject, "birthday": birthday as AnyObject, "bio": bio as AnyObject]
    }
}
