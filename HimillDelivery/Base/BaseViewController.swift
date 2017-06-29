//
//  BaseViewController.swift
//  HimillDelivery
//
//  Created by PatatoAlchemist on 2017/6/13.
//  Copyright © 2017年 Himill. All rights reserved.
//

import UIKit
import SVProgressHUD

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - 弹出提示框
    
    public func showAlert(titleString: String, messageString: String) {
        let alertController = UIAlertController.init(title: titleString, message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    public func showAlert(titleString: String, messageString: String, actionBlock: ((Any?) -> Void)?) {
        let alertController = UIAlertController.init(title: titleString, message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: actionBlock)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    public func showAlert(titleString: String, messageString: String, okAction: ((Any?) -> Void)?, cancelAction: ((Any?) -> Void)?) {
        let alertController = UIAlertController.init(title: titleString, message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: okAction)
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.default, handler: cancelAction)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - 加载框
    
    public func showProgressHUD(message: String?) {
        if message != nil && message != "" {
            SVProgressHUD.show()
        } else {
            SVProgressHUD.show(withStatus: message)
        }
    }
    
    public func hideProgressHUD() {
        SVProgressHUD.dismiss()
    }
    
    
    // MARK: - 跳转界面相关
    
    public func getViewController(storyboardName: String, viewControllerId: String) -> UIViewController {
        let storyboard = UIStoryboard.init(name: storyboardName, bundle: nil)
        let destinationViewController = storyboard.instantiateViewController(withIdentifier: viewControllerId)
        return destinationViewController
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
