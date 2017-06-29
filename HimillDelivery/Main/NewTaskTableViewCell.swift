//
//  NewTaskTableViewCell.swift
//  HimillDelivery
//
//  Created by PatatoAlchemist on 2017/6/20.
//  Copyright © 2017年 Himill. All rights reserved.
//

import UIKit

class NewTaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var fromInfoLabel: UILabel!
    @IBOutlet weak var fromAddressLabel: UILabel!
    @IBOutlet weak var fromDistanceLabel: UILabel!
    
    @IBOutlet weak var toInfoLabel: UILabel!
    @IBOutlet weak var toAddressLabel: UILabel!
    @IBOutlet weak var toDistanceLabel: UILabel!
    
    @IBOutlet weak var grabOrderView: UIView!
    @IBOutlet weak var grabOrderButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.grabOrderView.layer.cornerRadius = 6.0
        self.grabOrderView.layer.borderColor = UIColor.clear.cgColor
        self.grabOrderView.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
