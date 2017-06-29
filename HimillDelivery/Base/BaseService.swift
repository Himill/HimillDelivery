//
//  BaseService.swift
//  HimillDelivery
//
//  Created by PatatoAlchemist on 2017/6/13.
//  Copyright © 2017年 Himill. All rights reserved.
//

import UIKit
import AFNetworking

enum RequestType {
    case Get
    case Post
}

class BaseService: AFHTTPSessionManager {
    
    static let shareInstance: BaseService = {
        let requsetInstance = BaseService()
        requsetInstance.responseSerializer.acceptableContentTypes?.insert("text/html")
        return requsetInstance
    }()
    
    static let kReturnCodeSuccess: String   = "success"
    static let kReturnCodeWarn: String      = "warn"
    static let kReturnCodeError: String     = "error"
    
    
    // 将成功和失败的回调分别写在两个逃逸闭包中
    func request(requestType: RequestType, url: String, parameters: [String :Any]?, succeed: @escaping([String :Any]?) -> (), failure :@escaping(Error?) -> ()) {
        
        // 成功闭包
        let successBlock = { (task: URLSessionDataTask, responseObject: Any?) in
            succeed(responseObject as? [String :Any])
        }
        
        // 失败的闭包
        let failureBlock = { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
        
        // Get 请求
        if requestType == .Get {
            get(url, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
            
        }
        
        // Post 请求
        if requestType == .Post {
            post(url, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
        }
        
    }
    
    func request(url: String, parameters: [String :Any]?, succeed: @escaping([String :Any]?) -> (), constructingBodyWith block: @escaping(AFMultipartFormData) -> () , failure: @escaping(Error?) -> ()) {
        
        // 成功闭包
        let successBlock = { (task: URLSessionDataTask, responseObject: Any?) in
            succeed(responseObject as? [String :Any])
        }
        
        // 失败的闭包
        let failureBlock = { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
        
        // 上传数据闭包
        let constructingBlock = { (mutiData: AFMultipartFormData) in
            block(mutiData)
        }
        
        post(url, parameters: parameters, constructingBodyWith: constructingBlock, progress: nil, success: successBlock, failure: failureBlock)
    }
    
}
