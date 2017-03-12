//
//  Post.swift
//  SeshhOfficial
//
//  Created by User on 12/03/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import Foundation
class Post {
    
    var caption: String?
    var photoUrl: String?
}

extension Post {
    
    static func transformPost(dict: [String: Any]) -> Post {
        let post = Post()
        
        post.caption = dict["caption"] as? String
        post.photoUrl = dict["photoUrl"] as? String
        return post
        
    }
    
}
