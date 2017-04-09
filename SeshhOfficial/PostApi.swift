//
//  PostApi.swift
//  SeshhOfficial
//
//  Created by User on 08/04/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import Foundation
import Firebase

class PostApi {
    
    var REF_POSTS = FIRDatabase.database().reference().child("seshhPosts")
    
    
    func observePosts(completion: @escaping (Post) -> Void) {
        REF_POSTS.observe(.childAdded) { (snapshot: FIRDataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let newPost = Post.transformPost(dict: dict, key: snapshot.key)
                completion(newPost)
            }
        }
    }
}
