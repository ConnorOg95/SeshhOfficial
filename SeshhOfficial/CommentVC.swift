//
//  CommentVC.swift
//  SeshhOfficial
//
//  Created by User on 27/03/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

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
    
    func textFieldDidChange() {
        if let commentTxt = commentTxtFld.text, !commentTxt.isEmpty {
            sendCommentBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            sendCommentBtn.isEnabled = true
            return
        }
        
        sendCommentBtn.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        sendCommentBtn.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    @IBAction func sendCommentBtnPressed(_ sender: Any) {
        
        let commentsReference = Api.comment.REF_COMMENTS
        let newCommentId = commentsReference.childByAutoId().key
        let newCommentReference = commentsReference.child(newCommentId)
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            return
        }
        let currentUserId = currentUser.uid
        newCommentReference.setValue(["uid": currentUserId, "commentTxt": commentTxtFld.text!], withCompletionBlock: {
            (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            let postCommentRef = Api.post_Comment.REF_POST_COMMENTS.child(self.postId).child(newCommentId)
            postCommentRef.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil {
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
            })
            self.empty()
            self.view.endEditing(true)
        })
    }
    
    func empty() {
        self.commentTxtFld.text = ""
        self.sendCommentBtn.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        self.sendCommentBtn.isEnabled = false
    }
}

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

