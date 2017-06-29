//
//  DistributionTableViewCell.swift
//  HimillDelivery
//
//  Created by PatatoAlchemist on 2017/6/21.
//  Copyright © 2017年 Himill. All rights reserved.
//

import UIKit

class DistributionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var orderNumberLabel: UILabel!
    
    @IBOutlet weak var goodsListTableView: UITableView!
    
    @IBOutlet weak var toInfoLabel: UILabel!
    @IBOutlet weak var toAddressLabel: UILabel!
    
    @IBOutlet weak var phoneCallButton: UIButton!
    
    @IBOutlet weak var completeButtonView: UIView!
    @IBOutlet weak var completeButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.completeButtonView.layer.cornerRadius = 6.0
        self.completeButtonView.layer.borderColor = UIColor.clear.cgColor
        self.completeButtonView.layer.borderWidth = 1.0
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
