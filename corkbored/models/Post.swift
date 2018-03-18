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
    var pinnedTimeAsInterval: String
    var ownerUid: String
    var postMessage: String
    var postUid: String
    var pinnedMediaFileName: String
    var numberOfComments: String
    var likes: Array<Any>?
    var comments: Array<Comment>?
    
    
    init(pinnedTimeAsInterval: String, ownerUid: String, postMessage: String, postUid: String, pinnedMediaFileName: String, likes: Array<Any>?, comments: Array<Comment>?, numberOfComments: String) {
        
        self.pinnedTimeAsInterval = pinnedTimeAsInterval
        self.ownerUid = ownerUid
        self.postMessage = postMessage
        self.postUid = postUid
        self.pinnedMediaFileName = pinnedMediaFileName
        self.likes = likes
        self.comments = comments
        self.numberOfComments = numberOfComments
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as? NSDictionary
        
        self.pinnedTimeAsInterval = snapshotValue!["pinnedTimeAsInterval"] as! String
        self.ownerUid = snapshotValue!["ownerUid"] as! String
        self.postMessage = snapshotValue!["postMessage"] as! String
        self.postUid = snapshotValue!["postUid"] as! String
        self.pinnedMediaFileName = snapshotValue!["pinnedMediaFileName"] as! String
        self.likes = snapshotValue!["likes"] as? Array
        self.comments = snapshotValue!["comments"] as? Array
        self.numberOfComments = snapshotValue!["numberOfComments"] as! String
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return ["pinnedTimeAsInterval": pinnedTimeAsInterval as AnyObject, "ownerUid": ownerUid as AnyObject, "postMessage": postMessage as AnyObject, "postUid": postUid as AnyObject, "pinnedMediaFileName": pinnedMediaFileName as AnyObject, "likes": likes as AnyObject, "comments": comments as AnyObject, "numberOfComments": numberOfComments as AnyObject]
    }
}

