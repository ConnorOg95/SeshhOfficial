//
//  SearchVC.swift
//  SeshhOfficial
//
//  Created by User on 19/04/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    var searchBar = UISearchBar()
    var users: [User] = []
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.frame.size.width = view.frame.size.width - 60
        
        
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = searchItem
        
        doSearch()
    }
    
    func doSearch() {
        if let searchTxt = searchBar.text?.lowercased() {
            self.users.removeAll()
            self.tableView.reloadData()
            Api.user.queryUsers(withText: searchTxt, completion: { (user) in
                self.isFollowing(userId: user.id!, completed: {
                    (value) in
                    user.isFollowing = value
                    self.users.append(user)
                    self.tableView.reloadData()
                })
            })
        }
    }
    
    func isFollowing(userId: String, completed: @escaping (Bool) -> Void) {
        Api.Follow.isFollowing(userId: userId, completed: completed)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SearchToProfileSegue" {
            let profileVC = segue.destination as! ProfileUserVC
            let userId = sender as! String
            profileVC.userId = userId
        }
    }
    
}

extension SearchVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        doSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        doSearch()
    }
}

extension SearchVC: UITableViewDataSource {
    
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

extension SearchVC: BuddiesTableViewCellDelegate {
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "SearchToProfileSegue", sender: userId)
    }
}

extension SearchVC: HeaderProfileCollectionReusableViewDelegate {
    func updateFollowBtn(forUser user: User) {
        for u in self.users {
            if u.id == user.id {
                u.isFollowing = user.isFollowing
                self.tableView.reloadData()
            }
        }
    }
}
