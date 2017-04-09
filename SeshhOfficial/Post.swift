//
//  Post.swift
//  SeshhOfficial
//
//  Created by User on 12/03/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import Foundation
class Post {
    
    var title: String?
    var photoUrl: String?
    var uid: String?
    var id: String?
}

extension Post {
    
    static func transformPost(dict: [String: Any], key: String) -> Post {
        let post = Post()
        
        post.id = key
        post.title = dict["title"] as? String
        post.photoUrl = dict["photoUrl"] as? String
        post.uid = dict["uid"] as? String
        return post
        
    }
    
}
