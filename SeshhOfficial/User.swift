//
//  User.swift
//  SeshhOfficial
//
//  Created by User on 15/03/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import Foundation

class User {
    
    var email: String?
    var profileImgUrl: String?
    var username: String?
}

extension User {
    
    static func transformUser(dict: [String: Any]) -> User {
        let user = User()
        user.email = dict["email"] as? String
        user.profileImgUrl = dict["profileImgURL"] as? String
        user.username = dict["username"] as? String
        return user
    }
    
}
