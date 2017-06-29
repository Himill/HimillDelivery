//
//  PopMenuViewController.swift
//  HimillDelivery
//
//  Created by PatatoAlchemist on 2017/6/15.
//  Copyright © 2017年 Himill. All rights reserved.
//

import UIKit

private let optionCount: NSInteger = 4

class PopMenuViewController: BaseViewController {
    
    @IBOutlet weak var userHeadImageView: UIImageView!
    @IBOutlet weak var userPhoneNumberLabel: UILabel!
    
    @IBAction func workOnButtonClicked(_ sender: Any) {
    }
    
    @IBAction func workOffButtonClicked(_ sender: Any) {
    }
    
    
    @IBOutlet weak var optionsTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.optionsTableView.dataSource = self
        self.optionsTableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: - Table view data source / delegate

extension PopMenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId: String = "PopMenuOptionTableViewCell"
        let cell: PopMenuOptionTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellId) as! PopMenuOptionTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        var imageName: String = ""
        var labelName: String = ""
        
        switch indexPath.row {
        case 0:
            imageName = "index_icon_finished_default"
            labelName = "已完成订单"
            break
        case 1:
            imageName = "index_icon_money_default"
            labelName = "订单结算"
            break
        case 2:
            imageName = "index_icon_agreement_default"
            labelName = "规则中心"
            break
        case 3:
            imageName = "index_icon_setting_default"
            labelName = "设置"
            break
        default:
            break
        }
        
        cell.iconImageView.image = UIImage.init(named: imageName)
        
        cell.optionLabel.text = labelName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            // 已完成订单
            let destinyViewController: OrderFinishedViewController = self.getViewController(storyboardName: "OrderFinished", viewControllerId: "SID_OrderFinishedViewController") as! OrderFinishedViewController
            self.navigationController?.pushViewController(destinyViewController, animated: true)
            break
        case 1:
            // 订单结算
            let destinyViewController: SettlementViewController = self.getViewController(storyboardName: "Settlement", viewControllerId: "SID_SettlementViewController") as! SettlementViewController
            self.navigationController?.pushViewController(destinyViewController, animated: true)
            break
        case 2:
            // 规则中心
            
            break
        case 3:
            // 设置
            let destinyViewController: SettingsViewController = self.getViewController(storyboardName: "Settings", viewControllerId: "SID_SettingsViewController") as! SettingsViewController
            self.navigationController?.pushViewController(destinyViewController, animated: true)
            
            break
        default:
            break
        }
    }
}
