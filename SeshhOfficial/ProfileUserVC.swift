//
//  ProfileUserVC.swift
//  SeshhOfficial
//
//  Created by User on 20/04/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit

class ProfileUserVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var user: User!
    var posts: [Post] = []
    var userId = ""
    var delegate: HeaderProfileCollectionReusableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchUser()
        fetchMyPosts()
        
    }
    
    func fetchUser() {
        Api.user.observeUser(withId: userId) { (user) in
            self.isFollowing(userId: user.id!, completed: {
                (value) in
                user.isFollowing = value
                self.user = user
                self.navigationItem.title = user.username
                self.collectionView.reloadData()
            })
        }
    }
    
    func isFollowing(userId: String, completed: @escaping (Bool) -> Void) {
        Api.Follow.isFollowing(userId: userId, completed: completed)
    }
    
    func fetchMyPosts() {
        Api.myPosts.fetchMyPosts(userId: userId) { (key) in
            Api.post.observePost(withId: key, completion: {
                post in
                self.posts.append(post)
                self.collectionView.reloadData()
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "ProfileUserToDetailSegue" {
            let detailVC = segue.destination as! DetailVC
            let postId = sender as! String
            detailVC.postId = postId
        }
    }
}

extension ProfileUserVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
        let post = posts[indexPath.row]
        cell.post = post
        cell.delegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderProfileCollectionReusableView", for: indexPath) as! HeaderProfileCollectionReusableView
        if let user = self.user {
            headerViewCell.user = user
            headerViewCell.delegate = delegate
            headerViewCell.delegate2 = self

        }
        //        headerViewCell.updateView()
        return headerViewCell
    }
}

extension ProfileUserVC: HeaderProfileCollectionReusableViewDelegateSwitchSettingTVC {
    func goToSettingsTVC() {
        performSegue(withIdentifier: "ProfileUserToSettingsSegue", sender: nil)
    }
}

extension ProfileUserVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3 - 1, height: collectionView.frame.size.width / 3 - 1)
    }
}

extension ProfileUserVC: ProfileCollectionViewCellDelegate {
    func goToDetailVC(postId: String) {
        performSegue(withIdentifier: "ProfileUserToDetailSegue", sender: postId)
    }
}
