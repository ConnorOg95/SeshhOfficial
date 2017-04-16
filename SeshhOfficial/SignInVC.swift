//
//  SignInVC.swift
//  SeshhOfficial
//
//  Created by User on 02/03/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    
    
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NEED TO SORT THIS OUT!
        
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
        
        signInBtn.isEnabled = false
        handleTxtFld()
        
        // Do any additional setup after loading the view.
    }
    
    // HIDE THE KEYBOARD
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // AUTO LOG IN
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Api.user.CURRENT_USER != nil {
            self.performSegue(withIdentifier: "signInToTabBarVC", sender: nil)
        }
    }
    
    func handleTxtFld() {
        emailTxtFld.addTarget(self, action: #selector(SignUpVC.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTxtFld.addTarget(self, action: #selector(SignUpVC.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    func textFieldDidChange() {
        guard let email = emailTxtFld.text, !email.isEmpty, let password = passwordTxtFld.text, !password.isEmpty else {
            signInBtn.setTitleColor(UIColor.lightText, for: UIControlState.normal)
            signInBtn.isEnabled = false
            return
        }
        //THIS IS CHANGING COLOUR AS SOON AS TEXT FIELD IS EDITED - NEEDS TO BE REDONE
        signInBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        signInBtn.isEnabled = true
    }
    
    @IBAction func signInBtn(_ sender: Any) {
        
        view.endEditing(true)
        ProgressHUD.show("Processing...", interaction: false)
        AuthService.signIn(email: emailTxtFld.text!, password: passwordTxtFld.text!, onSuccess: {
            ProgressHUD.showSuccess("Log In Successful")
            self.performSegue(withIdentifier: "signInToTabBarVC", sender: nil)
        }, onError: { error in
            ProgressHUD.showError(error!)
        })
    }
}
