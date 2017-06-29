//
//  ToPickUpTableViewCell.swift
//  HimillDelivery
//
//  Created by PatatoAlchemist on 2017/6/20.
//  Copyright © 2017年 Himill. All rights reserved.
//

import UIKit

class ToPickUpTableViewCell: UITableViewCell {
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var orderNumberLabel: UILabel!
    
    @IBOutlet weak var goodsListTableView: UITableView!
    
    @IBOutlet weak var fromInfoLabel: UILabel!
    @IBOutlet weak var fromAddressLabel: UILabel!
    @IBOutlet weak var fromDistanceLabel: UILabel!
    
    @IBOutlet weak var toInfoLabel: UILabel!
    @IBOutlet weak var toAddressLabel: UILabel!
    @IBOutlet weak var toDistanceLabel: UILabel!
    
    @IBOutlet weak var pickUpButtonView: UIView!
    @IBOutlet weak var pickUpButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.pickUpButtonView.layer.cornerRadius = 6.0
        self.pickUpButtonView.layer.borderColor = UIColor.clear.cgColor
        self.pickUpButtonView.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setListDataSource(dataSource: Any) {
        self.goodsListTableView.dataSource = dataSource as? UITableViewDataSource
        self.goodsListTableView.delegate = dataSource as? UITableViewDelegate
        
        self.goodsListTableView.reloadData()
    }

}
