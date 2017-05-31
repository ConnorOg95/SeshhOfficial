//
//  SeshhFeedVC.swift
//  SeshhOfficial
//
//  Created by User on 02/03/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit
import SDWebImage

class SeshhFeedVC: UIViewController {

    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    
    var posts = [Post]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // revealViewController().rightViewRevealWidth = 250
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(SWRevealViewController.rightRevealToggle(_:))
        postTableView.estimatedRowHeight = 532
        postTableView.rowHeight = UITableViewAutomaticDimension
        postTableView.dataSource = self
        loadPosts()
        
    }
    
    
    @IBAction func sideBarBtnPressed(_ sender: Any) {
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(SWRevealViewController.rightRevealToggle(_:))
    }
    
    
    func loadPosts() {
        
        activityIndicatorView.startAnimating()
        
        Api.feed.observeFeed(withId: Api.user.CURRENT_USER!.uid) { (post) in
            guard let postUid = post.uid else {
                return
            }
            
            self.fetchUser(uid: postUid, completed: {
                self.posts.append(post)
                self.postTableView.reloadData()
            })
        }
        
        Api.feed.observeFeedRemoved(withId: Api.user.CURRENT_USER!.uid) { (post) in
            self.posts = self.posts.filter { $0.id != post.id }
            self.users = self.users.filter { $0.id != post.uid }
            self.postTableView.reloadData()
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        
        Api.user.observeUser(withId: uid, completion: {
            user in
            self.users.append(user)
            completed()
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommentSegue" {
            let commentVC = segue.destination as! CommentVC
            let postId = sender as! String
            commentVC.postId = postId
        }
        if segue.identifier == "HomeToProfileSegue" {
            let profileVC = segue.destination as! ProfileUserVC
            let userId = sender as! String
            profileVC.userId = userId
        }
    }
    
}

extension SeshhFeedVC: UITableViewDataSource {
    
    // TABLE VIEW CODE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        cell.post = post
        cell.user = user
        cell.delegate = self
        return cell
    }
}

extension SeshhFeedVC: PostTableViewCellDelegate {
    func goToCommentVC(postId: String) {
        performSegue(withIdentifier: "CommentSegue", sender: postId)
    }
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "HomeToProfileSegue", sender: userId)
    }
}
