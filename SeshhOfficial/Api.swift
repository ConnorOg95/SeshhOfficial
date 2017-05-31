//
//  Api.swift
//  SeshhOfficial
//
//  Created by User on 09/04/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import Foundation

struct Api {
    
    static var user = UserApi()
    static var post = PostApi()
    static var comment = CommentApi()
    static var post_Comment = Post_CommentApi()
    static var myPosts = MyPostApi()
    static var Follow = FollowApi()
    static var feed = FeedApi()
    static var location = LocationApi()
    static var hashTag = HashTagApi()

}
