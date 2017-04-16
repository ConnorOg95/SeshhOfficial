//
//  ProfileCollectionViewCell.swift
//  SeshhOfficial
//
//  Created by User on 12/04/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImgView: UIImageView!
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let photoUrlString = post?.photoUrl {
            let photoUrl = URL(string: photoUrlString)
            cellImgView.sd_setImage(with: photoUrl)
        }
    }
}
