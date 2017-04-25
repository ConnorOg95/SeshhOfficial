//
//  PostTableViewCell.swift
//  SeshhOfficial
//
//  Created by User on 12/03/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit
protocol PostTableViewCellDelegate {
    func goToCommentVC(postId: String)
    func goToProfileUserVC(userId: String)
}

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
    
    var delegate: PostTableViewCellDelegate?
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
    
    // UPDATING THE POST CELL
    
    func updateView() {
        
        titleLbl.text = post?.title
        if let photoUrlString = post?.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            postPhotoImgView.sd_setImage(with: photoUrl)
        }
        
        self.updateLike(post: self.post!)
        
    }
    
    // UPDATING LIKE IMAGE AND COUNTER ON POST CELL
    
    func updateLike(post: Post) {
        let imageName = post.likes == nil || !post.isLiked! ? "like" : "likeSelected"
        likeImgView.image = UIImage(named: imageName)
        guard let count = post.likeCount else {
            return
        }
        if count != 0 {
            likesDisplayBtn.setTitle("Likes: \(count)", for: UIControlState.normal)
        } else {
            likesDisplayBtn.setTitle("Be the first to like this", for: UIControlState.normal)
        }
    }
    
    // SETTING USERNAME AND PROFILE IMAGE FOR POST
    
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
        
        let tapGestureForLikeImgView = UITapGestureRecognizer(target: self, action: #selector(self.likeImgViewPressed))
        likeImgView.addGestureRecognizer(tapGestureForLikeImgView)
        likeImgView.isUserInteractionEnabled = true
        let tapGestureForNameLbl = UITapGestureRecognizer(target: self, action: #selector(self.nameLblPressed))
        usernameLbl.addGestureRecognizer(tapGestureForNameLbl)
        usernameLbl.isUserInteractionEnabled = true
    }
    
    func nameLblPressed() {
        if let id = user?.id {
            delegate?.goToProfileUserVC(userId: id)
        }
    }
    
    // LIKE BUTTON PRESSED
    
    func likeImgViewPressed() {
        Api.post.incrementLikes(postId: post!.id!, onSucess: { (post) in
            self.updateLike(post: post)
            self.post?.likes = post.likes
            self.post?.isLiked = post.isLiked
            self.post?.likeCount = post.likeCount
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
//        incrementLikes(forRef: postRef)
        }
    }
    
    // COMMENT BUTTON PRESSED
    
    func commentImgViewPressed() {
        if let id = post?.id {
            delegate?.goToCommentVC(postId: id)
        }
    }
    
    
    
    // NEED TO IMPLEMENT A BETTER IMG/ANIMATION
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImgView.image = UIImage(named: "placeholderImg")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
