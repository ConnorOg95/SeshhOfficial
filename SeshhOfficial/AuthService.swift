//
//  AuthService.swift
//  SeshhOfficial
//
//  Created by User on 06/03/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class AuthService {
    
    static func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user,error) in
            if error != nil {
                onError(error!.localizedDescription)
                print("CONNOR: SIGN IN ERROR - \(error?.localizedDescription)")
                return
            }
            print("CONNOR: SUCESSFULLY AUTHENTICATED WITH FIREBASE \(user?.email)")
            onSuccess()
            
        })
    }
    
    static func signUp(username: String, email: String, password: String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
            if error != nil {
                onError(error!.localizedDescription)
                print("CONNOR: SIGN UP ERROR - \(error?.localizedDescription)")
                return
            }
            let uid = user?.uid
            let storageRef = FIRStorage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("profile_image").child(uid!)

            storageRef.put(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    return
                }
                let profileImgURL = metadata?.downloadURL()?.absoluteString
                self.setUserInformation(profileImgURL: profileImgURL!, username: username, email: email, uid: uid!, onSuccess: onSuccess)
            })
        })
    }
    
    static func setUserInformation(profileImgURL: String, username: String, email: String, uid: String, onSuccess: @escaping () -> Void) {
        
        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("users")
        let newUserReference = usersReference.child(uid)
        newUserReference.setValue(["username": username, "email": email, "profileImgURL": profileImgURL])
        onSuccess()
    }
}
