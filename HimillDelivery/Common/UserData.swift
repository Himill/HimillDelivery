//
//  UserData.swift
//  HimillDelivery
//
//  Created by PatatoAlchemist on 2017/6/14.
//  Copyright © 2017年 Himill. All rights reserved.
//

import UIKit


class UserData: NSObject {
    
    public var userId: String? = ""                          // id
    public var userName: String? = ""                        // 用户名
    public var userEmail: String? = ""                       // 邮箱
    public var userPhoneNumber: String? = ""                 // 电话号码
    public var userCreateDate: String? = ""                  // 创建时间
    public var userIdentifyNumber: String? = ""              // 身份证
    public var userSex: String? = ""                         // 性别
    public var userHeadImageUrl: String? = ""                // 头像
    public var userCheckStatus: String? = ""                 // 验证状态
    
    
    // 审核状态.
    public let kCheckStatusNotChecked: String       = "notCheck"    // 未审核
    public let kCheckStatusChecking: String         = "checking"    // 审核中
    public let kCheckStatusChecked: String          = "checked"     // 审核通过
    public let kCheckStatusCheckFailed: String      = "checkFaild"  // 审核未通过
    
    static let sharedInstance = UserData()
    
    private override init() {}
    
    
    public func loadDataFromPlist() {
        let paths: NSArray = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as NSArray
        let filePath: NSString = paths[0] as! NSString
        let plistPath: String = filePath.appendingPathComponent("UserData.plist")
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath as String) == false {
            self.createUserDataFile()
        }
        
        let userData: NSMutableDictionary = NSMutableDictionary(contentsOfFile: plistPath)!
        
        self.userId = userData.object(forKey: "id") as? String
        self.userName = userData.object(forKey: "userName") as? String
        self.userEmail = userData.object(forKey: "userEmail") as? String
        self.userPhoneNumber = userData.object(forKey: "userPhoneNumber") as? String
        self.userCreateDate = userData.object(forKey: "userCreateDate") as? String
        self.userIdentifyNumber = userData.object(forKey: "userIdentifyNumber") as? String
        self.userSex = userData.object(forKey: "userSex") as? String
        self.userHeadImageUrl = userData.object(forKey: "userHeadImageUrl") as? String
        self.userCheckStatus = userData.object(forKey: "userCheckStatus") as? String
    }
    
    public func checkIsLogin() -> Bool {
        self.loadDataFromPlist()
        
        let userId = self.userId
        if userId == nil || userId == "" {
            return false
        }
        return true
    }
    
    public func clearLoginInfo() {
        let paths: NSArray = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as NSArray
        let filePath: NSString = paths[0] as! NSString
        let plistPath: String = filePath.appendingPathComponent("UserData.plist")
        
        let userData: NSMutableDictionary = NSMutableDictionary(contentsOfFile: plistPath)!
        
        userData.setObject("", forKey: "id" as NSCopying)
        userData.setObject("", forKey: "userName" as NSCopying)
        userData.setObject("", forKey: "userEmail" as NSCopying)
        userData.setObject("", forKey: "userPhoneNumber" as NSCopying)
        userData.setObject("", forKey: "userCreateDate" as NSCopying)
        userData.setObject("", forKey: "userIdentifyNumber" as NSCopying)
        userData.setObject("", forKey: "userSex" as NSCopying)
        userData.setObject("", forKey: "userHeadImageUrl" as NSCopying)
        userData.setObject("", forKey: "userCheckStatus" as NSCopying)
        
        userData.write(toFile: plistPath, atomically: true)
        
        self.saveUserData()
    }
    
    public func saveUserData() {
        let paths: NSArray = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as NSArray
        let filePath: NSString = paths[0] as! NSString
        let plistPath: String = filePath.appendingPathComponent("UserData.plist")
        
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: plistPath) == false {
            self.createUserDataFile()
        }
        
        let userData: NSMutableDictionary = NSMutableDictionary(contentsOfFile: plistPath)!
        
        userData.setObject(self.userId ?? "", forKey: "id" as NSCopying)
        userData.setObject(self.userName ?? "", forKey: "userName" as NSCopying)
        userData.setObject(self.userEmail ?? "", forKey: "userEmail" as NSCopying)
        userData.setObject(self.userPhoneNumber ?? "", forKey: "userPhoneNumber" as NSCopying)
        userData.setObject(self.userCreateDate ?? "", forKey: "userCreateDate" as NSCopying)
        userData.setObject(self.userIdentifyNumber ?? "", forKey: "userIdentifyNumber" as NSCopying)
        userData.setObject(self.userSex ?? "", forKey: "userSex" as NSCopying)
        userData.setObject(self.userHeadImageUrl ?? "", forKey: "userHeadImageUrl" as NSCopying)
        userData.setObject(self.userCheckStatus ?? "", forKey: "userCheckStatus" as NSCopying)
        
        userData.write(toFile: plistPath, atomically: true)
    }
    
    
    private func createUserDataFile() -> Void {
        let paths: NSArray = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as NSArray
        let filePath: NSString = paths[0] as! NSString
        let plistPath: String = filePath.appendingPathComponent("UserData.plist")
        FileManager.default.createFile(atPath: plistPath, contents: nil, attributes: nil)
        
        let userData: NSMutableDictionary = NSMutableDictionary.init(dictionary: ["id": "",
                                                                                  "userName": "",
                                                                                  "userEmail": "",
                                                                                  "userPhoneNumber": "",
                                                                                  "userCreateDate": "",
                                                                                  "userIdentifyNumber": "",
                                                                                  "userSex": "",
                                                                                  "userHeadImageUrl": "",
                                                                                  "userCheckStatus": ""])
        
        userData.write(toFile: plistPath, atomically: true)
    }
    
    private func isPlistFileExist(myFileName: String) -> Bool {
        let paths: NSArray = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as NSArray
        let path: String = paths[0] as! String
        var filePath: String = path.appending("/")
        filePath = filePath.appending(myFileName)
        
        return FileManager.default.fileExists(atPath: filePath)
    }
    
}
