//
//  PostTableViewCell.swift
//  SeshhOfficial
//
//  Created by User on 12/03/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PostTableViewCell: UITableViewCell {
    
    //INPUT ALL OUTLETS FOR TABLE VIEW CELL
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var categoryImgView: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postPhotoImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var likeImgView: UIImageView!
    @IBOutlet weak var commentImgView: UIImageView!
    @IBOutlet weak var shareImgView: UIImageView!
    @IBOutlet weak var likesDisplayBtn: UIButton!
    @IBOutlet weak var buddiesDisplayBtn: UIButton!
    
    var seshhFeedVC: SeshhFeedVC?
    
    var post: Post? {
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
        
        titleLbl.text = post?.title
        if let photoUrlString = post?.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            postPhotoImgView.sd_setImage(with: photoUrl)
        }
    }
    
    func setupUserInfo() {
        
        usernameLbl.text = user?.username
        if let photoUrlString = user?.profileImgUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImgView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImg"))
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        usernameLbl.text = ""
        titleLbl.text = ""
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.commentImgViewPressed))
        commentImgView.addGestureRecognizer(tapGesture)
        commentImgView.isUserInteractionEnabled = true
    }
    
    func commentImgViewPressed() {
        if let id = post?.id {
            seshhFeedVC?.performSegue(withIdentifier: "CommentSegue", sender: id)

        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImgView.image = UIImage(named: "placeholderImg")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
