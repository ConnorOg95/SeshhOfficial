//
//  SeshhFeedVC.swift
//  SeshhOfficial
//
//  Created by User on 02/03/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
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
        
        //        var post = Post(captionText: "test", photoUrlString: "url1")
        
    }
    
    func loadPosts() {
        
        activityIndicatorView.startAnimating()
        PostApi().observePosts() { (post) in
            self.fetchUser(uid: post.uid!, completed: {
                self.posts.append(post)
                self.activityIndicatorView.stopAnimating()
                self.postTableView.reloadData()
            })
        }
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        
        Api.user.observeUser(withId: uid, completion: {
            user in
            self.users.append(user)
            completed()
            })

    }


    
    @IBAction func logout_TouchUpInside(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInVC")
            self.present(signInVC, animated: true, completion: nil)
        
    } catch let logoutError {
        print("CONNOR: LOGOUT ERROR - \(logoutError)")
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
