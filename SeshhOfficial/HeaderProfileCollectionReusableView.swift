//
//  HeaderProfileCollectionReusableView.swift
//  SeshhOfficial
//
//  Created by User on 11/04/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit
import FirebaseAuth

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var postCountLbl: UILabel!
    @IBOutlet weak var followingCountLbl: UILabel!
    @IBOutlet weak var followerCountLbl: UILabel!
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        nameLbl.text = ""
//        profileImgView.image = UIImage(named: "placeholderImg")
//    }
    
    var user: User? {
        didSet {
            updateView()
        }
    }
    
    // UPDATING THE PROFILE HEADER VIEW
    
    func updateView() {
        self.nameLbl.text = user!.username
        if let photoUrlString = user!.profileImgUrl {
            let photoUrl = URL(string: photoUrlString)
            self.profileImgView.sd_setImage(with: photoUrl)
        }
    }
}
