//
//  DiscoverVC.swift
//  SeshhOfficial
//
//  Created by User on 20/04/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit

class DiscoverVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Discover"
        collectionView.dataSource = self
        collectionView.delegate = self
        loadTopPosts()

    }
    @IBAction func refreshBtnPressed(_ sender: Any) {
        loadTopPosts()
    }
    
    func loadTopPosts() {
        ProgressHUD.show("Loading...", interaction: false)
        self.posts.removeAll()
        self.collectionView.reloadData()
        Api.post.observeTopPosts { (post) in
            self.posts.append(post)
            self.collectionView.reloadData()
            ProgressHUD.dismiss()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DiscoverToDetailSegue" {
            let detailVC = segue.destination as! DetailVC
            let postId = sender as! String
            detailVC.postId = postId
        }
    }

}

extension DiscoverVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
        let post = posts[indexPath.row]
        cell.post = post
        cell.delegate = self
        return cell
    }
}

extension DiscoverVC: UICollectionViewDelegateFlowLayout {
    
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

extension DiscoverVC: ProfileCollectionViewCellDelegate {
    func goToDetailVC(postId: String) {
        performSegue(withIdentifier: "DiscoverToDetailSegue", sender: postId)
    }
}

