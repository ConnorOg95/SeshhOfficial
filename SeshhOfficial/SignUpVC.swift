//
//  SignUpVC.swift
//  SeshhOfficial
//
//  Created by User on 02/03/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var usernameTxtFld: UITextField!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var confirmEmailTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var confirmedPasswordTxtFld: UITextField!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var signUpBtn: UIButton!
    
    var selectedImg: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NEED TO SORT ALL THIS OUT!
        
        usernameTxtFld.backgroundColor = UIColor.clear
        usernameTxtFld.tintColor = UIColor.white
        usernameTxtFld.textColor = UIColor.white
        usernameTxtFld.attributedPlaceholder = NSAttributedString(string: usernameTxtFld.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayerUsername = CALayer()
        bottomLayerUsername.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayerUsername.backgroundColor = UIColor.white.cgColor
        usernameTxtFld.layer.addSublayer(bottomLayerUsername)
        
        emailTxtFld.backgroundColor = UIColor.clear
        emailTxtFld.tintColor = UIColor.white
        emailTxtFld.textColor = UIColor.white
        emailTxtFld.attributedPlaceholder = NSAttributedString(string: emailTxtFld.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayerEmail = CALayer()
        bottomLayerEmail.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayerEmail.backgroundColor = UIColor.white.cgColor
        emailTxtFld.layer.addSublayer(bottomLayerEmail)
        
        passwordTxtFld.backgroundColor = UIColor.clear
        passwordTxtFld.tintColor = UIColor.white
        passwordTxtFld.textColor = UIColor.white
        passwordTxtFld.attributedPlaceholder = NSAttributedString(string: passwordTxtFld.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.6)])
        let bottomLayerPassword = CALayer()
        bottomLayerPassword.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.6)
        bottomLayerPassword.backgroundColor = UIColor.white.cgColor
        passwordTxtFld.layer.addSublayer(bottomLayerPassword)
        
        profileImgView.layer.cornerRadius = 50
        profileImgView.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpVC.handleSelectProfileImgView))
        profileImgView.addGestureRecognizer(tapGesture)
        profileImgView.isUserInteractionEnabled = true
        signUpBtn.isEnabled = false
        handleTxtFld()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
        //THIS IS CHANGING COLOUR AS SOON AS TEXT FIELD IS EDITED - NEEDS TO BE REDONE
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
    
    //NEED TO CHECK THAT CONFIRMED EMAILS AND PASSWORDS MATCH BEFORE SUBMIT
    
    @IBAction func SignUpBtnPressed(_ sender: Any) {
        
        view.endEditing(true)
        ProgressHUD.show("Processing...", interaction: false)
        if let profileImg = self.selectedImg, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            AuthService.signUp(username: usernameTxtFld.text!, email: emailTxtFld.text!, password: passwordTxtFld.text!, imageData: imageData, onSuccess: {
                ProgressHUD.showSuccess("Sign Up Successful")
                self.performSegue(withIdentifier: "signUpToTabBarVC", sender: nil)
            }, onError: { (errorString) in
                ProgressHUD.showError(errorString!)
            })
        } else {
            ProgressHUD.showError("Profile Image Needs To Be Selected")
        }
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
