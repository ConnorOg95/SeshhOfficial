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

class SeshhFeedVC: UIViewController {

    @IBOutlet weak var postTableView: UITableView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTableView.estimatedRowHeight = 521
        postTableView.rowHeight = UITableViewAutomaticDimension
        postTableView.dataSource = self
        loadPosts()
        
        //        var post = Post(captionText: "test", photoUrlString: "url1")
        
    }
    
    func loadPosts() {
        
        FIRDatabase.database().reference().child("seshhs").observe(.childAdded) { (snapshot: FIRDataSnapshot) in
            
            if let dict = snapshot.value as? [String: Any] {
                let newPost = Post.transformPost(dict: dict)
                self.posts.append(newPost)
                self.postTableView.reloadData()
            }
            
        }
    }

    
    @IBAction func logout_TouchUpInside(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print("CONNOR: LOGOUT ERROR - \(logoutError)")
        }
        
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInVC")
        self.present(signInVC, animated: true, completion: nil)
    }

}

extension SeshhFeedVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        //        cell.textLabel?.text = posts[indexPath.row].caption
        //        cell.backgroundColor = .red
        return cell
    }
    
    
}
