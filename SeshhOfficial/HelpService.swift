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
    
    static func uploadDataToServer(data: Data, videoUrl: URL? = nil, ratio: CGFloat, title: String, onSuccess: @escaping () -> Void) {
        if let videoUrl = videoUrl {
            uploadVideoToFirebaseStorage(videoUrl: videoUrl, onSuccess: { (videoUrl) in
                uploadImgToFirebaseStorage(data: data, onSuccess: { (thumbnailImgUrl) in
                    sendDataToDatabase(photoUrl: thumbnailImgUrl, videoUrl: videoUrl, ratio: ratio, title: title, onSuccess: onSuccess)
                })
            })
        } else {
            uploadImgToFirebaseStorage(data: data) { (photoUrl) in
                self.sendDataToDatabase(photoUrl: photoUrl, ratio: ratio, title: title, onSuccess: onSuccess)
            }
        }
    }
    
    static func uploadVideoToFirebaseStorage(videoUrl: URL, onSuccess: @escaping (_ imageUrl: String) -> Void) {
        let videoIdString = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("seshhPostImgs").child(videoIdString)
        storageRef.putFile(videoUrl, metadata: nil) { (metadata, error) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            if let videoUrl = metadata?.downloadURL()?.absoluteString {
                onSuccess(videoUrl)
            }
        }
    }
    
    static func uploadImgToFirebaseStorage(data: Data, onSuccess: @escaping (_ imageUrl: String) -> Void) {
        let photoIdString = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("seshhPostImgs").child(photoIdString)
        storageRef.put(data, metadata: nil) { (metadata, error) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            if let photoUrl = metadata?.downloadURL()?.absoluteString {
                onSuccess(photoUrl)
            }

        }
    }
    
    static func sendDataToDatabase(photoUrl: String, videoUrl: String? = nil, ratio: CGFloat, title: String, onSuccess: @escaping () -> Void) {
        let newPostId = Api.post.REF_POSTS.childByAutoId().key
        let newPostReference = Api.post.REF_POSTS.child(newPostId)
        
        guard let currentUser = Api.user.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        var dict = ["uid": currentUserId, "photoUrl": photoUrl, "title": title, "likeCount": 0, "ratio": ratio] as [String: Any]
        if let videoUrl = videoUrl {
            dict["videoUrl"] = videoUrl
        }
        newPostReference.setValue(dict, withCompletionBlock: {
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
