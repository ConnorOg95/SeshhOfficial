//
//  ActivityTableViewCell.swift
//  SeshhOfficial
//
//  Created by User on 23/06/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit

protocol ActivityTableViewCellDelegate {
    func goToDetailVC(postId: String)
//    func goToUserProfileVC(userId: String)
}

class ActivityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var photoImg: UIImageView!
    
    var delegate: ActivityTableViewCellDelegate?
    
    var notification: Notification? {
        didSet {
            updateView()
        }
    }
    
    var user: User? {
        didSet {
            setupUserInfo()
        }
    }
    
    func updateView() {
        switch notification!.type! {
        case "feed":
            descriptionLbl.text = "added a new seshh"
            let objectId = notification!.objectId!
            Api.post.observePost(withId: objectId, completion: { (post) in
                if let photoUrlString = post.photoUrl {
                    let photoUrl = URL(string: photoUrlString)
                    self.photoImg.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImg"))
                }
            })
        case "like":
            descriptionLbl.text = "liked your seshh"
            
            let objectId = notification!.objectId!
            Api.post.observePost(withId: objectId, completion: { (post) in
                if let photoUrlString = post.photoUrl {
                    let photoUrl = URL(string: photoUrlString)
                    self.photoImg.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImg"))
                    
                }
            })
        case "comment":
            descriptionLbl.text = "commented on your seshh"
            
            let objectId = notification!.objectId!
            Api.post.observePost(withId: objectId, completion: { (post) in
                if let photoUrlString = post.photoUrl {
                    let photoUrl = URL(string: photoUrlString)
                    self.photoImg.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImg"))
                }
            })
        case "follow":
            descriptionLbl.text = "started following you"
            
            let objectId = notification!.objectId!
            Api.post.observePost(withId: objectId, completion: { (post) in
                if let photoUrlString = post.photoUrl {
                    let photoUrl = URL(string: photoUrlString)
                    self.photoImg.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImg"))
                    
                }
            })
        case "tag":
            descriptionLbl.text = "tagged you"
            
            let objectId = notification!.objectId!
            Api.post.observePost(withId: objectId, completion: { (post) in
                if let photoUrlString = post.photoUrl {
                    let photoUrl = URL(string: photoUrlString)
                    self.photoImg.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImg"))
                    
                }
            })
            
        default:
            print("default")
        }
        if let timestamp = notification?.timestamp {
            print(timestamp)
            let timestampDate = Date(timeIntervalSince1970: Double(timestamp))
            let now = Date()
            let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
            let diff = Calendar.current.dateComponents(components, from: timestampDate, to: now)
            
            var timeText = ""
            if diff.second! <= 0 {
                timeText = "Now"
            }
            if diff.second! > 0 && diff.minute == 0 {
                timeText = "\(diff.second!)s"
            }
            if diff.minute! > 0 && diff.hour == 0 {
                timeText = "\(diff.minute!)m"
            }
            if diff.hour! > 0 && diff.day == 0 {
                timeText = "\(diff.hour!)h"
            }
            if diff.day! > 0 && diff.weekOfMonth == 0 {
                timeText = "\(diff.day!)d"
            }
            if diff.weekOfMonth! > 0 {
                timeText = "\(diff.weekOfMonth!)w"
                
            }
            timeLbl.text = timeText
        }
        
        let tapGestureForPhotoImg = UITapGestureRecognizer(target: self, action: #selector(self.cellPressed))
        addGestureRecognizer(tapGestureForPhotoImg)
        isUserInteractionEnabled = true
        
    }
    
    func cellPressed() {
            if let id = notification?.objectId {
                delegate?.goToDetailVC(postId: id)
            }
    }
    
    func setupUserInfo() {
        usernameLbl.text = user?.username
        if let photoUrlString = user?.profileImgUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImg.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImg"))
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
