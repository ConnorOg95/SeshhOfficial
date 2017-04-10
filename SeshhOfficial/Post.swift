//
//  Post.swift
//  SeshhOfficial
//
//  Created by User on 12/03/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import Foundation
import FirebaseAuth

class Post {
    
    var title: String?
    var photoUrl: String?
    var uid: String?
    var id: String?
    var likeCount: Int?
    var likes: Dictionary<String, Any>?
    var isLiked: Bool?
}

extension Post {
    
    static func transformPost(dict: [String: Any], key: String) -> Post {
        let post = Post()
        
        post.id = key
        post.title = dict["title"] as? String
        post.photoUrl = dict["photoUrl"] as? String
        post.uid = dict["uid"] as? String
        post.likeCount = dict["likeCount"] as? Int
        post.likes = dict["likes"] as? Dictionary<String, Any>
        if let currentUserId = FIRAuth.auth()?.currentUser?.uid {
            if post.likes != nil{
                post.isLiked = post.likes![currentUserId] != nil
            }
        }
        return post
        
    }
    
}
