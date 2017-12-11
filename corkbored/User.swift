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
    var profilePics: Array<String>!
    var age: String!
    
    init(name: String, username: String, currentCity: String, profilePics: Array<String>, age: String) {
        self.name = name
        self.username = username
        self.currentCity = currentCity
        self.profilePics = profilePics
        self.age = age
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as? NSDictionary
        
        self.name = snapshotValue!["name"] as! String
        self.username = snapshotValue!["username"] as! String
        self.currentCity = snapshotValue!["currentCity"] as! String
        self.profilePics = snapshotValue!["profilePics"] as! Array
        self.age = snapshotValue!["age"] as! String
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return ["name": name as AnyObject, "username": username as AnyObject, "currentCity": currentCity as AnyObject, "age": age as AnyObject]
    }
    
    
}
