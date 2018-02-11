//
//  Comment.swift
//  corkbored
//
//  Created by Jackson Meyer on 2/10/18.
//  Copyright © 2018 Jackson Meyer. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

class Comment {
    var pinnedTimeAsInterval: String
    var ownerUid: String
    var commentMessage: String
    var postUid: String
    
    init(pinnedTimeAsInterval: String, ownerUid: String, commentMessage: String, postUid: String) {
        self.pinnedTimeAsInterval = pinnedTimeAsInterval
        self.ownerUid = ownerUid
        self.commentMessage = commentMessage
        self.postUid = postUid
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as? NSDictionary
        
        self.pinnedTimeAsInterval = snapshotValue!["pinnedTimeAsInterval"] as! String
        self.ownerUid = snapshotValue!["ownerUid"] as! String
        self.commentMessage = snapshotValue!["postMessage"] as! String
        self.postUid = snapshotValue!["postUid"] as! String
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return ["pinnedTimeAsInterval": pinnedTimeAsInterval as AnyObject, "ownerUid": ownerUid as AnyObject, "commentMessage": commentMessage as AnyObject, "postUid": postUid as AnyObject]
    }
}
