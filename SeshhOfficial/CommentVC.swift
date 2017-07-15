//
//  CommentVC.swift
//  SeshhOfficial
//
//  Created by User on 27/03/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit

class CommentVC: UIViewController {

    @IBOutlet weak var commentTxtFld: UITextField!
    @IBOutlet weak var sendCommentBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintToBottom: NSLayoutConstraint!
    
    var postId: String!
    var comments = [Comment]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Comments"
        
        tableView.estimatedRowHeight = 77
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.dataSource = self
        empty()
        handleTxtFld()
        loadComments()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // SHOWING & HIDING KEYBOARD
    
    func keyboardWillShow(_ notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        UIView.animate(withDuration: 0.3) {
            self.constraintToBottom.constant = keyboardFrame!.height
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.constraintToBottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    // DOWNLOADING COMMENTS FROM DATABASE
    
    func loadComments() {
        
        Api.post_Comment.REF_POST_COMMENTS.child(self.postId).observe(.childAdded, with: {
            snapshot in
            Api.comment.observeComments(withPostId: snapshot.key, completion: {
                comment in
                self.fetchUser(uid: comment.uid!, completed: {
                    self.comments.append(comment)
                    self.tableView.reloadData()
                })
            })
            
        })
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        
        Api.user.observeUser(withId: uid, completion: {
            user in
            self.users.append(user)
            completed()
        })
        
    }
    
    func handleTxtFld() {
        
        commentTxtFld.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    // IMPROVING USER INTERACTION
    
    func textFieldDidChange() {
        if let commentTxt = commentTxtFld.text, !commentTxt.isEmpty {
            sendCommentBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            sendCommentBtn.isEnabled = true
            return
        }
        
        sendCommentBtn.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        sendCommentBtn.isEnabled = false
    }
    
    // SHOWING AND HIDING THE TAB BAR

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // SUBMITTING COMMENT

    @IBAction func sendCommentBtnPressed(_ sender: Any) {
        
        let commentsReference = Api.comment.REF_COMMENTS
        let newCommentId = commentsReference.childByAutoId().key
        let newCommentReference = commentsReference.child(newCommentId)
        guard let currentUser = Api.user.CURRENT_USER else {
            return
        }
        let currentUserId = currentUser.uid
        newCommentReference.setValue(["uid": currentUserId, "commentTxt": commentTxtFld.text!], withCompletionBlock: {
            (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            
            let words = self.commentTxtFld.text!.components(separatedBy: CharacterSet.whitespacesAndNewlines)
            
            for var word in words {
                if word.hasPrefix("#") {
                    word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
                    let newHashTagRef = Api.hashTag.REF_HASHTAG.child(word.lowercased())
                    newHashTagRef.updateChildValues([self.postId!: true])
                }
            }
            
            let postCommentRef = Api.post_Comment.REF_POST_COMMENTS.child(self.postId).child(newCommentId)
            postCommentRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                Api.post.observePost(withId: self.postId, completion: { (post) in
                    if post.uid! != Api.user.CURRENT_USER!.uid {
                        let timestamp = NSNumber(value: Int(Date().timeIntervalSince1970))
                        let newNotificationId = Api.notification.REF_NOTIFICATION.child(post.uid!).childByAutoId().key
                        let newNotificationReference = Api.notification.REF_NOTIFICATION.child(post.uid!).child(newNotificationId)
                        newNotificationReference.setValue(["from": Api.user.CURRENT_USER!.uid, "objectId": self.postId!, "type": "comment", "timestamp": timestamp])
                    }
                    
                })
                
                
            })
            
            
            
            
//            let words = self.commentTxtFld.text!.components(separatedBy: CharacterSet.whitespacesAndNewlines)
            
//            for var word in words {
//                if word.hasPrefix("#") {
//                    word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
//                    let newHashTagRef = Api.hashTag.REF_HASHTAG.child(word.lowercased())
//                    newHashTagRef.updateChildValues([self.postId: true])
//                }
//            }
            
//            let postCommentRef = Api.post_Comment.REF_POST_COMMENTS.child(self.postId).child(newCommentId)
//            postCommentRef.setValue(true, withCompletionBlock: { (error, ref) in
//                if error != nil {
//                    ProgressHUD.showError(error!.localizedDescription)
//                    return
//                }
//            })
            self.empty()
            self.view.endEditing(true)
        })
    }
    
    // CLEARING FIELDS AFTER POSTING
    
    func empty() {
        self.commentTxtFld.text = ""
        self.sendCommentBtn.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        self.sendCommentBtn.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CommentToProfileSegue" {
            let profileVC = segue.destination as! ProfileUserVC
            let userId = sender as! String
            profileVC.userId = userId
        }
        if segue.identifier == "CommentToHashTagSegue" {
            let hashTagVC = segue.destination as! HashTagVC
            let tag = sender as! String
            hashTagVC.tag = tag
        }
    }
}

// EXTENSION FOR TABLEVIEW CODING

extension CommentVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        let comment = comments[indexPath.row]
        let user = users[indexPath.row]
        cell.comment = comment
        cell.user = user
        return cell
    }
}
extension CommentVC: CommentTableViewCellDelegate {
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "CommentToProfileSegue", sender: userId)
    }
    func goToHashTag(tag: String) {
        performSegue(withIdentifier: "CommentToHashTagSegue", sender: tag)
    }
}

