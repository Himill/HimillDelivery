//
//  BaseViewController.swift
//  HimillDelivery
//
//  Created by PatatoAlchemist on 2017/6/13.
//  Copyright © 2017年 Himill. All rights reserved.
//

import UIKit
import SVProgressHUD
import AudioToolbox

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
    
    // 弹出title和message的alert.
    public func showAlert(titleString: String?, messageString: String?) {
        let alertController = UIAlertController.init(title: titleString, message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // alert的“确定”带有回调.
    public func showAlert(titleString: String?, messageString: String?, actionBlock: ((Any?) -> Void)?) {
        let alertController = UIAlertController.init(title: titleString, message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: actionBlock)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // “确定”和“取消”都具有回调.
    public func showAlert(titleString: String?, messageString: String?, okAction: ((Any?) -> Void)?, cancelAction: ((Any?) -> Void)?) {
        let alertController = UIAlertController.init(title: titleString, message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default, handler: okAction)
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.default, handler: cancelAction)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 不含有“确定”和“取消”, 但是延时执行finishedBlock.
    public func showAlert(titleString: String?, messageString: String?, dismissTime: TimeInterval, finishedBlock: (() -> Void)?) {
        let alertController = UIAlertController.init(title: titleString, message: messageString, preferredStyle: UIAlertControllerStyle.alert)
        
        self.present(alertController, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dismissTime, execute: finishedBlock!)
    }
    
    
    // MARK: - 播放声音相关
    
    // 播放提示音.
    public func systemAlert() {
        let soundID:SystemSoundID = 1007    // deng deng deng.
        AudioServicesPlayAlertSound(soundID)
    }
    
    
    // MARK: - 通知
    
    public func popNotification(message: String) {
        
        if #available(iOS 10.0, *) {
            
//            // 1. 创建通知内容
//            let content = UNMutableNotificationContent()
//            content.title = "title"
//            content.body = "body"
//            content.subtitle = "subTile"
//            
//            // 2. 创建发送触发
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//            
//            // 3. 发送请求标识符
//            let requestIdentifier = "com.himill.HimillDelivery"
//            
//            // 4. 创建一个发送请求
//            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
//            
//            // 将请求添加到发送中心
//            UNUserNotificationCenter.current().add(request) { error in
//                if error == nil {
//                    print("Time Interval Notification scheduled: \\\\(requestIdentifier)")
//                }
//            }
            
            let content = UNMutableNotificationContent()
            content.title = "Hello"
            content.body = "有新的订单"
            content.sound = UNNotificationSound.default()
            // Deliver the notification in five seconds.
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger) // Schedule the notification.
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error : Error?) in
                if error == nil {
                    // Handle any errors
                    print("send noti success!")
                }
            }
            
        } else {
            // Fallback on earlier versions
        }
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

extension BaseViewController: UNUserNotificationCenterDelegate {

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 处理完成后条用 completionHandler ，用于指示在前台显示通知的形式
        completionHandler(.alert)
        print(notification)
    }
}
