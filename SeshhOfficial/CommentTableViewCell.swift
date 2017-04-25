//
//  CommentTableViewCell.swift
//  SeshhOfficial
//
//  Created by User on 27/03/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit
protocol CommentTableViewCellDelegate {
    func goToProfileUserVC(userId: String)
}

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var commentLbl: UILabel!
    
    var delegate: CommentTableViewCellDelegate?
    var comment: Comment? {
        didSet {
            updateView()
        }
    }
    
    var user: User? {
        didSet {
            setupUserInfo()
        }
    }
    
    func updateView() {
        commentLbl.text = comment?.commentTxt
    }
    
    func setupUserInfo() {
        
        nameLbl.text = user?.username
        if let photoUrlString = user?.profileImgUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImgView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImg"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLbl.text = ""
        commentLbl.text = ""
        let tapGestureForNameLbl = UITapGestureRecognizer(target: self, action: #selector(self.nameLblPressed))
        nameLbl.addGestureRecognizer(tapGestureForNameLbl)
        nameLbl.isUserInteractionEnabled = true
    }
    
    func nameLblPressed() {
        if let id = user?.id {
            delegate?.goToProfileUserVC(userId: id)
        }
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImgView.image = UIImage(named: "placeholderImg")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
