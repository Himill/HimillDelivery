//
//  AppDelegate.swift
//  HimillDelivery
//
//  Created by PatatoAlchemist on 2017/6/13.
//  Copyright © 2017年 Himill. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, JPUSHRegisterDelegate, BMKGeneralDelegate {

    var window: UIWindow?
    
    var mapManager: BMKMapManager?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window?.rootViewController = self.getDefaultViewController()
        
        // 注册通知.
        if #available(iOS 8.0, *) {
            let uns = UIUserNotificationSettings(types: [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(uns)
        }
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (granted, error) in
                if granted {
                    print("用户允许")
                } else {
                    print("用户不允许")
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
        // 通知注册实体类.
//        self.initJPush(launchOptions: launchOptions)
        
        // 百度地图.
        self.initBaiduMapManager()
        
        // 短信.
        self.initSMSSDK()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    // MARK: - 新增
    
    private func getDefaultViewController() -> UIViewController {
        let loginStoryboard: UIStoryboard = UIStoryboard.init(name: "Login", bundle: nil)
        let dashboardStoryboard: UIStoryboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        
        var defaultViewController: UIViewController?
        
        let currentUserData: UserData = UserData.sharedInstance
        if currentUserData.checkIsLogin() {
            
            defaultViewController = dashboardStoryboard.instantiateViewController(withIdentifier: "SID_DashboardNavigationController")
        } else {
            
            defaultViewController = loginStoryboard.instantiateViewController(withIdentifier: "SID_LoginNavigationController")
        }
        
        return defaultViewController!
    }
    
    
    // MARK: - JPUSHRegisterDelegate
    
    private func initJPush(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        let entity = JPUSHRegisterEntity();
        entity.types = Int(JPAuthorizationOptions.alert.rawValue) |  Int(JPAuthorizationOptions.sound.rawValue) |  Int(JPAuthorizationOptions.badge.rawValue);
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self);
        // 注册极光推送
        JPUSHService.setup(withOption: launchOptions, appKey: Constant.sharedInstance.kJPushAppKey, channel:"Publish channel" , apsForProduction: false);
        // 获取推送消息
        let remote = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? Dictionary<String,Any>;
        // 如果remote不为空，就代表应用在未打开的时候收到了推送消息
        if remote != nil {
            // 收到推送消息实现的方法
            self.perform(#selector(receivePush), with: remote, afterDelay: 1.0);
        }
    }
    
    // iOS 10.x 需要
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        
        let userInfo = notification.request.content.userInfo;
        if notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo);
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        
        let userInfo = response.notification.request.content.userInfo;
        if response.notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo);
        }
        completionHandler();
        // 应用打开的时候收到推送消息
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        JPUSHService.handleRemoteNotification(userInfo);
        completionHandler(UIBackgroundFetchResult.newData);
    }
    
    // 接收到推送实现的方法
    func receivePush(_ userInfo : Dictionary<String,Any>) {
        
    }
    
    
    // MARK: - Baidu地图
    
    private func initBaiduMapManager() {
        self.mapManager = BMKMapManager()
        
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = self.mapManager?.start(Constant.sharedInstance.kBaiduMapApiKey, generalDelegate: self as BMKGeneralDelegate)
        if ret == false {
            print("baidu map manager start failed!")
        }
    }
    
    
    // MARK: - 短信注册
    
    private func initSMSSDK() {
    
        // 初始化sdk.
        SMSSDK.registerApp(Constant.sharedInstance.kSMSAppKey, withSecret: Constant.sharedInstance.kSMSAppSecret)

        // 禁用通讯录功能.
        SMSSDK.enableAppContactFriends(false)
    }

}



