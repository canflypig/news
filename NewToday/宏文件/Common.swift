//
//  Common.swift
//  NewToday
//
//  Created by iMac on 2019/9/1.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

// 接口前缀地址
let todatAddres = "http://toutiao.apkbus.com/wp-json/custom/v1"
let updataImgUrl = "http://101.132.114.122:8099/upload"

let def_url = "http://www.crowncake.cn:18080/wav/no.9.mp4"

// 屏幕宽高
let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height

// KeyWindow
let KeyWindow = UIApplication.shared.keyWindow

// 判读是否iphone
let kIsIphone = Bool(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone)

// 判读是否iphone X
let kIsIphoneX = Bool(kScreenW >= 375.0 && kScreenH >= 812.0 && kIsIphone)

// 导航条高度
let kNavigationBarH = CGFloat(kIsIphoneX ? 88 : 64)

// 状态栏高度
let kStatusBarH = CGFloat(kIsIphoneX ? 44 : 20)

// tabbar高度
let kTabBarH = CGFloat(kIsIphoneX ? (49+34) : 49)

// 自定义颜色
func RGBColor(r :CGFloat, g :CGFloat, b :CGFloat) -> UIColor {
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
}

// 字号/默认
let titleFont:CGFloat = 17.0

// 字号
func customFont(font :CGFloat) -> UIFont {
    
    // 刘海屏
    guard kScreenH <= 736 else {
        return UIFont.systemFont(ofSize: font+3)
    }
    // 5.5
    guard kScreenH == 736 else {
        return UIFont.systemFont(ofSize: font+2)
    }
    // 4.7
    guard kScreenH >= 736 else {
        return UIFont.systemFont(ofSize: font)
    }
    
    return UIFont.systemFont(ofSize: font)
}

// 不同屏幕显示不同大小
func customLayer(num :CGFloat) -> CGFloat {
    
    // 刘海屏
    guard kScreenH <= 736 else {
        return num*1.3
    }
    // 5.5
    guard kScreenH == 736 else {
        return num*1.1
    }
    // 4.7
    guard kScreenH >= 736 else {
        return num
    }
    
    return num*1.2
}

// 邮箱正则
func valudataEmail(email: String) -> Bool {
    
    if email.count == 0
    {
        return false
    }
    
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let emailText:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailText.evaluate(with: email)
    
}
