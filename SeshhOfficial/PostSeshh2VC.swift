//
//  PostSeshh2VC.swift
//  SeshhOfficial
//
//  Created by User on 27/04/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit
import AVFoundation

class PostSeshh2VC: UIViewController {
    
    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    
    var selectedImg: UIImage?
    var videoUrl: URL?
    var passedDict = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CONNOR: PASSED DICT - \(passedDict)")

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        photoImg.addGestureRecognizer(tapGesture)
        photoImg.isUserInteractionEnabled = true
    }
    
    func handleSelectPhoto() { //PHOTO
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.mediaTypes = ["public.image", "public.movie"]
        present(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        if let profileImg = self.selectedImg, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            let ratio = profileImg.size.width / profileImg.size.height
            passedDict["data"] = imageData
            passedDict["ratio"] = ratio
            if self.videoUrl != nil {
                passedDict["videoUrl"] = videoUrl
            }
            let nextPostVC = storyboard?.instantiateViewController(withIdentifier: "PostSeshh3VC") as! PostSeshh3VC
            nextPostVC.passedPostDict = passedDict
            navigationController?.pushViewController(nextPostVC, animated: true)
        } else {
            ProgressHUD.showError("A Photo Or Video Must Be Selected Before Continuing")
        }
    }

}

extension PostSeshh2VC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL {
            if let thumbnailImg = self.generateThumbnailImgForFileUrl(videoUrl) {
                selectedImg = thumbnailImg
                photoImg.image = thumbnailImg
                self.videoUrl = videoUrl
                
            }
        }
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImg = image
            photoImg.image = image
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImg = image
            photoImg.image = image
        } else {
            print("CONNOR: SOMETHING IS WRONG HERE")
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
