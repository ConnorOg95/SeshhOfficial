//
//  ActivityVC.swift
//  SeshhOfficial
//
//  Created by User on 02/03/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit

class ActivityVC: UIViewController {


    @IBOutlet weak var tableView: UITableView!
    
    var notifications = [Notification]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadNotifications()
    }
    
    func loadNotifications() {
        guard let currentUser = Api.user.CURRENT_USER else {
            return
        }
        Api.notification.observeNotification(withId: currentUser.uid, completion: {
            notification in
            guard let uid = notification.from else {
                return
            }
            
            self.fetchUser(uid: uid, completed: {
                self.notifications.insert(notification, at: 0)
                self.tableView.reloadData()
            })
        })
    }
    
    func fetchUser(uid: String, completed: @escaping () -> Void) {
        
        Api.user.observeUser(withId: uid, completion: {
            user in
            self.users.insert(user, at: 0)
            completed()
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ActivityToDetailSegue" {
            let detailVC = segue.destination as! DetailVC
            let postId = sender as! String
            detailVC.postId = postId
        }
        if segue.identifier == "ActivityToProfileSegue" {
            let profileVC = segue.destination as! ProfileUserVC
            let userId = sender  as! String
            profileVC.userId = userId
        }
        
        if segue.identifier == "ActivityToCommentSegue" {
            let commentVC = segue.destination as! CommentVC
            let postId = sender  as! String
            commentVC.postId = postId
        }
    }

}

extension ActivityVC: UITableViewDataSource {
    
    // TABLE VIEW CODE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath) as! ActivityTableViewCell
        
        let notification = notifications[indexPath.row]
        let user = users[indexPath.row]
        cell.notification = notification
        cell.user = user
        cell.delegate = self
        return cell
    }
}

extension ActivityVC: ActivityTableViewCellDelegate {
    func goToDetailVC(postId: String) {
        performSegue(withIdentifier: "ActivityToDetailSegue", sender: postId)
    }
    func goToProfileVC(userId: String) {
        performSegue(withIdentifier: "ActivityToProfileSegue", sender: userId)
    }
    func goToCommentVC(postId: String) {
        performSegue(withIdentifier: "ActivityToCommentSegue", sender: postId)
    }
}
