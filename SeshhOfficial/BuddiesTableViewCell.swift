//
//  BuddiesTableViewCell.swift
//  SeshhOfficial
//
//  Created by User on 15/04/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit

class BuddiesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    
    var user: User? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        nameLbl.text = user?.username
        if let photoUrlString = user?.profileImgUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImg.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImg"))
        }
        
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
        }
    }
    
    func unFollowAction() {
        if user!.isFollowing! == true {
            
            Api.Follow.unFollowAction(withUser: user!.id!)
            followBtn.removeTarget(self, action: #selector(self.unFollowAction), for: UIControlEvents.touchUpInside)
            configFollowBtn()
            user!.isFollowing! = false

        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
