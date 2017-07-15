//
//  Notification.swift
//  SeshhOfficial
//
//  Created by User on 23/06/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import Foundation
import FirebaseAuth

class Notification {
    
    var from: String?
    var objectId: String?
    var type: String?
    var timestamp: Int?
    var id: String?

}

extension Notification {
    
    static func transform(dict: [String: Any], key: String) -> Notification {
        let notification = Notification()
        
        notification.id = key
        notification.from = dict["from"] as? String
        notification.objectId = dict["objectId"] as? String
        notification.type = dict["type"] as? String
        notification.timestamp = dict["timestamp"] as? Int
        
        return notification
        
    }
    
}
