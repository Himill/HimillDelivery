//
//  DashboardViewController.swift
//  HimillDelivery
//
//  Created by PatatoAlchemist on 2017/6/15.
//  Copyright © 2017年 Himill. All rights reserved.
//

import UIKit
import SideMenu
import MJRefresh
import Alamofire

class DashboardViewController: BaseViewController {
    
    @IBOutlet weak var topOptionsView: TopOptionsView!
    
    @IBOutlet weak var tasksTableView: UITableView!
    
    @IBOutlet weak var notAuditView: UIView!
    
    @IBOutlet weak var commitAuditButton: UIButton!
    
    
    var newTasksDataArray: NSMutableArray?
    var toPickUpDataArray: NSMutableArray?
    var toPickUpInsideTableViewHeightArray: NSMutableArray?
    var distributionDataArray: NSMutableArray?
    
    var topViewStatus: TopOptions = TopOptions.newTask
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        SideMenuManager.menuPresentMode = SideMenuManager.MenuPresentMode.menuSlideIn
        SideMenuManager.menuAnimationFadeStrength = 0.3
        SideMenuManager.menuFadeStatusBar = false
        
        self.configAuditForView()
        self.configTableView()
        
        // testing.
        self.testingForRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.getUserAudit() {
            self.notAuditView.isHidden = true
            self.commitAuditButton.isHidden = true
            self.topOptionsView.isHidden = false
            self.tasksTableView.isHidden = false
        } else {
            self.notAuditView.isHidden = false
            self.commitAuditButton.isHidden = false
            self.topOptionsView.isHidden = true
            self.tasksTableView.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tasksTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    // MARK: - Private method
    
    private func getUserAudit() -> Bool {
        return true
    }
    
    private func configAuditForView() {
        self.commitAuditButton.layer.cornerRadius = 3.0
        self.commitAuditButton.layer.borderColor = UIColor.clear.cgColor
        self.commitAuditButton.layer.borderWidth = 1.0
        
        self.commitAuditButton.addTarget(self, action: #selector(commitAuditButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
        
        self.topOptionsView.delegate = self
    }
    
    @objc private func commitAuditButtonClicked(sender: UIButton) {
        let auditViewController: AuditViewController = self.getViewController(storyboardName: "Audit", viewControllerId: "SID_AuditViewController") as! AuditViewController
        self.navigationController?.pushViewController(auditViewController, animated: true)
    }
    
    private func configTableView() {
        self.tasksTableView.dataSource = self
        self.tasksTableView.delegate = self
        
        self.tasksTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(pullLoadNewData))
    }
    
    @objc private func pullLoadNewData() {
        // testing.
        self.perform(#selector(delayToFinishPullRefreshing), with: self, afterDelay: 1.0)
    }
    
    private func pullLoadingFinished() {
        self.tasksTableView.mj_header.endRefreshing()
    }
    
    // testing.
    @objc private func delayToFinishPullRefreshing() {
        self.pullLoadingFinished()
    }
    
    // testing.
    private func testingForRequest() {
        let params = ["username": "18612870076",
                      "password": "1234"]
        
        self.showProgressHUD(message: nil)
        
//        BaseService.shareInstance.request(requestType: .Post, url: "http://47.93.169.247/yyyshopping/app/login/submit.jhtml", parameters: params, succeed: { (responseObject) in
//            print("success")
//            self.hideProgressHUD()
//        }) { (error) in
//            print("error: %s", error!)
//            self.hideProgressHUD()
//        }
        
        
        Alamofire.request("http://47.93.169.247/yyyshopping/app/login/submit.jhtml", method: .post, parameters: params).responseJSON { (response) in
            guard let result = response.result.value else {
                print(response.result.error!)
                self.hideProgressHUD()
                return
            }
            
            self.hideProgressHUD()
            print(result)
        }
        
    }
    
    fileprivate func initTestingData() {
        let testingDataArray: NSArray = [["orderNumber": "111111", "goods": [["name": "哈哈", "count": "2"],
                                                                             ["name": "呵呵", "count": "1"],
                                                                             ["name": "哈哈哈哈", "count": "4"]]],
                                         ["orderNumber": "222222", "goods": [["name": "大米", "count": "2"],
                                                                             ["name": "小米", "count": "11"],
                                                                             ["name": "大豆", "count": "99"],
                                                                             ["name": "黑米", "count": "5"],
                                                                             ["name": "牛肉", "count": "111"]]]]
        
        self.toPickUpDataArray = NSMutableArray.init(array: testingDataArray)
        
        self.caculateHeightsForPickUpDataSource()
    }
    
    fileprivate func caculateHeightsForPickUpDataSource() {
        if (self.toPickUpDataArray?.count)! > 0 {
            let unitCellHeight: Int = 38
            
            if self.toPickUpInsideTableViewHeightArray == nil {
                self.toPickUpInsideTableViewHeightArray = NSMutableArray.init()
            }
            
            self.toPickUpInsideTableViewHeightArray?.removeAllObjects()
            
            let goodsCount: Int = (self.toPickUpDataArray?.count)!
            for i in 0...goodsCount - 1 {
                let orderInfo: Dictionary<String, Any> = self.toPickUpDataArray?.object(at: i) as! Dictionary
                let goodsArray: NSArray = orderInfo["goods"] as! NSArray
                let cellHeight: Int = unitCellHeight * goodsArray.count
                self.toPickUpInsideTableViewHeightArray?.add((cellHeight))
            }
        }
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


extension DashboardViewController: TopOptionsViewDelegate {

    func topOptionsButtonClicked(whichOption: TopOptions) {
        switch whichOption {
        case .newTask:
            self.topViewStatus = TopOptions.newTask
            
            break
        case .toPickUp:
            self.topViewStatus = TopOptions.toPickUp
            
            self.initTestingData()
            
            break
        case .distribution:
            self.topViewStatus = TopOptions.distribution
            
            // testing: 暂时使用取货数据源.
            self.initTestingData()
            
            break
        }
        
        self.tasksTableView.reloadData()
    }
}


extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.topViewStatus {
        case .newTask:
            
            return 3
            
        case .toPickUp:
            
            return (self.toPickUpDataArray?.count)!
            
        case .distribution:
        
            // testing: 数据源暂时使用取货的.
            return (self.toPickUpDataArray?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.topViewStatus {
        case .newTask:
            
            return 255
            
        case .toPickUp:
            
            let goodsCellHeight: CGFloat = CGFloat(Float(self.toPickUpInsideTableViewHeightArray?.object(at: indexPath.row) as! Int))
            
            return 212 + goodsCellHeight
            
        case .distribution:
            
            let goodsCellHeight: CGFloat = CGFloat(Float(self.toPickUpInsideTableViewHeightArray?.object(at: indexPath.row) as! Int))
            
            return 162 + goodsCellHeight
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.topViewStatus {
        case .newTask:
            
            let cellId: String = "NewTaskTableViewCell"
            
            let cell: NewTaskTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellId) as! NewTaskTableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.grabOrderButton.addTarget(self, action: #selector(grabOrderButtonClicked(cellIndex:)), for: UIControlEvents.touchUpInside)
            
            return cell
            
        case .toPickUp:
            
            let cellId: String = "ToPickUpTableViewCell"
            
            let cell: ToPickUpTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ToPickUpTableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.tableViewHeight.constant = CGFloat(Float(self.toPickUpInsideTableViewHeightArray?.object(at: indexPath.row) as! Int))
            cell.topViewHeight.constant = CGFloat(Float(self.toPickUpInsideTableViewHeightArray?.object(at: indexPath.row) as! Int)) + 38
            
            let orderInfo: Dictionary<String, Any> = self.toPickUpDataArray?.object(at: indexPath.row) as! Dictionary
            
            cell.orderNumberLabel.text = orderInfo["orderNumber"] as? String
            
            let goodsInTasksDataSource: GoodsInTasksTableViewDataSource = GoodsInTasksTableViewDataSource()
            goodsInTasksDataSource.goodsInfoArray = NSMutableArray.init(array: (orderInfo["goods"] as! NSArray))
            
            cell.setListDataSource(dataSource: goodsInTasksDataSource)
            
            cell.pickUpButton.addTarget(self, action: #selector(pickUpButtonClicked(cellIndex:)), for: UIControlEvents.touchUpInside)
            
            return cell
            
        case .distribution:
            
            let cellId: String = "DistributionTableViewCell"
            
            let cell: DistributionTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellId) as! DistributionTableViewCell
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.tableViewHeight.constant = CGFloat(Float(self.toPickUpInsideTableViewHeightArray?.object(at: indexPath.row) as! Int))
            cell.topViewHeight.constant = CGFloat(Float(self.toPickUpInsideTableViewHeightArray?.object(at: indexPath.row) as! Int)) + 38
            
            let orderInfo: Dictionary<String, Any> = self.toPickUpDataArray?.object(at: indexPath.row) as! Dictionary
            
            cell.orderNumberLabel.text = orderInfo["orderNumber"] as? String
            
            let goodsInTasksDataSource: GoodsInTasksTableViewDataSource = GoodsInTasksTableViewDataSource()
            goodsInTasksDataSource.goodsInfoArray = NSMutableArray.init(array: (orderInfo["goods"] as! NSArray))
            
            cell.setListDataSource(dataSource: goodsInTasksDataSource)
            
            cell.completeButton.addTarget(self, action: #selector(completeButtonButtonClicked(cellIndex:)), for: UIControlEvents.touchUpInside)
            
            return cell
        }
    }
    
    
    
    @objc private func grabOrderButtonClicked(cellIndex: Int) {
        
    }
    
    @objc private func pickUpButtonClicked(cellIndex: Int) {
        
    }
    
    @objc private func completeButtonButtonClicked(cellIndex: Int) {
        
    }
    
}

