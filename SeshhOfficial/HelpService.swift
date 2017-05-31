//
//  HelpService.swift
//  SeshhOfficial
//
//  Created by User on 12/04/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import Foundation
import MapKit
import FirebaseStorage

class HelpService {
    
    static func uploadDataToServer(data: Data, videoUrl: URL? = nil, ratio: CGFloat, title: String, description: String, startDate: String, endDate: String, category: String, location: CLLocation, onSuccess: @escaping () -> Void) {
        if let videoUrl = videoUrl {
            uploadVideoToFirebaseStorage(videoUrl: videoUrl, onSuccess: { (videoUrl) in
                uploadImgToFirebaseStorage(data: data, onSuccess: { (thumbnailImgUrl) in
                    sendDataToDatabase(photoUrl: thumbnailImgUrl, videoUrl: videoUrl, ratio: ratio, title: title, description: description, startDate: startDate, endDate: endDate, category: category, location: location, onSuccess: onSuccess)
                })
            })
        } else {
            uploadImgToFirebaseStorage(data: data) { (photoUrl) in
                self.sendDataToDatabase(photoUrl: photoUrl, ratio: ratio, title: title, description: description, startDate: startDate, endDate: endDate, category: category, location: location, onSuccess: onSuccess)
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
        print("CONNOR: Image String - \(photoIdString)")
        storageRef.put(data, metadata: nil) { (metadata, error) in
            if error != nil {
                print("CONNOR: ERROR UPLOADING IMAGE \(error)")
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            if let photoUrl = metadata?.downloadURL()?.absoluteString {
                onSuccess(photoUrl)
            }
        }
    }
    
    static func uploadLocationToDatabase(location: CLLocation, postId: String) {
        
        var currentDate: String?
        let date = Date()
        let formatter = DateFormatter()
        
        func setCurrentDate() {
            formatter.dateFormat = "dd/MM/YYYY"
            currentDate = formatter.string(from: date)
        }
        setCurrentDate()
        print("CONNOR: CURRENT DATE - \(currentDate)")
        let geoFireRef = Api.location.REF_POST_LOCATIONS.child(currentDate!)
        let geoFire = GeoFire(firebaseRef: geoFireRef)
        geoFire?.setLocation(location, forKey: "\(postId)")

    }
    
    static func sendDataToDatabase(photoUrl: String, videoUrl: String? = nil, ratio: CGFloat, title: String, description: String, startDate: String, endDate: String, category: String, location: CLLocation, onSuccess: @escaping () -> Void) {
        let newPostId = Api.post.REF_POSTS.childByAutoId().key
        let newPostReference = Api.post.REF_POSTS.child(newPostId)
        
        guard let currentUser = Api.user.CURRENT_USER else {
            return
        }
        
        let words = title.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        
        for var word in words {
            if word.hasPrefix("#") {
                word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
                let newHashTagRef = Api.hashTag.REF_HASHTAG.child(word.lowercased())
                newHashTagRef.updateChildValues([newPostId: true])
            }
        }
        
        
        let currentUserId = currentUser.uid
        var dict = ["uid": currentUserId, "photoUrl": photoUrl, "title": title, "description": description, "startDate": startDate, "endDate": endDate, "category": category, "likeCount": 0, "ratio": ratio] as [String: Any]
        if let videoUrl = videoUrl {
            dict["videoUrl"] = videoUrl
        }
        newPostReference.setValue(dict, withCompletionBlock: {
            (error, ref) in
            print("CONNOR: ERROR HERE AT DICT \(dict)")

            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                print("CONNOR: ERROR HERE AT NEWPOSTREFERENCE")

                return
            }
            
            Api.feed.REF_FEED.child(Api.user.CURRENT_USER!.uid).child(newPostId).setValue(true)
            let myPostRef = Api.myPosts.REF_MYPOSTS.child(currentUserId).child(newPostId)
            myPostRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    print("CONNOR: ERROR HERE AT MYPOSTREF")
                    return
                } else {
                    uploadLocationToDatabase(location: location, postId: newPostId)
                }
            })
            
            ProgressHUD.showSuccess("Success")
            onSuccess()
        })
    }
    
}
