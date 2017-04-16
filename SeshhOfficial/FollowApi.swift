//
//  FollowApi.swift
//  SeshhOfficial
//
//  Created by User on 16/04/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FollowApi  {
    
    var REF_FOLLOWERS = FIRDatabase.database().reference().child("followers")
    var REF_FOLLOWING = FIRDatabase.database().reference().child("following")
    
    func followAction(withUser id: String) {
        REF_FOLLOWERS.child(id).child(Api.user.CURRENT_USER!.uid).setValue(true)
        REF_FOLLOWING.child(Api.user.CURRENT_USER!.uid).child(id).setValue(true)
    }
    
    func unFollowAction(withUser id: String) {
        REF_FOLLOWERS.child(id).child(Api.user.CURRENT_USER!.uid).setValue(NSNull())
        REF_FOLLOWING.child(Api.user.CURRENT_USER!.uid).child(id).setValue(NSNull())
    }
    
    func isFollowing(userId: String, completed: @escaping (Bool) -> Void) {
        REF_FOLLOWERS.child(userId).child(Api.user.CURRENT_USER!.uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let _ = snapshot.value as? NSNull {
                completed(false)
            } else {
                completed(true)
            }
        })
    }
}
