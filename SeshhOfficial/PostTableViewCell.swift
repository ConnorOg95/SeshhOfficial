//
//  PostTableViewCell.swift
//  SeshhOfficial
//
//  Created by User on 12/03/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

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
    var postRef: FIRDatabaseReference!
    
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
        Api.post.REF_POSTS.child(post!.id!).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let post = Post.transformPost(dict: dict, key: snapshot.key)
                self.updateLike(post: post)
            }
        
        })
        updateLike(post: post!)
        Api.post.REF_POSTS.child(post!.id!).observe(.childChanged, with: {
            snapshot in
            if let value = snapshot.value as? Int {
                self.likesDisplayBtn.setTitle("\(value) likes", for: UIControlState.normal)
            }
        })
        
    }
    
    // UPDATING LIKE IMAGE AND COUNTER ON POST CELL
    
    func updateLike(post: Post) {
        let imageName = post.likes == nil || !post.isLiked! ? "like" : "likeSelected"
        likeImgView.image = UIImage(named: imageName)
        guard let count = post.likeCount else {
            return
        }
        if count != 0 {
            likesDisplayBtn.setTitle("\(count) likes", for: UIControlState.normal)
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
        
    }
    
    func likeImgViewPressed() {
        postRef = Api.post.REF_POSTS.child(post!.id!)
        incrementLikes(forRef: postRef)
        
    }
    func incrementLikes(forRef ref: FIRDatabaseReference) {
        ref.runTransactionBlock({ (currentData: FIRMutableData) -> FIRTransactionResult in
            if var post = currentData.value as? [String: AnyObject], let uid = FIRAuth.auth()?.currentUser?.uid {
                var likes: Dictionary<String, Bool>
                likes = post["likes"] as? [String: Bool] ?? [:]
                var likeCount = post["likeCount"] as? Int ?? 0
                if let _ = likes[uid] {
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                } else {
                    likeCount += 1
                    likes[uid] = true
                }
                post["likeCount"] = likeCount as AnyObject?
                post["likes"] = likes as AnyObject?
                currentData.value = post
                return FIRTransactionResult.success(withValue: currentData)
            }
            return FIRTransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let dict = snapshot?.value as? [String: Any] {
                let post = Post.transformPost(dict: dict, key: snapshot!.key)
                self.updateLike(post: post)
            }
            
        }
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
