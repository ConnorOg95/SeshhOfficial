//
//  SettingsTVC.swift
//  SeshhOfficial
//
//  Created by User on 25/04/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit

protocol SettingsTVCDelegate {
    func updateUserInfo()
}

class SettingsTVC: UITableViewController {

    @IBOutlet weak var usernameTxtFld: UITextField!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var profileImgView: UIImageView!
    
    var delegate: SettingsTVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Edit Profile"
        usernameTxtFld.delegate = self
        emailTxtFld.delegate = self
        fetchCurrentUser()

    }
    
    func fetchCurrentUser() {
        Api.user.observeCurrentUser { (user) in
            self.usernameTxtFld.text = user.username
            self.emailTxtFld.text = user.email
            if let profileUrl = URL(string: user.profileImgUrl!) {
                self.profileImgView.sd_setImage(with: profileUrl)
            }
        }
    }
    
    // LOGGING OUT
    @IBAction func logoutBtnPressed(_ sender: Any) {
        AuthService.logout(onSuccess: {
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInVC")
            self.present(signInVC, animated: true, completion: nil)
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        if let profileImg = self.profileImgView.image, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            ProgressHUD.show("Waiting...")
            AuthService.updateUserInfo(username: usernameTxtFld.text!, email: emailTxtFld.text!, imageData: imageData, onSuccess: { 
                ProgressHUD.showSuccess("Success")
                self.delegate?.updateUserInfo()
            }, onError: { (errorMessage) in
                ProgressHUD.showError(errorMessage)
            })
            }
    }
    
    @IBAction func changeProfileImgBtnPressed(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
}

extension SettingsTVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            profileImgView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

extension SettingsTVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
