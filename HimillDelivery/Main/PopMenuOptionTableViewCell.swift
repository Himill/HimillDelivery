//
//  PopMenuOptionTableViewCell.swift
//  HimillDelivery
//
//  Created by PatatoAlchemist on 2017/6/15.
//  Copyright © 2017年 Himill. All rights reserved.
//

import UIKit

class PopMenuOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var optionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
