//
//  Message.swift
//  corkbored
//
//  Created by Jackson Meyer on 3/22/18.
//  Copyright © 2018 Jackson Meyer. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

class Message {
    var ownerUid: String
    var pinnedTimeAsInterval: String
    var postMessage: String
    
    init(ownerUid: String, pinnedTimeAsInterval: String, postMessage: String) {
        
        self.ownerUid = ownerUid
        self.pinnedTimeAsInterval = pinnedTimeAsInterval
        self.postMessage = postMessage
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as? NSDictionary
        
        self.ownerUid = snapshotValue!["ownerUid"] as! String
        self.pinnedTimeAsInterval = snapshotValue!["pinnedTimeAsInterval"] as! String
        self.postMessage = snapshotValue!["postMessage"] as! String
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return ["ownerUid": ownerUid as AnyObject, "pinnedTimeAsInterval": pinnedTimeAsInterval as AnyObject, "postMessage": postMessage as AnyObject]
    }
}
