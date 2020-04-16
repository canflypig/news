//
//  FindPassView.swift
//  NewToday
//
//  Created by iMac on 2019/9/4.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit
import WisdomHUD
import SwiftyJSON

// 代理传值
protocol FindViewDelegate : NSObjectProtocol {
    
    func findChange(value:NSInteger)
}

class FindPassView: UIView {

    // 返回按钮
    @IBOutlet weak var findBackBtn: UIButton!
    // 关闭按钮
    @IBOutlet weak var findClose: UIButton!
    // 手机号码输入区域
    @IBOutlet weak var telBjView: UIView!
    // 手机号码输入框
    @IBOutlet weak var findPhoneText: UITextField!
    // 下一步按钮（获取验证码）
    @IBOutlet weak var findNextBtn: UIButton!
    // 验证码和新密码输入区域view
    @IBOutlet weak var codePassView: UIView!
    // 验证码区域view
    @IBOutlet weak var findCodeView: UIView!
    // 验证码输入框
    @IBOutlet weak var codeText: UITextField!
    // 发送验证码按钮
    @IBOutlet weak var sendCodeBtn: UIButton!
    // 新密码输入区域view
    @IBOutlet weak var passwordFindView: UIView!
    // 新密码输入框
    @IBOutlet weak var passwordText: UITextField!
    // 下一步 确定新密码
    @IBOutlet weak var nextPasswordBtn: UIButton!
    // 代理属性
    weak var delegate : FindViewDelegate?
    
    // 获取到的验证码
    var code = ""
    // 接口参数
    var dicList = [String:Any]()
    
    
    
    // 点击返回按钮
    @IBAction func backFind(_ sender: Any) {
        
        delegate?.findChange(value: 1)
        
        self.codePassView.isHidden = true
    }
    
    // 点击关闭按钮
    @IBAction func closeFind(_ sender: Any) {
        
        delegate?.findChange(value: 2)
        
        self.codePassView.isHidden = true
    }
    
    // 输入手机号下一步按钮
    @IBAction func nextTelBtnClick(_ sender: Any) {
        
        // 弱引用
        weak var weakSelf = self
        
        sendCodeBtn?.isEnabled = false
        // 倒计时开始,禁止点击事件
        var remainCount:Int = 60 {
            willSet {
                sendCodeBtn?.setTitle("重新发送\((newValue))", for: .normal)
                
                if newValue <= 0
                {
                    sendCodeBtn?.setTitle("发送验证码", for: .normal)
                }
            }
        }
        // 在global线程里创建一个时间源
        let codeTimer = DispatchSource.makeTimerSource()
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer.schedule(deadline: .now(), repeating: .seconds(1))
        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: {
            // 返回主线程处理一些事件，更新UI等等
            DispatchQueue.main.async {
                // 每秒计时一次
                remainCount -= 1
                // 时间到了取消时间源
                if remainCount <= 0
                {
                    weakSelf?.sendCodeBtn?.isEnabled = true
                    codeTimer.cancel()
                }
            }
        })
        // 启动时间源
        codeTimer.resume()
        
        // 获取验证码接口
        let phone = findPhoneText.text!
        dicList = ["phoneNumber":phone]
        
        HttpDatas.shareInstance.requestDatas(.post, URLString: todatAddres+"/user/news/sendCode", paramaters: dicList) { (response) in
            
            let jsonData = JSON(response)
            
            print("jsonData = \(jsonData)")
            
            // 拿到验证码
            if jsonData["code"].stringValue == "100"
            {
                weakSelf?.code = jsonData["data"]["verificationCode"].stringValue
                
                self.codePassView.isHidden = false
            }
            else
            {
                WisdomHUD.showInfo(text: "\(jsonData["msg"].stringValue)", delay: 1.5, enable: true)
            }
        }
        
    }
    
    // 下一步 确定新密码按钮
    @IBAction func nextPassBtn(_ sender: Any) {
        
        if code != codeText.text
        {
            WisdomHUD.showInfo(text: "验证码有误", delay: 1.5, enable: true)
        }
        else
        {
            let phone = findPhoneText.text
            let passT = passwordText.text
            
            dicList = [
                "phoneNumber"     :phone!,
                "passWord"        :passT!,
                "verificationCode":code
            ]
            
            // 弱引用
            weak var weakSelf = self
            HttpDatas.shareInstance.requestDatas(.post, URLString: todatAddres+"/user/forget/password", paramaters: dicList) { (respose) in
                
                let jsonData = JSON(respose)
                
                print("jsonData = \(jsonData)")
                
                // 判断修改是否成功
                if jsonData["code"].stringValue == "100"
                {
                    WisdomHUD.showInfo(text: "修改成功", delay: 1.5, enable: true)
                    
                    weakSelf?.delegate?.findChange(value: 2)
                    
                    weakSelf?.codePassView.isHidden = true
                }
                else
                {
                    WisdomHUD.showInfo(text: "\(jsonData["msg"].stringValue)", delay: 1.5, enable: true)
                }
            }
        }
        
    }
    // 属性设置
    override func layoutSubviews() {
        super.layoutSubviews()
        setUI()
    }

}
// 加载xib
extension FindPassView
{
    class func loadFromNib() -> FindPassView
    {
        return Bundle.main.loadNibNamed("FindPassView", owner: nil, options: nil)?[0] as! FindPassView
    }
}


extension FindPassView
{
    private func setUI() {
        
        findNextBtn.isEnabled = false
        nextPasswordBtn.isEnabled = false
        
        findPhoneText.delegate = self
        findPhoneText.tag = 100
        findPhoneText.addTarget(self, action: #selector(editTextfieldText(value:)), for: .editingChanged)
        
        codeText.delegate = self
        codeText.tag = 101
        codeText.addTarget(self, action: #selector(editTextfieldText(value:)), for: .editingChanged)
        
        passwordText.delegate = self
        passwordText.tag = 102
        passwordText.addTarget(self, action: #selector(editTextfieldText(value:)), for: .editingChanged)
        
        
        self.codePassView.isHidden = true
        
        // 手机号码背景属性调整
        self.telBjView.layer.borderWidth = 1
        self.telBjView.layer.borderColor = UIColor.gray.cgColor
        self.telBjView.layer.cornerRadius = customLayer(num: 22.5)
        self.telBjView.layer.masksToBounds = true
        
        // 注册按钮属性调整
        self.findNextBtn.layer.cornerRadius = customLayer(num: 22.5)
        self.findNextBtn.layer.masksToBounds = true
        
        
        // 验证码背景属性调整
        self.findCodeView.layer.borderWidth = 1
        self.findCodeView.layer.borderColor = UIColor.gray.cgColor
        self.findCodeView.layer.cornerRadius = customLayer(num: 22.5)
        self.findCodeView.layer.masksToBounds = true
        
        // 新密码背景属性调整
        self.passwordFindView.layer.borderWidth = 1
        self.passwordFindView.layer.borderColor = UIColor.gray.cgColor
        self.passwordFindView.layer.cornerRadius = customLayer(num: 22.5)
        self.passwordFindView.layer.masksToBounds = true
        
        // 下一步确定属性调整
        self.nextPasswordBtn.layer.cornerRadius = customLayer(num: 22.5)
        self.nextPasswordBtn.layer.masksToBounds = true
    }
    
    // 监听输入框输入信息
    @objc private func editTextfieldText(value:UITextField) {
        
        if value.tag == 100
        {
            if value.text?.count == 11
            {
                findNextBtn.isEnabled = true
                findNextBtn.backgroundColor = RGBColor(r: 230, g: 100, b: 95)
            }
            else
            {
                findNextBtn.isEnabled = false
                findNextBtn.backgroundColor = RGBColor(r: 229, g: 174, b: 173)
            }
        }
        else
        {
            if codeText.text?.count == 4 && passwordText.text!.count > 1
            {
                nextPasswordBtn.isEnabled = true
                nextPasswordBtn.backgroundColor = RGBColor(r: 230, g: 100, b: 95)
            }
            else
            {
                nextPasswordBtn.isEnabled = false
                nextPasswordBtn.backgroundColor = RGBColor(r: 229, g: 174, b: 173)
            }
        }
    }
    
    // 错误提示颜色复位
    private func resetColor() {
        
        self.telBjView.layer.borderColor = UIColor.gray.cgColor
        self.findCodeView.layer.borderColor = UIColor.gray.cgColor
        self.passwordFindView.layer.borderColor = UIColor.gray.cgColor
    }
    
}


extension FindPassView : UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 开始编辑
        resetColor()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 编辑结束
        if textField.tag == 100
        {
            if textField.text?.count != 11
            {
                // 错误时边框颜色
                self.telBjView.layer.borderColor = RGBColor(r: 230, g: 100, b: 95).cgColor
            }
        }
        if textField.tag == 101
        {
            if textField.text?.count != 4
            {
                // 错误时边框颜色
                self.findCodeView.layer.borderColor = RGBColor(r: 230, g: 100, b: 95).cgColor
            }
        }
        if textField.tag == 102
        {
            if textField.text!.count < 1
            {
                // 错误时边框颜色
                self.passwordFindView.layer.borderColor = RGBColor(r: 230, g: 100, b: 95).cgColor
            }
        }
    }
}

