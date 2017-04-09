//
//  CommentApi.swift
//  SeshhOfficial
//
//  Created by User on 09/04/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CommentApi {
    
    var REF_COMMENTS = FIRDatabase.database().reference().child("comments")
    
    
    func observeComments(withPostId id: String, completion: @escaping (Comment) -> Void) {
        REF_COMMENTS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let newComment = Comment.transformComment(dict: dict)
                completion(newComment)
            }
        })
    }
}
