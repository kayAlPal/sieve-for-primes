//
//  CustomTableViewCell.swift
//  L11kalonso
//
//  Created by Kelly Alonso-Palt on 10/27/15.
//  Copyright © 2015 Kelly Alonso. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {


    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var levelLabel: UILabel!

    @IBOutlet var selfieSpot: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
