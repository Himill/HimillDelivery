//
//  SettlementViewController.swift
//  HimillDelivery
//
//  Created by PatatoAlchemist on 2017/6/19.
//  Copyright © 2017年 Himill. All rights reserved.
//

import UIKit

class SettlementViewController: BaseViewController {
    
    @IBOutlet weak var totalCountLabel: UILabel!
    
    @IBOutlet weak var settlementButtonView: UIView!
    
    @IBOutlet weak var settlementTableView: UITableView!
    
    
    var settlementDataArray: NSMutableArray?
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func settlementButtonClicked(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initDataSource()
        self.configUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Private method
    
    func configUI() {
        self.settlementButtonView.layer.cornerRadius = 6.0
        self.settlementButtonView.layer.borderColor = Constant.sharedInstance.kGreenColor.cgColor
        self.settlementButtonView.layer.borderWidth = 2.0
        
        self.totalCountLabel.text = "12单"
        self.handleMixedLabel(label: self.totalCountLabel)
    }
    
    func initDataSource() {
        let testingData = [["date": "2017年5月20日", "status": "结算中", "count": "10"],
                           ["date": "2017年5月24日", "status": "已结算", "count": "11"],
                           ["date": "2017年5月26日", "status": "已结算", "count": "15"]]
        
        self.settlementDataArray = NSMutableArray.init(array: testingData)
        
        self.settlementTableView.dataSource = self
        self.settlementTableView.delegate = self
    }
    
    func handleMixedLabel(label: UILabel) {
        let stringLength: Int = (label.text?.characters.count)!
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString.init(string: label.text!)
        
        let biggerFont: UIFont = UIFont.systemFont(ofSize: 28.0)
        let smallerFont: UIFont = UIFont.systemFont(ofSize: 14.0)
        
        if stringLength >= 2 {
            
            attributedString.addAttributes([NSFontAttributeName : biggerFont], range: NSMakeRange(0, stringLength - 1))
            
            attributedString.addAttributes([NSFontAttributeName : smallerFont], range: NSMakeRange(stringLength - 1, 1))
        }
        
        label.attributedText = attributedString
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


extension SettlementViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.settlementDataArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId: String = "SettlementTableViewCell"
        
        let cell: SettlementTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellId) as! SettlementTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        var dataDictinary: Dictionary<String, String> = self.settlementDataArray?[indexPath.row] as! Dictionary
        
        cell.dateLabel.text = dataDictinary["date"]
        
        cell.statusLabel.text = dataDictinary["status"]
        
        cell.countLabel.text = "结算" + dataDictinary["count"]! + "单"
        
        return cell
    }
}
