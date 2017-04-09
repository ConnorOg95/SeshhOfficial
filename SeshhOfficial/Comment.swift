//
//  Comment.swift
//  SeshhOfficial
//
//  Created by User on 09/04/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import Foundation
class Comment {
    
    var commentTxt: String?
    var uid: String?
}

extension Comment {
    
    static func transformComment(dict: [String: Any]) -> Comment {
        let comment = Comment()
        
        comment.commentTxt = dict["commentTxt"] as? String
        comment.uid = dict["uid"] as? String
        return comment
        
    }
    
}
