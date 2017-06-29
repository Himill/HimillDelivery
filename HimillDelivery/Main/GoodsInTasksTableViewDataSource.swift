//
//  GoodsInTasksTableViewDataSource.swift
//  HimillDelivery
//
//  Created by PatatoAlchemist on 2017/6/21.
//  Copyright © 2017年 Himill. All rights reserved.
//

import UIKit

class GoodsInTasksTableViewDataSource: NSObject {

    public var goodsInfoArray: NSMutableArray?
    
}


extension GoodsInTasksTableViewDataSource: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (goodsInfoArray?.count)!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId: String = "GoodsInTasksTableViewCell"
        
        let cell: GoodsInTasksTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellId) as! GoodsInTasksTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let goodInfo: Dictionary<String, Any> = self.goodsInfoArray?.object(at: indexPath.row) as! Dictionary
        
        cell.goodsNameLabel.text = goodInfo["name"] as? String
        cell.goodsCountLabel.text = "× " + (goodInfo["count"] as? String)!

        return cell
    }
}
