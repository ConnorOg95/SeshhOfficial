//
//  SignUpVC.swift
//  SeshhOfficial
//
//  Created by User on 02/03/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpVC: UIViewController {
    
    @IBOutlet weak var usernameTxtFld: UITextField!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var signUpBtn: UIButton!
    
    var selectedImg: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImgView.layer.cornerRadius = 50
        profileImgView.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.handleSelectProfileImgView))
        profileImgView.addGestureRecognizer(tapGesture)
        profileImgView.isUserInteractionEnabled = true
        
        handleTxtFld()

    }
    
    func handleTxtFld() {
        usernameTxtFld.addTarget(self, action: #selector(SignUpVC.textFieldDidChange), for: UIControlEvents.editingChanged)
        emailTxtFld.addTarget(self, action: #selector(SignUpVC.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTxtFld.addTarget(self, action: #selector(SignUpVC.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    func textFieldDidChange() {
        guard let username = usernameTxtFld.text, !username.isEmpty, let email = emailTxtFld.text, !email.isEmpty, let password = passwordTxtFld.text, !password.isEmpty else {
            signUpBtn.setTitleColor(UIColor.lightText, for: UIControlState.normal)
            signUpBtn.isEnabled = false
            return
        }
        signUpBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        signUpBtn.isEnabled = true
    }
    
    func handleSelectProfileImgView() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func dismiss_onClick(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func SignUpBtnPressed(_ sender: Any) {
        
        FIRAuth.auth()?.createUser(withEmail: emailTxtFld.text!, password: passwordTxtFld.text!, completion: { (user: FIRUser?, error: Error?) in
            if error != nil {
                print("CONNOR: SIGN UP ERROR - \(error?.localizedDescription)")
                return
            }
            let uid = user?.uid
            let storageRef = FIRStorage.storage().reference(forURL: "gs://seshhofficial.appspot.com").child("profile_image").child(uid!)
            if let profileImg = self.selectedImg, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
                storageRef.put(imageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        return
                    }
                    let profileImgURL = metadata?.downloadURL()?.absoluteString
                    self.setUserInformation(profileImgURL: profileImgURL!, username: self.usernameTxtFld.text!, email: self.emailTxtFld.text!, uid: uid!)
                })
            }
        })
    }
    
    func setUserInformation(profileImgURL: String, username: String, email: String, uid: String) {
        
        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("users")
        let newUserReference = usersReference.child(uid)
        newUserReference.setValue(["username": username, "email": email, "profileImgURL": profileImgURL])
        
    }
    
    
    
}

extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImg = image
            profileImgView.image = image
        }
        dismiss(animated: true, completion: nil)
    }


}
