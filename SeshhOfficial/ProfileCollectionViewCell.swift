//
//  ProfileCollectionViewCell.swift
//  SeshhOfficial
//
//  Created by User on 12/04/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit

protocol ProfileCollectionViewCellDelegate {
    func goToDetailVC(postId: String)
}

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImgView: UIImageView!
    
    var delegate: ProfileCollectionViewCellDelegate?
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
        let tapGestureForCellImgView = UITapGestureRecognizer(target: self, action: #selector(self.cellImgViewPressed))
        cellImgView.addGestureRecognizer(tapGestureForCellImgView)
        cellImgView.isUserInteractionEnabled = true
    }
    
    func cellImgViewPressed() {
        if let id = post?.id {
            delegate?.goToDetailVC(postId: id)
        }
    }
}
