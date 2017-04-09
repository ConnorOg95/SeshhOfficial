//
//  PostSeshhVC.swift
//  SeshhOfficial
//
//  Created by User on 02/03/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class PostSeshhVC: UIViewController {
    
    @IBOutlet weak var titleTxtFld: UITextField!
    @IBOutlet weak var descriptionTxtView: UITextView!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var addBuddiesBtn: UIButton!
    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var clearPostBtn: UIBarButtonItem!
    

    var selectedImg: UIImage?
    var buddies: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        photoImg.addGestureRecognizer(tapGesture)
        photoImg.isUserInteractionEnabled = true

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handlePost()
    }
    
    func handlePost() {
        
        if selectedImg != nil {
            self.postBtn.isEnabled = true
            self.clearPostBtn.isEnabled = true
            self.postBtn.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            self.postBtn.isEnabled = false
            self.clearPostBtn.isEnabled = false
            self.postBtn.backgroundColor = .lightGray
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
    }
    
    func handleSelectPhoto() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func clearPostBtnPressed(_ sender: Any) {
        clearPost()
        handlePost()
    }
    
    @IBAction func postBtnPressed(_ sender: Any) {
        
        ProgressHUD.show("Processing...", interaction: false)
        if let profileImg = self.selectedImg, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            let photoIdString = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("seshhPostImgs").child(photoIdString)
            storageRef.put(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                let photoUrl = metadata?.downloadURL()?.absoluteString
                self.sendDataToDatabase(photoUrl: photoUrl!)
            })
            
        } else {
            ProgressHUD.showError("Image Needs To Be Selected")
        }
    }
    
    func sendDataToDatabase(photoUrl: String) {
        
        let ref = FIRDatabase.database().reference()
        let postsReference = ref.child("seshhPosts")
        let newPostId = postsReference.childByAutoId().key
        let newPostReference = postsReference.child(newPostId)
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            return
        }
        let currentUserId = currentUser.uid
        newPostReference.setValue(["uid": currentUserId, "photoUrl": photoUrl, "title": titleTxtFld.text!, "description": descriptionTxtView.text!], withCompletionBlock: {
            (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            ProgressHUD.showSuccess("Success")
            self.clearPost()
            self.tabBarController?.selectedIndex = 0
            
        })
    }
    
    func clearPost() {
        self.titleTxtFld.text = ""
        self.descriptionTxtView.text = ""
        self.photoImg.image = UIImage(named: "placeholderImg")
    }
    
}

extension PostSeshhVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImg = image
            photoImg.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
