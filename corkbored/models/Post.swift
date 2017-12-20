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
    var pinnedMediaFileName: String
    
    init(pinnedTimeAsInterval: String, ownerUid: String, postMessage: String, pinnedMediaFileName: String) {
        self.pinnedTimeAsInterval = pinnedTimeAsInterval
        self.ownerUid = ownerUid
        self.postMessage = postMessage
        self.pinnedMediaFileName = pinnedMediaFileName
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as? NSDictionary
        
        self.pinnedTimeAsInterval = snapshotValue!["pinnedTimeAsInterval"] as! String
        self.ownerUid = snapshotValue!["ownerUid"] as! String
        self.postMessage = snapshotValue!["postMessage"] as! String
        self.pinnedMediaFileName = snapshotValue!["pinnedMediaFileName"] as! String
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return ["pinnedTimeAsInterval": pinnedTimeAsInterval as AnyObject, "ownerUid": ownerUid as AnyObject, "postMessage": postMessage as AnyObject, "pinnedMediaFileName": pinnedMediaFileName as AnyObject]
    }
}

