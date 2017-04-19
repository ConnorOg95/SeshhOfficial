//
//  HelpService.swift
//  SeshhOfficial
//
//  Created by User on 12/04/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import Foundation
import FirebaseStorage

class HelpService {
    
    static func uploadDataToServer(data: Data, title: String, onSuccess: @escaping () -> Void) {
        let photoIdString = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("seshhPostImgs").child(photoIdString)
        storageRef.put(data, metadata: nil) { (metadata, error) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            let photoUrl = metadata?.downloadURL()?.absoluteString
            self.sendDataToDatabase(photoUrl: photoUrl!, title: title, onSuccess: onSuccess)
        }
    }
    
    static func sendDataToDatabase(photoUrl: String, title: String, onSuccess: @escaping () -> Void) {
        let newPostId = Api.post.REF_POSTS.childByAutoId().key
        let newPostReference = Api.post.REF_POSTS.child(newPostId)
        
        guard let currentUser = Api.user.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        newPostReference.setValue(["uid": currentUserId, "photoUrl": photoUrl, "title": title], withCompletionBlock: {
            (error, ref) in
            if error != nil {
                return
            }
            
            Api.feed.REF_FEED.child(Api.user.CURRENT_USER!.uid).child(newPostId).setValue(true)
            
            let myPostRef = Api.myPosts.REF_MYPOSTS.child(currentUserId).child(newPostId)
            myPostRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
            })
            
            ProgressHUD.showSuccess("Success")
            onSuccess()
        })
    }
    
}
