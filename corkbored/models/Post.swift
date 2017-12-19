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
    var pinnedTimeAsInterval: Int
    var ownerUid: String
    var type: String
    var sellItemDescription: String
    var sellPrice: Int
    var sellPhotoUrl: String
    var sellCondition: String
    var eventDateTime: String
    var eventLocation: String
    var eventDescription: String
    var postMessage: String
    var postBackgroundColor: String
    var pinnedMediaUrl: String
    
    init(pinnedTimeAsInterval: Int, ownerUid: String, type: String, sellItemDescription: String, sellPrice: Int, sellPhotoUrl: String, sellCondition: String, eventDateTime: String, eventLocation: String, eventDescription: String, postMessage: String, postBackgroundColor: String!, pinnedMediaUrl: String) {
        self.pinnedTimeAsInterval = pinnedTimeAsInterval
        self.ownerUid = ownerUid
        self.type = type
        self.sellItemDescription = sellItemDescription
        self.sellPrice = sellPrice
        self.sellPhotoUrl = sellPhotoUrl
        self.sellCondition = sellCondition
        self.eventDateTime = eventDateTime
        self.eventLocation = eventLocation
        self.eventDescription = eventDescription
        self.postMessage = postMessage
        self.postBackgroundColor = postBackgroundColor
        self.pinnedMediaUrl = pinnedMediaUrl
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as? NSDictionary
        
        self.pinnedTimeAsInterval = snapshotValue!["pinnedTimeAsInterval"] as! Int
        self.ownerUid = snapshotValue!["ownerUid"] as! String
        self.type = snapshotValue!["type"] as! String
        self.sellItemDescription = snapshotValue!["sellItemDescription"] as! String
        self.sellPrice = snapshotValue!["sellPrice"] as! Int
        self.sellPhotoUrl = snapshotValue!["sellPhotoUrl"] as! String
        self.sellCondition = snapshotValue!["sellCondition"] as! String
        self.eventDateTime = snapshotValue!["eventDateTime"] as! String
        self.eventLocation = snapshotValue!["eventLocation"] as! String
        self.eventDescription = snapshotValue!["eventDescription"] as! String
        self.postMessage = snapshotValue!["postMessage"] as! String
        self.postBackgroundColor = snapshotValue!["postBackgroundColor"] as! String
        self.pinnedMediaUrl = snapshotValue!["pinnedMediaUrl"] as! String
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return ["pinnedTimeAsInterval": pinnedTimeAsInterval as AnyObject, "ownerUid": ownerUid as AnyObject, "type": type as AnyObject, "sellItemDescription": sellItemDescription as AnyObject, "sellPrice": sellPrice as AnyObject, sellPhotoUrl: "SellPhotoUrl" as AnyObject, "sellPhotoUrl": sellPhotoUrl as AnyObject, "sellCondition": sellCondition as AnyObject, "eventDateTime": eventDateTime as AnyObject, "eventLocation": eventLocation as AnyObject, "eventDescription": eventDescription as AnyObject,  "postMessage": postMessage as AnyObject, "postBackgroundColor": postBackgroundColor as AnyObject, "pinnedMediaUrl": pinnedMediaUrl as AnyObject]
    }
}

