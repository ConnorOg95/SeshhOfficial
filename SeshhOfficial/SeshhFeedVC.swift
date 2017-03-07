//
//  SeshhFeedVC.swift
//  SeshhOfficial
//
//  Created by User on 02/03/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit
import FirebaseAuth

class SeshhFeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout_TouchUpInside(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print("CONNOR: LOGOUT ERROR - \(logoutError)")
        }
        
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInVC")
        self.present(signInVC, animated: true, completion: nil)
    }

}
