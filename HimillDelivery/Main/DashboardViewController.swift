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
import SwiftyJSON
import Starscream

class DashboardViewController: BaseViewController {
    
    @IBOutlet weak var topOptionsView: TopOptionsView!
    
    @IBOutlet weak var tasksTableView: UITableView!
    
    @IBOutlet weak var notAuditView: UIView!
    @IBOutlet weak var auditDescriptionLabel: UILabel!
    @IBOutlet weak var auditOperationButton: UIButton!
    
    @IBOutlet weak var loadingFailedView: UIView!
    @IBOutlet weak var reloadButton: UIButton!
    
    
    var newTasksDataArray: NSMutableArray?
    var toPickUpDataArray: NSMutableArray?
    var toPickUpInsideTableViewHeightArray: NSMutableArray?
    var distributionDataArray: NSMutableArray?
    
    var topViewStatus: TopOptions = TopOptions.newTask
    
    let kNewTaskCellBasicHeight: CGFloat = 255.0
    let kToPickUpCellBasicHeight: CGFloat = 212.0
    let kDictributionCellBasicHeight: CGFloat = 162.0
    
    // socket.
    var socket: WebSocket?
    var heartBeatTimer: Timer?
    
    // 定位相关.
    var locationService: BMKLocationService = BMKLocationService()
    var currentLocation: CLLocation?
    
    // 用户当前认证状态.(notCheck, checking, checked, checkFaild)，还有个网络请求超时没有获得数据提示刷新(暂定字段为"checkTimeout").
    public var currentAuditStatus: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 登录一次，获取审核状态等相关信息.
        
        // UI先置成未加载的状态.
        self.notAuditView.isHidden = true
        self.auditOperationButton.isHidden = true
        self.topOptionsView.isHidden = true
        self.tasksTableView.isHidden = true
        self.loadingFailedView.isHidden = true
        
        self.requestForLogin()

        SideMenuManager.menuPresentMode = SideMenuManager.MenuPresentMode.menuSlideIn
        SideMenuManager.menuAnimationFadeStrength = 0.3
        SideMenuManager.menuFadeStatusBar = false
        
        self.configAuditForView()
        self.configTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.locationService.delegate = self;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tasksTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.locationService.delegate = nil;
    }
    
    deinit {
        self.socket?.disconnect()
        self.socket?.delegate = nil
        
        self.heartBeatTimer?.invalidate()
    }
    
    
    // MARK: - Private method
    
    private func layoutUIAccordingToAuditStatus() {
        
        if self.currentAuditStatus == "notCheck" {
            
            self.notAuditView.isHidden = false
            self.auditOperationButton.isHidden = false
            self.topOptionsView.isHidden = true
            self.tasksTableView.isHidden = true
            self.loadingFailedView.isHidden = true
            
            self.auditDescriptionLabel.text = "您还未提交身份审核"
        
        } else if self.currentAuditStatus == "checking" {
        
            self.notAuditView.isHidden = false
            self.auditOperationButton.isHidden = false
            self.topOptionsView.isHidden = true
            self.tasksTableView.isHidden = true
            self.loadingFailedView.isHidden = true
            
            self.auditOperationButton.backgroundColor = UIColor.lightGray
            self.auditOperationButton.isEnabled = false
            self.auditOperationButton.setTitle("审核中···", for: UIControlState.normal)
            self.auditDescriptionLabel.text = "正在为您审核"
        
        } else if self.currentAuditStatus == "checked" {
        
            self.notAuditView.isHidden = true
            self.auditOperationButton.isHidden = true
            self.topOptionsView.isHidden = false
            self.tasksTableView.isHidden = false
            self.loadingFailedView.isHidden = true
            
            // 通过审核的用户才能收到订单.
            // socket.
            self.socket = WebSocket(url:NSURL(string:"ws://59.110.87.92/yyyshopping/shippingWebScoket/" + UserData.sharedInstance.userId!)! as URL)
            
            self.socket?.delegate = self
            self.socket?.connect()
        
        } else if self.currentAuditStatus == "checkFaild" {
        
            self.notAuditView.isHidden = false
            self.auditOperationButton.isHidden = false
            self.topOptionsView.isHidden = true
            self.tasksTableView.isHidden = true
            self.loadingFailedView.isHidden = true
            
            self.auditDescriptionLabel.text = "您还未提交身份审核"
            
        } else {    // 加载审核状态失败.
        
            self.notAuditView.isHidden = true
            self.auditOperationButton.isHidden = true
            self.topOptionsView.isHidden = true
            self.tasksTableView.isHidden = true
            self.loadingFailedView.isHidden = false
            
            self.reloadButton.addTarget(self, action: #selector(reloadButtonClicked), for: UIControlEvents.touchUpInside)
            
        }
        
    }
    
    @objc private func reloadButtonClicked() {
    
        self.requestForLogin()
    }
    
    private func configAuditForView() {
        self.auditOperationButton.layer.cornerRadius = 3.0
        self.auditOperationButton.layer.borderColor = UIColor.clear.cgColor
        self.auditOperationButton.layer.borderWidth = 1.0
        
        self.auditOperationButton.addTarget(self, action: #selector(auditOperationButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
        
        self.topOptionsView.delegate = self
    }
    
    @objc private func auditOperationButtonClicked(sender: UIButton) {
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
    
    fileprivate func startHeartBeatTimer() {
        
        self.heartBeatTimer?.invalidate()
        self.heartBeatTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(sendHeartBeat), userInfo: nil, repeats: true)
    }
    
    @objc private func sendHeartBeat() {
    
        socket?.write(string: "heart beat")
        
    }
    
    
    // MARK: - Network
    
    private func requestForLogin() {
        
        self.showProgressHUD(message: nil)
        
        let params: Dictionary<String, String> = ["mobile": UserData.sharedInstance.userPhoneNumber!]
        
        let requestUrlString: String = CommonUrls.sharedInstance.kServerUrl + CommonUrls.sharedInstance.kProjectUrl + CommonUrls.sharedInstance.kLoginUrl
        
        Alamofire.request(requestUrlString, method: .post, parameters: params).responseJSON { (response) in
            
            guard let result = response.result.value else {
                print(response.result.error!)
                self.hideProgressHUD()
                
                self.currentAuditStatus = "checkTimeout"
                self.layoutUIAccordingToAuditStatus()
                
                return
            }
            
            self.hideProgressHUD()
            print(result)
            
            let resultJson = JSON(result)
            
            if resultJson["type"].string == Constant.sharedInstance.kResponseSuccessString {
                
                // 登录成功
                // 存入plist
                UserData.sharedInstance.userId = String(stringInterpolationSegment: resultJson["map"]["courier"]["id"])
                UserData.sharedInstance.userName = resultJson["map"]["courier"]["username"].string ?? ""
                UserData.sharedInstance.userSex = resultJson["map"]["courier"]["gender"].string ?? ""
                UserData.sharedInstance.userCreateDate = resultJson["map"]["courier"]["createDate"].string ?? ""
                UserData.sharedInstance.userEmail = resultJson["map"]["courier"]["email"].string ?? ""
                UserData.sharedInstance.userPhoneNumber = resultJson["map"]["courier"]["mobile"].string ?? ""
                UserData.sharedInstance.userCheckStatus = resultJson["map"]["courier"]["isCheck"].string ?? ""
                
                UserData.sharedInstance.saveUserData()
                
                self.currentAuditStatus = UserData.sharedInstance.userCheckStatus
                
                // 定位.
                self.locationService.startUserLocationService()
                
            } else {
                
                self.hideProgressHUD()
                
                self.currentAuditStatus = "checkTimeout"
            }
            
            // 然后刷新UI.
            self.layoutUIAccordingToAuditStatus()
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
            
            return kNewTaskCellBasicHeight
            
        case .toPickUp:
            
            let goodsCellHeight: CGFloat = CGFloat(Float(self.toPickUpInsideTableViewHeightArray?.object(at: indexPath.row) as! Int))
            
            return kToPickUpCellBasicHeight + goodsCellHeight
            
        case .distribution:
            
            let goodsCellHeight: CGFloat = CGFloat(Float(self.toPickUpInsideTableViewHeightArray?.object(at: indexPath.row) as! Int))
            
            return kDictributionCellBasicHeight + goodsCellHeight
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


extension DashboardViewController: WebSocketDelegate {

    func websocketDidConnect(socket: WebSocket) {
        print("socket did connect!")
        
        // 连接成功发送心跳包.
        self.startHeartBeatTimer()
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        print("socket did receive data: %@", data)
        
        // 收到消息播放提示音.
        self.systemAlert()
        
        // 提示框.
        self.popNotification(message: "您有一条新消息")
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("socket did disconnect!")
        
        // 停止发送心跳包.
        self.heartBeatTimer?.invalidate()
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("socket did receive data: %s", text)
        
        // 收到消息播放提示音.
        self.systemAlert()
        
        // 提示框.
        self.popNotification(message: "您有一条新消息")
    }

}


extension DashboardViewController: BMKLocationServiceDelegate {

    func didUpdate(_ userLocation: BMKUserLocation!) {
        
        self.currentLocation = userLocation.location;
        
        print("current location: ", userLocation.location)
        
    }

}

