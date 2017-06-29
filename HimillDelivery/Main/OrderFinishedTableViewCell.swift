//
//  OrderFinishedTableViewCell.swift
//  HimillDelivery
//
//  Created by PatatoAlchemist on 2017/6/19.
//  Copyright © 2017年 Himill. All rights reserved.
//

import UIKit

class OrderFinishedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderNumberLabel: UILabel!
    
    @IBOutlet weak var orderStartTimeLabel: UILabel!
    @IBOutlet weak var orderFinishedTimeLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
