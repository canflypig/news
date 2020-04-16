//
//  MineModel.swift
//  NewToday
//
//  Created by iMac on 2019/9/23.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

import SwiftyJSON

class MineModel: NSObject {
    
    var user_login    : String = ""       // 昵称
    var user_url      : String = ""       // 头像
    var phoneNumber   : String = ""       // 手机号码
    
    var introduceText : String = ""       // 介绍文字
    var gender        : String = ""       // 性别
    var birthday      : String = ""       // 生日
    var area          : String = ""       // 地区
    
    var releaseNum    : String = ""       // 发布过的头条数量
    var followNum     : String = ""       // 关注的数量
    var fansNum       : String = ""       // 粉丝的数量
    var bePraisedNum  : String = ""       // 获赞的数量
    
    init(jsonData: JSON) {
        
        user_login   = jsonData["user_login"].stringValue
        user_url     = jsonData["user_url"].stringValue
        phoneNumber  = jsonData["phoneNumber"].stringValue
        
        introduceText   = jsonData["introduceText"].stringValue
        gender          = jsonData["gender"].stringValue
        birthday        = jsonData["birthday"].stringValue
        area            = jsonData["area"].stringValue
        
        releaseNum    = jsonData["releaseNum"].stringValue
        followNum     = jsonData["followNum"].stringValue
        fansNum       = jsonData["fansNum"].stringValue
        bePraisedNum  = jsonData["bePraisedNum"].stringValue
    }
    
}
