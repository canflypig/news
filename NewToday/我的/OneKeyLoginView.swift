//
//  OneKeyLoginView.swift
//  NewToday
//
//  Created by iMac on 2019/9/6.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

import SwiftyJSON
import WisdomHUD

// 代理传值
protocol OneKeyLoginViewDelegate : NSObjectProtocol {
    
    func keyLoginChange(value:NSInteger)
}

class OneKeyLoginView: UIView {
    
    // 手机号码
    @IBOutlet weak var telPhoneText: UILabel!
    // 手机号码认证（移动/联通/其它）
    @IBOutlet weak var telFrom: UILabel!
    // 一键登陆按钮属性
    @IBOutlet weak var oneKeyBtn: UIButton!
    // 代理属性
    weak var delegate : OneKeyLoginViewDelegate?
    
    // 接口参数
    var dicList = [String:Any]()
    
    // 属性设置
    override func layoutSubviews() {
        super.layoutSubviews()
        setUI()
    }
    
    
    // 关闭一键登录 关闭按钮
    @IBAction func closeBtnCilci(_ sender: Any) {
        
        delegate?.keyLoginChange(value: 1)
    }
    
    // 一键登录按钮
    @IBAction func KeyLoginVlick(_ sender: Any) {
        
        oneKeyBtn.isEnabled = false
        
        let uuid = UserDefaults.standard.object(forKey: "uuid") as! String
        let phone = UserDefaults.standard.object(forKey: "phone") as! String
        
        dicList = [
            "phoneNumber"     :phone,
            "onlyIdentifier"  :uuid,
            "type"            :"6"
        ]
        
        // 弱引用
        weak var weakSelf = self
        HttpDatas.shareInstance.requestDatas(.post, URLString: todatAddres+"/user/news/register", paramaters: dicList) { (response) in
            
            let jsonData = JSON(response)
            
            print("login = \(jsonData)")
            
            // 请求成功
            if jsonData["code"].stringValue == "100"
            {
                // 手机号码
                let phone = jsonData["data"]["user_login"].stringValue
                UserDefaults.standard.setValue(phone, forKey: "phone")
                // token
                let token = jsonData["data"]["token"].stringValue
                UserDefaults.standard.setValue(token, forKey: "token")
                // 昵称
                let nicename = jsonData["data"]["user_nicename"].stringValue
                UserDefaults.standard.setValue(nicename, forKey: "nicename")
                // 邮箱
                let email = jsonData["data"]["user_email"].stringValue
                UserDefaults.standard.setValue(email, forKey: "email")
                // 头像
                let headUrl = jsonData["data"]["user_url"].stringValue
                UserDefaults.standard.setValue(headUrl, forKey: "headUrl")
                
                // 登陆成功判断值
                UserDefaults.standard.setValue("true", forKey: "login")
                // 返回个人中心
                weakSelf?.delegate?.keyLoginChange(value: 1)
            }
            else
            {
                WisdomHUD.showSuccess(text: "\(jsonData["msg"].stringValue)", delay: 1.5, enable: true)
            }
        }
        
        oneKeyBtn.isEnabled = true
        
    }
    
    // 更多登陆
    @IBAction func moreLoginClick(_ sender: Any) {
        
        delegate?.keyLoginChange(value: 2)
    }
    
    // 隐私设置
    @IBAction func privacySetClick(_ sender: Any) {
        
        delegate?.keyLoginChange(value: 3)
    }
    
    // 移动协议
    @IBAction func telPrivacyClick(_ sender: Any) {
        
        delegate?.keyLoginChange(value: 4)
    }
    
    // 用户协议
    @IBAction func userPrivacyClick(_ sender: Any) {
        
        delegate?.keyLoginChange(value: 5)
    }
    
    // 隐私政策
    @IBAction func privachZhengCeClick(_ sender: Any) {
        
        delegate?.keyLoginChange(value: 6)
    }
    
}


// 加载xib
extension OneKeyLoginView
{
    class func loadFromNib() -> OneKeyLoginView
    {
        return Bundle.main.loadNibNamed("OneKeyLoginView", owner: nil, options: nil)?[0] as! OneKeyLoginView
    }
}



extension OneKeyLoginView
{
    private func setUI() {
        
        // 一键登陆按钮属性调整
        self.oneKeyBtn.layer.cornerRadius = customLayer(num: 22.5)
        self.oneKeyBtn.layer.masksToBounds = true
    }
}
