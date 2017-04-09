//
//  UserApi.swift
//  SeshhOfficial
//
//  Created by User on 08/04/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import Foundation
import Firebase

class UserApi {
    
    var REF_USERS = FIRDatabase.database().reference().child("users")
    
    func observeUser(withId uid: String, completion: @escaping (User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict)
                completion(user)
            }
        })
    }
}
