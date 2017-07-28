//
//  Constant.swift
//  HimillDelivery
//
//  Created by PatatoAlchemist on 2017/6/14.
//  Copyright © 2017年 Himill. All rights reserved.
//

import UIKit

final class Constant: NSObject {
    
    static let sharedInstance = Constant()
    
    private override init() {}
    
    // MARK: - 通用字符串
    
    public let kResponseSuccessString = "success"
    
    
    // MARK: - 屏幕宽高
    
    public let kScreenWidht = UIScreen.main.bounds.width
    
    public let kScreenHeight = UIScreen.main.bounds.height
    
    
    // MARK: - 颜色
    
    public let kGreenColor: UIColor = UIColor.init(colorLiteralRed: 0.0, green: 166.0/255.0, blue: 81.0/255.0, alpha: 1.0)
    
    public let kRedColor: UIColor = UIColor.init(red: 255.0/255.0, green: 24.0/255.0, blue: 0.0, alpha: 1.0)
    
    public let kBlackDarkFontColor: UIColor = UIColor.init(red: 50.0/255.0, green: 50.0/255.0, blue: 50.0/255.0, alpha: 1.0)
    
    public let kBlackMiddleFontColor: UIColor = UIColor.init(red: 101.0/255.0, green: 101.0/255.0, blue: 101.0/255.0, alpha: 1.0)
    
    public let kBlackLightFontColor: UIColor = UIColor.init(red: 152.0/255.0, green: 152.0/255.0, blue: 152.0/255.0, alpha: 1.0)
    
    
    // MARK: - 极光推送
    
    public let kJPushAppKey: String = "08a404d1992d8c049c887ccc"
    
    
    // MARK: - 短信相关
    
    public let kSMSAppKey: String = "1fae9978f7ffc"
    
    public let kSMSAppSecret: String = "68d0410d958690f663c7dbed88eb2aeb"
    
    
    // MARK: - 百度地图
    
    public let kBaiduMapApiKey: String = "4bqKSKHHIIMuxqMoRI8d7FBuQhI74dvx"
    
}
