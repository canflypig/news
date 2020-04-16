//
//  HttpDatas.swift
//  NewToday
//
//  Created by iMac on 2019/9/1.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

import Alamofire   // 网络请求

//成功block
typealias UploadUserIconSuccess = (_ dict:[String : Any]) -> Void

private let httpShareInstance = HttpDatas()

// 数据请求方法
enum MothodType {
    case get
    case post
}

class HttpDatas: NSObject {
    
    // 单例
    class var shareInstance: HttpDatas {
        return httpShareInstance
    }
}

extension HttpDatas
{
    /// 网络请求通用版
    ///
    /// - Parameters:
    ///   - type: 数据请求方式 get/post
    ///   - URLString: 请求数据的路径
    ///   - paramaters: 请求数据需要的参数
    ///   - finishCallBack: 请求成功后通过这个block吧数据回调
    func requestDatas(_ type : MothodType, URLString : String, paramaters : [String : Any]?, finishCallBack : @escaping (_ response : Any) -> ()) {
        
        // 获取请求类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        // 发送网络请求
        Alamofire.request(URLString, method: method, parameters: paramaters, encoding: URLEncoding.default, headers: nil).responseJSON { (responseJson) in
            
            // 判断是否请求成功
            guard responseJson.result.value != nil else {
                print(responseJson.result.error!)
                return
            }
            
            // 获取结果
            guard responseJson.result.isSuccess else {
                return
            }
            
            // 成功就把请求的数据回调过去
            if let value = responseJson.result.value {
                finishCallBack(value)
            }
        }
    }
    
    
    /// 参数加在header请求头中
    ///
    /// - Parameters:
    ///   - type: 数据请求方式 get/post
    ///   - URLString: 请求数据的路径
    ///   - paramaters: 请求数据需要的参数
    ///   - finishCallBack: 请求成功后通过这个block吧数据回调
    func requestUserDatas(_ type : MothodType, URLString : String, paramaters : [String : Any]?, finishCallBack : @escaping (_ response : Any) -> ()) {
        
        // 获取请求类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        
        let token = paramaters?["token"] as? String
        
        // 参数拼接到请求头中
        let headers = ["token":token]
        
        // 发送网络请求
        Alamofire.request(URLString, method: method, parameters: paramaters, encoding: URLEncoding.default, headers: headers as? HTTPHeaders).responseJSON { (responseJson) in
            
            // 判断是否请求成功
            guard responseJson.result.value != nil else {
                print(responseJson.result.error!)
                return
            }
            
            // 获取结果
            guard responseJson.result.isSuccess else {
                return
            }
            
            // 成功就把请求的数据回调过去
            if let value = responseJson.result.value {
                finishCallBack(value)
            }
        }
    }
    
    
    /// 上传图片获取图片路径
    ///
    /// - Parameters:
    ///   - type: 上传方式  get/post
    ///   - URLString: 服务器路径
    ///   - paramaters: 存放要上传的图片数组
    ///   - finishCallBack: 上传成功把返回的图片路径通过block传回去
    func uploadDatas(_ type : MothodType, URLString : String, paramaters : [UIImage], finishCallBack : @escaping (_ response : Any) -> ()) {
        
        // 获取请求类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        // 文件类型
        let headers = ["content-type":"multipart/form-data"]
        // 上传
        upload(multipartFormData: { (multipartFormData) in
            
            // 多张时遍历全部上传
            for index in 0..<paramaters.count
            {
                let imageData = paramaters[index].jpegData(compressionQuality: 0.3)
                multipartFormData.append(imageData!, withName: "file", fileName: "fileName_\(index)", mimeType: "image/jpeg")
            }
            
        }, usingThreshold: (10*1024), to: URLString, method: method, headers: headers) { (encodingResult) in
            
            // 获取上传结果
            switch encodingResult {
                
            // 上传成功拿到数据回调
            case .success(let request, _, _):
                request.responseJSON(completionHandler: { (respons) in

                    // 成功就把请求的数据回调过去
                    if let value = respons.result.value {
                        finishCallBack(value)
                    }

                })
            // 失败查看原因
            case .failure(let error):
                print("error = \(error)")
                
            // 这里意思是永不执行，一般不会执行这里
            @unknown default:
                print("未知")
            }

        }
        
    }
    
        
    
}

