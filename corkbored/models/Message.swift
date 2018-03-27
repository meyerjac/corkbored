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
    var userOneUid: String
    var userTwoUid: String
    var pinnedTimeAsInterval: String
    var postMessage: String
    
    init(userOneUid: String, userTwoUid: String, pinnedTimeAsInterval: String, postMessage: String) {
        
        self.userOneUid = userOneUid
        self.userTwoUid = userTwoUid
        self.pinnedTimeAsInterval = pinnedTimeAsInterval
        self.postMessage = postMessage
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as? NSDictionary
        
        self.userOneUid = snapshotValue!["userOneUid"] as! String
        self.userTwoUid = snapshotValue!["userTwoUid"] as! String
        self.pinnedTimeAsInterval = snapshotValue!["pinnedTimeAsInterval"] as! String
        self.postMessage = snapshotValue!["postMessage"] as! String
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return ["userOneUid": userOneUid as AnyObject, "userTwoUid": userTwoUid as AnyObject, "pinnedTimeAsInterval": pinnedTimeAsInterval as AnyObject, "postMessage": postMessage as AnyObject]
    }
}
