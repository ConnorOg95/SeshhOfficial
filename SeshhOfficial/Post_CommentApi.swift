//
//  Post_CommentApi.swift
//  SeshhOfficial
//
//  Created by User on 09/04/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Post_CommentApi {
    
    var REF_POST_COMMENTS = FIRDatabase.database().reference().child("post-comments")
    
    //func observePostComment(withPostId id: String)
    
//    func observePostComments(withPostId id: String, completion: @escaping (Comment) -> Void) {
//        REF_POST_COMMENTS.child(id).observeSingleEvent(of: .value, with: {
//            snapshot in
//            if let dict = snapshot.value as? [String: Any] {
//                let newComment = Comment.transformComment(dict: dict)
//                completion(newComment)
//            }
//        })
//    }
}
// THIS IS INCORRECT.
