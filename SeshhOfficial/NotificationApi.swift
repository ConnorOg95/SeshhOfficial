//
//  NotificationApi.swift
//  SeshhOfficial
//
//  Created by User on 23/06/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import Foundation
import FirebaseDatabase

class NotificationApi {
var REF_NOTIFICATION = FIRDatabase.database().reference().child("notification")
    
    func observeNotification(withId id: String, completion: @escaping (Notification) -> Void) {
        REF_NOTIFICATION.child(id).observe(.childAdded, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let newNotif = Notification.transform(dict: dict, key: snapshot.key)
                completion(newNotif)
            }
            
        })
    }


}
