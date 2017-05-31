//
//  SideMenuTableViewCell.swift
//  SeshhOfficial
//
//  Created by User on 05/05/2017.
//  Copyright © 2017 OGCompany. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sideMenuImg: UIImageView!
    @IBOutlet weak var sideMenuLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
