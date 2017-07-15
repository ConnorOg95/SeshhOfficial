//
//  DetailVC.swift
//  SeshhOfficial
//
//  Created by User on 26/04/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var postTableView: UITableView!
    
    var postId = ""
    var post = Post()
    var user = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTableView.estimatedRowHeight = 532
        postTableView.rowHeight = UITableViewAutomaticDimension
        
        loadPost()

    }
    
    func loadPost() {
        Api.post.observePost(withId: postId) { (post) in
            guard let postUid = post.uid else {
                return
            }
            
            self.fetchUser(uid: postUid, completed: {
                self.post = post
                self.postTableView.reloadData()
            })
        }
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        
        Api.user.observeUser(withId: uid, completion: {
            user in
            self.user = user
            completed()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailToCommentSegue" {
            let commentVC = segue.destination as! CommentVC
            let postId = sender as! String
            commentVC.postId = postId
        }
        if segue.identifier == "DetailToProfileUserSegue" {
            let profileVC = segue.destination as! ProfileUserVC
            let userId = sender as! String
            profileVC.userId = userId
        }
        if segue.identifier == "DetailToHashTagSegue" {
            let hashTagVC = segue.destination as! HashTagVC
            let tag = sender as! String
            hashTagVC.tag = tag
        }
    }
}

extension DetailVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        cell.post = post
        cell.user = user
        cell.delegate = self
        return cell
    }
}

extension DetailVC: PostTableViewCellDelegate {
    func goToCommentVC(postId: String) {
        performSegue(withIdentifier: "DetailToCommentSegue", sender: postId)
    }
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "DetailToProfileUserSegue", sender: userId)
    }
    func goToHashTag(tag: String) {
        performSegue(withIdentifier: "DetailToHashTagSegue", sender: tag)
    }
}
