//
//  PostSeshh3VC.swift
//  SeshhOfficial
//
//  Created by User on 27/04/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit

class PostSeshh3VC: UIViewController {
    
    var passedSelectedImg: UIImage?
    var passedVideoUrl: URL?
    var passedTitleTxt = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func postBtnPressed(_ sender: Any) {
        
        ProgressHUD.show("Processing...", interaction: false)
        if let profileImg = self.passedSelectedImg, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            let ratio = profileImg.size.width / profileImg.size.height
            HelpService.uploadDataToServer(data: imageData, videoUrl: self.passedVideoUrl, ratio: ratio, title: passedTitleTxt, onSuccess: {
                self.clearPost()
                self.tabBarController?.selectedIndex = 0
            })
        } else {
            ProgressHUD.showError("Image Needs To Be Selected")
        }
    }
    
    func clearPost() {
        //CLEAR ALL INPUT FIELDS FOR POST
    }

}
