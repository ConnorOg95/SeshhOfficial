//
//  BuddiesVC.swift
//  SeshhOfficial
//
//  Created by User on 15/04/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit

class BuddiesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUsers()
    }
    
    func loadUsers() {
        Api.user.observeUsers { (user) in
            self.isFollowing(userId: user.id!, completed: {
               (value) in
                user.isFollowing = value
                self.users.append(user)
                self.tableView.reloadData()
            })
        }
    }
    
    func isFollowing(userId: String, completed: @escaping (Bool) -> Void) {
        Api.Follow.isFollowing(userId: userId, completed: completed)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileSegue" {
            let profileVC = segue.destination as! ProfileUserVC
            let userId = sender as! String
            profileVC.userId = userId
            profileVC.delegate = self
        }
    }
}

extension BuddiesVC: UITableViewDataSource {
    
    // TABLE VIEW CODE
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuddiesTableViewCell", for: indexPath) as! BuddiesTableViewCell
        let user = users[indexPath.row]
        cell.user = user 
        cell.delegate = self
        return cell
    }
}

extension BuddiesVC: BuddiesTableViewCellDelegate {
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "ProfileSegue", sender: userId)
    }
}

extension BuddiesVC: HeaderProfileCollectionReusableViewDelegate {
    func updateFollowBtn(forUser user: User) {
        for u in self.users {
            if u.id == user.id {
                u.isFollowing = user.isFollowing
                self.tableView.reloadData()
            }
        }
    }
}
