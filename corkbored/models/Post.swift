//
//  Post.swift
//  corkbored
//
//  Created by Jackson Meyer on 12/14/17.
//  Copyright © 2017 Jackson Meyer. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

class Post {
    var postOwnerUid: String!
    var message: String!
    var backgroundColor: String!
    var date: String!
    
    init(postOwnerUid: String, message: String, backgroundColor: String, date: String) {
        self.postOwnerUid = postOwnerUid
        self.message = message
        self.backgroundColor = backgroundColor
        self.date = date
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as? NSDictionary
        
        self.postOwnerUid = snapshotValue!["postOwnerUid"] as! String
        self.message = snapshotValue!["message"] as! String
        self.backgroundColor = snapshotValue!["backgroundColor"] as! String
        self.date = snapshotValue!["date"] as! String
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return ["postOwnerUid": postOwnerUid as AnyObject, "message": message as AnyObject, "backgroundColor": backgroundColor as AnyObject, "date": date as AnyObject]
    }
}

