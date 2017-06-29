//
//  OrderFinishedViewController.swift
//  HimillDelivery
//
//  Created by PatatoAlchemist on 2017/6/19.
//  Copyright © 2017年 Himill. All rights reserved.
//

import UIKit

class OrderFinishedViewController: BaseViewController {
    
    @IBOutlet weak var orderListTableView: UITableView!
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var orderDataSource: NSMutableArray?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initDataSource()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Private method
    
    func initDataSource() {
        let testingData = [["orderNumber": "11110000", "startDate": "2017年6月10日 15:00:03", "finishDate": "2017年6月10日 15:54:17"],
                           ["orderNumber": "22221111", "startDate": "2017年6月12日 10:10:15", "finishDate": "2017年6月10日 10:44:02"],
                           ["orderNumber": "64512321", "startDate": "2017年6月12日 15:20:13", "finishDate": "2017年6月10日 15:34:33"]]
        
        self.orderDataSource = NSMutableArray.init(array: testingData)
        
        self.orderListTableView.dataSource = self
        self.orderListTableView.delegate = self
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


extension OrderFinishedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.orderDataSource?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId: String = "OrderFinishedTableViewCell"
        
        let cell: OrderFinishedTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellId) as! OrderFinishedTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        var dataDictinary: Dictionary<String, String> = self.orderDataSource?[indexPath.row] as! Dictionary
        
        cell.orderNumberLabel.text = dataDictinary["orderNumber"]
        
        cell.orderStartTimeLabel.text = dataDictinary["startDate"]
        
        cell.orderFinishedTimeLabel.text = dataDictinary["finishDate"]
        
        return cell
    }

}
