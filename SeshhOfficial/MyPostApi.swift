//
//  MyPostApi.swift
//  SeshhOfficial
//
//  Created by User on 12/04/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import Foundation
import FirebaseDatabase

class MyPostApi {
    
    var REF_MYPOSTS = FIRDatabase.database().reference().child("myPosts")
}
