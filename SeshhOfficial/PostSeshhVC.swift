//
//  PostSeshhVC.swift
//  SeshhOfficial
//
//  Created by User on 02/03/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit
import AVFoundation

class PostSeshhVC: UIViewController {
    
    @IBOutlet weak var titleTxtFld: UITextField!
    @IBOutlet weak var descriptionTxtView: UITextView!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var addBuddiesBtn: UIButton!
    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var clearPostBtn: UIBarButtonItem!
    

    var selectedImg: UIImage?
    var videoUrl : URL?
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
    
    // IMPROVING USER INTERACTION
    
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
    // IMAGE PICKER
    
    func handleSelectPhoto() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.mediaTypes = ["public.image, public.movie"]
        present(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func clearPostBtnPressed(_ sender: Any) {
        clearPost()
        handlePost()
    }
    
    // SUBMIT POST BUTTON PRESSED
    
    @IBAction func postBtnPressed(_ sender: Any) {
        
        ProgressHUD.show("Processing...", interaction: false)
        if let profileImg = self.selectedImg, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            let ratio = profileImg.size.width / profileImg.size.height
            HelpService.uploadDataToServer(data: imageData, videoUrl: self.videoUrl, ratio: ratio, title: titleTxtFld.text!, onSuccess: {
                self.clearPost()
                self.tabBarController?.selectedIndex = 0
            })
        } else {
            ProgressHUD.showError("Image Needs To Be Selected")
        }
    }
    
    // CLEAR ALL CELLS IN POST - MAY NEED TO BE REMOVED
    
    func clearPost() {
        self.titleTxtFld.text = ""
        self.descriptionTxtView.text = ""
        self.photoImg.image = UIImage(named: "placeholderImg")
    }
    
}

// IMAGE SELECTION - NEED TO IMPLEMENT IMAGE EDITING

extension PostSeshhVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let videoUrl = info["UIImagePickerControllerMediaURL"] as? URL {
            if let thumbnailImg = self.generateThumbnailImgForFileUrl(videoUrl) {
                selectedImg = thumbnailImg
                photoImg.image = thumbnailImg
                self.videoUrl = videoUrl

            }
        }
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImg = image
            photoImg.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func generateThumbnailImgForFileUrl(_ fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(6, 3), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let err {
            print(err)
        }
        return nil
    }
    
    
    
}
