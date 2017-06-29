//
//  UserData.swift
//  HimillDelivery
//
//  Created by PatatoAlchemist on 2017/6/14.
//  Copyright © 2017年 Himill. All rights reserved.
//

import UIKit

private var g_userData: UserData? = nil

class UserData: NSObject {
    
    public var userId: String = ""
    public var userName: String = ""
    public var userEmail: String = ""
    public var userPhoneNumber: String = ""
    public var userCreateDate: String = ""
    public var userIdentifyNumber: String = ""
    public var userSex: String = ""
    public var userHeadImageUrl = ""
    
    
    public class func sharingUserData() -> UserData {
        if g_userData == nil {
            g_userData = UserData()
        }
        
        if g_userData?.isPlistFileExist(myFileName: "UserData.plist") == false {
            g_userData?.createUserDataFile()
        }
        
        g_userData?.loadDataFromPlist()
        
        return g_userData!;
    }
    
    public func loadDataFromPlist() {
        let paths: NSArray = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as NSArray
        let filePath: NSString = paths[0] as! NSString
        let plistPath: String = filePath.appendingPathComponent("UserData.plist")
        
        let userData: NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistPath)!
        
        g_userData?.userId = userData.object(forKey: "userId") as! String
        g_userData?.userName = userData.object(forKey: "userName") as! String
        g_userData?.userEmail = userData.object(forKey: "userEmail") as! String
        g_userData?.userPhoneNumber = userData.object(forKey: "userPhoneNumber") as! String
        g_userData?.userCreateDate = userData.object(forKey: "userCreateDate") as! String
        g_userData?.userIdentifyNumber = userData.object(forKey: "userIdentifyNumber") as! String
        g_userData?.userSex = userData.object(forKey: "userSex") as! String
        g_userData?.userHeadImageUrl = userData.object(forKey: "userHeadImageUrl") as! String
    }
    
    public func checkIsLogin() -> Bool {
        let userId = g_userData?.userId
        if userId == nil || userId == "" {
            return false
        }
        return true
    }
    
    public func clearLoginInfo() {
        g_userData = nil
        
        self.createUserDataFile()
    }
    
    public func saveUserData() {
        let paths: NSArray = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as NSArray
        let filePath: NSString = paths[0] as! NSString
        let plistPath: String = filePath.appendingPathComponent("UserData.plist")
        
        let userData: NSMutableDictionary = NSMutableDictionary.init(contentsOfFile: plistPath)!
        
        userData .setObject((self.userId != "" ? self.userId : ""), forKey: "userId" as NSCopying)
        userData .setObject((self.userName != "" ? self.userName : ""), forKey: "userName" as NSCopying)
        userData .setObject((self.userEmail != "" ? self.userEmail : ""), forKey: "userEmail" as NSCopying)
        userData .setObject((self.userPhoneNumber != "" ? self.userPhoneNumber : ""), forKey: "userPhoneNumber" as NSCopying)
        userData .setObject((self.userCreateDate != "" ? self.userCreateDate : ""), forKey: "userCreateDate" as NSCopying)
        userData .setObject((self.userIdentifyNumber != "" ? self.userIdentifyNumber : ""), forKey: "userIdentifyNumber" as NSCopying)
        userData .setObject((self.userSex != "" ? self.userSex : ""), forKey: "userSex" as NSCopying)
        userData .setObject((self.userHeadImageUrl != "" ? self.userHeadImageUrl : ""), forKey: "userHeadImageUrl" as NSCopying)
        
        userData.write(toFile: plistPath, atomically: true)
    }
    
    
    private func createUserDataFile() -> Void {
        let paths: NSArray = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as NSArray
        let filePath: NSString = paths[0] as! NSString
        let plistPath: String = filePath.appendingPathComponent("UserData.plist")
        FileManager.default.createFile(atPath: plistPath, contents: nil, attributes: nil)
        
        let userData: NSMutableDictionary = NSMutableDictionary.init(dictionary: ["userId": "",
                                                                                  "userName": "",
                                                                                  "userEmail": "",
                                                                                  "userPhoneNumber": "",
                                                                                  "userCreateDate": "",
                                                                                  "userIdentifyNumber": "",
                                                                                  "userSex": "",
                                                                                  "userHeadImageUrl": ""])
        
        userData.write(toFile: plistPath, atomically: true)
    }
    
    private func isPlistFileExist(myFileName: String) -> Bool {
        let paths: NSArray = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as NSArray
        let path: String = paths[0] as! String
        var filePath: String = path.appending("/")
        filePath = filePath.appending(myFileName)
        
        return  FileManager.default.fileExists(atPath: filePath)
    }
    
}
