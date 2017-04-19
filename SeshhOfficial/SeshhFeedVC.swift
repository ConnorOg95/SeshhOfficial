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
    
    var posts = [Post]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTableView.estimatedRowHeight = 532
        postTableView.rowHeight = UITableViewAutomaticDimension
        postTableView.dataSource = self
        loadPosts()
        
    }
    
    
    func loadPosts() {
        
        activityIndicatorView.startAnimating()
        
        Api.feed.observeFeed(withId: Api.user.CURRENT_USER!.uid) { (post) in
            guard let postId = post.uid else {
                return
            }
            
            self.fetchUser(uid: postId, completed: {
                self.posts.append(post)
                self.postTableView.reloadData()
            })
        }
        
        Api.feed.observeFeedRemoved(withId: Api.user.CURRENT_USER!.uid) { (key) in
            self.posts = self.posts.filter { $0.id != key }
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
    
    // LOGGING OUT USER
    
    @IBAction func logout_TouchUpInside(_ sender: Any) {
        
        AuthService.logout(onSuccess: {
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInVC")
            self.present(signInVC, animated: true, completion: nil)
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommentSegue" {
            let commentVC = segue.destination as! CommentVC
            let postId = sender as! String
            commentVC.postId = postId
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
        cell.seshhFeedVC = self
        return cell
    }
}
