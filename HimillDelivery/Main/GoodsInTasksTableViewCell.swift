//
//  GoodsInTasksTableViewCell.swift
//  HimillDelivery
//
//  Created by PatatoAlchemist on 2017/6/20.
//  Copyright © 2017年 Himill. All rights reserved.
//

import UIKit

class GoodsInTasksTableViewCell: UITableViewCell {
    
    @IBOutlet weak var goodsNameLabel: UILabel!
    
    @IBOutlet weak var goodsCountLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
