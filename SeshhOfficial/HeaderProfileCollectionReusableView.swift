//
//  HeaderProfileCollectionReusableView.swift
//  SeshhOfficial
//
//  Created by User on 11/04/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol HeaderProfileCollectionReusableViewDelegate {
    func updateFollowBtn(forUser user: User)
}

protocol HeaderProfileCollectionReusableViewDelegateSwitchSettingTVC {
    func goToSettingsTVC ()
}

class HeaderProfileCollectionReusableView: UICollectionReusableView {
    
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var postCountLbl: UILabel!
    @IBOutlet weak var followingCountLbl: UILabel!
    @IBOutlet weak var followerCountLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    var delegate2: HeaderProfileCollectionReusableViewDelegateSwitchSettingTVC?
    var delegate: HeaderProfileCollectionReusableViewDelegate?
    var user: User? {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clearItems()
        profileImgView.layer.borderWidth = 2
        profileImgView.layer.borderColor = UIColor(red: 60/255, green: 204/255, blue: 252/255, alpha: 1).cgColor
    }
    
    // UPDATING THE PROFILE HEADER VIEW
    
    func updateView() {
        self.nameLbl.text = user!.username
        if let photoUrlString = user!.profileImgUrl {
            let photoUrl = URL(string: photoUrlString)
            self.profileImgView.sd_setImage(with: photoUrl)
        }
        
        Api.myPosts.fetchCountMyPosts(userId: user!.id!) { (count) in
            self.postCountLbl.text = "\(count)"
        }
        
        Api.Follow.fetchCountFollowing(userId: user!.id!) { (count) in
            self.followingCountLbl.text = "\(count)"
        }
        
        Api.Follow.fetchCountFollowers(userId: user!.id!) { (count) in
            self.followerCountLbl.text = "\(count)"
        }
        
        if user?.id == Api.user.CURRENT_USER?.uid {
            followBtn.setTitle("Edit Profile", for: UIControlState.normal)
            followBtn.addTarget(self, action: #selector(self.goToSettingsTVC), for: UIControlEvents.touchUpInside)
        } else {
            updateStateFollowBtn()
        }
    }
    
    func clearItems() {
        self.nameLbl.text = ""
        self.postCountLbl.text = ""
        self.followingCountLbl.text = ""
        self.followerCountLbl.text = ""
        profileImgView.image = UIImage(named: "placeholderImg")
    }
    
    func goToSettingsTVC() {
        delegate2?.goToSettingsTVC()
    }
    
    func updateStateFollowBtn() {
        if user!.isFollowing! {
            configUnFollowBtn()
        } else {
            configFollowBtn()
        }
    }
    
    func configFollowBtn() {
        followBtn.layer.borderWidth = 1
        followBtn.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232/255, alpha: 1).cgColor
        followBtn.layer.cornerRadius = 5
        followBtn.clipsToBounds = true
        followBtn.setTitleColor(UIColor.white, for: .normal)
        followBtn.backgroundColor = UIColor(red: 69/255, green: 142/255, blue: 255/255, alpha: 1)
        self.followBtn.setTitle("Follow", for: UIControlState.normal)
        followBtn.addTarget(self, action: #selector(self.followAction), for: UIControlEvents.touchUpInside)
    }
    
    func configUnFollowBtn() {
        followBtn.layer.borderWidth = 1
        followBtn.layer.borderColor = UIColor(red: 226/255, green: 228/255, blue: 232/255, alpha: 1).cgColor
        followBtn.layer.cornerRadius = 5
        followBtn.clipsToBounds = true
        followBtn.setTitleColor(UIColor.black, for: .normal)
        followBtn.backgroundColor = UIColor.clear
        self.followBtn.setTitle("Following", for: UIControlState.normal)
        followBtn.addTarget(self, action: #selector(self.unFollowAction), for: UIControlEvents.touchUpInside)
    }
    
    func followAction() {
        if user!.isFollowing! == false {
            
            Api.Follow.followAction(withUser: user!.id!)
            followBtn.removeTarget(self, action: #selector(self.followAction), for: UIControlEvents.touchUpInside)
            configUnFollowBtn()
            user!.isFollowing! = true
            delegate?.updateFollowBtn(forUser: user!)
        }
    }
    
    func unFollowAction() {
        if user!.isFollowing! == true {
            
            Api.Follow.unFollowAction(withUser: user!.id!)
            followBtn.removeTarget(self, action: #selector(self.unFollowAction), for: UIControlEvents.touchUpInside)
            configFollowBtn()
            user!.isFollowing! = false
            delegate?.updateFollowBtn(forUser: user!)

        }
    }

}
