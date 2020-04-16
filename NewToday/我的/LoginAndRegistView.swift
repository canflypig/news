//
//  LoginAndRegistView.swift
//  NewToday
//
//  Created by iMac on 2019/9/3.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

import WisdomHUD
import SwiftyJSON

// 代理传值
protocol LoginAndRegistDelegate : NSObjectProtocol {
    
    func loginChange(value:NSInteger)
}

class LoginAndRegistView: UIView {
    
    // title
    @IBOutlet weak var topTitle: UILabel!
    // 手机号背景view
    @IBOutlet weak var phoneView: UIView!
    // 手机号
    @IBOutlet weak var phoneText: UITextField!
    // 验证码背景view
    @IBOutlet weak var codeView: UIView!
    // 验证码
    @IBOutlet weak var codeText: UITextField!
    // 手机号错误提示
    @IBOutlet weak var wrongPhone: UILabel!
    // 验证码/密码错误提示
    @IBOutlet weak var wrongText: UILabel!
    // 注册按钮
    @IBOutlet weak var registerBtn: UIButton!
    // 同意协议按钮（小方框）
    @IBOutlet weak var agreeBtn: UIButton!
    // 查看协议背景view
    @IBOutlet weak var lookAgreement: UIView!
    // 第三方登录类型背景
    @IBOutlet weak var loginTypeView: UIView!
    // 已读协议背景view
    @IBOutlet weak var readAgreementView: UIView!
    // 发送验证码按钮
    @IBOutlet weak var senfBtn: UIButton!
    // 手机登陆按钮
    @IBOutlet weak var phoneLoginBtn: UIButton!
    // 密码登陆按钮
    @IBOutlet weak var passwordLoginBtn: UIButton!
    
    // 邮箱登陆view
    @IBOutlet weak var emailLoginView: UIView!
    // 邮箱账号输入区域
    @IBOutlet weak var emailView: UIView!
    // 邮箱账号输入框
    @IBOutlet weak var emailText: UITextField!
    // 邮箱登陆密码输入区域
    @IBOutlet weak var emailPasswordView: UIView!
    // 邮箱登陆密码输入框
    @IBOutlet weak var emailPasswordText: UITextField!
    // 邮箱账号输入错误提示
    @IBOutlet weak var wrongEmail: UILabel!
    // 邮箱登陆密码输入错误提示
    @IBOutlet weak var wrongEmailPass: UILabel!
    // 邮箱登陆找回密码提示框
    @IBOutlet weak var findEmailPass: UILabel!
    
    // 获取到的验证码
    var code = ""
    // 同意协议是否勾选
    var isPrivacy:Bool = false
    // 1、账号注册   2、手机登陆   3、密码登陆   4、微信登陆   5、QQ登陆   6、一键登陆   7、邮箱登陆
    var type = "2"
    // 接口参数
    var dicList = [String:Any]()
    
    
    
    
    // 代理属性
    weak var delegate : LoginAndRegistDelegate?
    
    // 点击关闭n按钮，回到个人中心
    @IBAction func backMine(_ sender: Any) {
        
        delegate?.loginChange(value: 1)
    }
    // 点击同意协议按钮方法
    @IBAction func agreeClick(_ sender: Any) {
        
        let button = sender as? UIButton
        
        button!.isSelected = !button!.isSelected
        
        // 协议按钮选中状态
        if button!.isSelected
        {
            button!.setImage(UIImage(named: "agree_img"), for: .selected)
            isPrivacy = true
        }
        else
        {
            button!.setImage(UIImage(named: "noAgree_img"), for: .normal)
            isPrivacy = false
        }
    }
    // 点击发送验证码
    @IBAction func sendCodeClick(_ sender: Any) {
        
        let button = sender as? UIButton
        
        if button?.titleLabel?.text == "找回密码"
        {
            print("找回密码")
            
            delegate?.loginChange(value: 2)
        }
        else
        {
            print("发送验证码")
            
            if phoneText.text?.count == 0
            {
                WisdomHUD.showInfo(text: "请填写手机号码", delay: 1.5, enable: true)
            }
            else
            {
                button?.isEnabled = false
                // 倒计时开始,禁止点击事件
                var remainCount:Int = 60 {
                    willSet {
                        button?.setTitle("重新发送\((newValue))", for: .normal)
                        
                        if newValue <= 0
                        {
                            button?.setTitle("发送验证码", for: .normal)
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
                            button?.isEnabled = true
                            codeTimer.cancel()
                        }
                    }
                })
                // 启动时间源
                codeTimer.resume()
                
                // 获取验证码接口
                let phone = phoneText.text!
                dicList = ["phoneNumber":phone]
                
                // 弱引用
                weak var weakSelf = self
                HttpDatas.shareInstance.requestDatas(.post, URLString: todatAddres+"/user/news/sendCode", paramaters: dicList) { (response) in
                    
                    let jsonData = JSON(response)
                    
                    print("jsonData = \(jsonData)")
                    
                    // 拿到验证码
                    if jsonData["code"].stringValue == "100"
                    {
                        weakSelf?.code = jsonData["data"]["verificationCode"].stringValue
                    }
                    else
                    {
                        WisdomHUD.showInfo(text: "\(jsonData["msg"].stringValue)", delay: 1.5, enable: true)
                    }
                }
            }
        }
        
    }
    // 点击注册按钮   8601
    @IBAction func registBtnClick(_ sender: Any) {
        
        if self.topTitle.text == "账号注册"
        {
            // 注册时判断是否同意协议
            if isPrivacy
            {
                // 验证码是否正确
                if code == codeText.text
                {
                    requestData()
                }
                else
                {
                    WisdomHUD.showSuccess(text: "验证码有误", delay: 1.5, enable: true)
                }
            }
            else
            {
                WisdomHUD.showSuccess(text: "尚未同意“用户协议", delay: 1.5, enable: true)
            }
        }
        else if self.topTitle.text == "登陆你的头条，精彩永不丢失"
        {
            // 验证码是否正确
            if code == codeText.text
            {
                requestData()
            }
            else
            {
                WisdomHUD.showSuccess(text: "验证码有误", delay: 1.5, enable: true)
            }
        }
        else
        {
            requestData()
        }
    }
    
    // 注册/登陆 接口
    private func requestData() {
        
        registerBtn.isEnabled = false
        
        if self.topTitle.text == "账号注册"
        {
            type = "1"
        }
        else if self.topTitle.text == "账号密码登陆"
        {
            type = "3"
        }
        else if self.topTitle.text == "邮箱登陆"
        {
            type = "7"
        }
        else
        {
            type = "2"
        }
        
        // 接口参数
        let uuid = UserDefaults.standard.object(forKey: "uuid") as! String
        let phone = phoneText.text
        let curCode = codeText.text
        
        if type == "3"
        {
            dicList = [
                "phoneNumber"     :phone!,
                "passWord"        :curCode!,
                "onlyIdentifier"  :uuid,
                "type"            :type
            ]
        }
        else if type == "7"
        {
            let email = emailText.text
            let emailPas = emailPasswordText.text
            
            dicList = [
                "emailNumber"     :email!,
                "passWord"        :emailPas!,
                "onlyIdentifier"  :uuid,
                "type"            :type
            ]
        }
        else
        {
            dicList = [
                "phoneNumber"     :phone!,
                "verificationCode":curCode!,
                "onlyIdentifier"  :uuid,
                "type"            :type
            ]
        }
        
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
                weakSelf?.delegate?.loginChange(value: 1)
                // 清除输入密码/验证码
                weakSelf?.cleanText()
            }
            else
            {
                WisdomHUD.showSuccess(text: "\(jsonData["msg"].stringValue)", delay: 1.5, enable: true)
            }
        }
        
        registerBtn.isEnabled = true
    }
    
    
    // 已读view协议按钮
    @IBAction func readXieYi(_ sender: Any) {
        delegate?.loginChange(value: 3)
    }
    // 已读view隐私政策
    @IBAction func readPrivacy(_ sender: Any) {
        delegate?.loginChange(value: 4)
    }
    // 查看view协议按钮
    @IBAction func lookXieYi(_ sender: Any) {
        
        delegate?.loginChange(value: 3)
    }
    // 查看view隐私政策
    @IBAction func lookPrivacy(_ sender: Any) {
        
        delegate?.loginChange(value: 4)
    }
    // 点击手机登陆按钮
    @IBAction func phoneClick(_ sender: Any) {
        
        cleanText()
        
        let button = sender as? UIButton
        
        // 当前按钮文字
        if button?.titleLabel?.text == "账号注册"
        {
            if self.passwordLoginBtn.titleLabel?.text == "手机登陆"
            {
                self.passwordLoginBtn.setTitle("密码登陆", for: .normal)
            }
        }
        
        // 错误颜色恢复
        resetColor()
        // 根据当前点击按钮文字改变页面显示内容
        telLoginAndRegistStatus(value: button!.titleLabel!.text!)
        
    }
    // 点击密码登陆按钮
    @IBAction func passwordClick(_ sender: Any) {
        
        cleanText()
        
        let button = sender as? UIButton
        
        // 当前按钮文字
        if button?.titleLabel?.text == "密码登陆"
        {
            if self.phoneLoginBtn.titleLabel?.text == "手机登陆"
            {
                self.phoneLoginBtn.setTitle("账号注册", for: .normal)
            }
        }
        
        // 错误颜色恢复
        resetColor()
        // 根据当前点击按钮文字改变页面显示内容
        passWordLoginAndTelLogin(value: button!.titleLabel!.text!)
        
    }
    // 隐私设置
    @IBAction func privacySetClick(_ sender: Any) {
        
    }
    
    // 微信登陆
    @IBAction func wx_login(_ sender: Any) {
    }
    // qq登陆
    @IBAction func qq_login(_ sender: Any) {
    }
    // 邮箱登陆
    @IBAction func yx_login(_ sender: Any) {
        
        cleanText()
        
        self.topTitle.text = "邮箱登陆"
        self.emailLoginView.isHidden = false
        self.findEmailPass.isHidden = false
    }
    // 天翼登陆
    @IBAction func ty_login(_ sender: Any) {
    }
    
    
    // ui 设置
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setUI()
    }

}

// 加载xib
extension LoginAndRegistView
{
    class func loadFromNib() -> LoginAndRegistView {
        return Bundle.main.loadNibNamed("LoginAndRegistView", owner: nil, options: nil)?[0] as! LoginAndRegistView
    }
}

// 属性设置
extension LoginAndRegistView
{
    private func setUI() {
        
        registerBtn.isUserInteractionEnabled = false
        
        phoneText.delegate = self
        phoneText.tag = 100
        phoneText.addTarget(self, action: #selector(editTextfieldText(value:)), for: .editingChanged)
        
        codeText.delegate = self
        codeText.tag = 101
        codeText.addTarget(self, action: #selector(editTextfieldText(value:)), for: .editingChanged)
        
        emailText.delegate = self
        emailText.tag = 102
        emailText.addTarget(self, action: #selector(editTextfieldText(value:)), for: .editingChanged)
        
        emailPasswordText.delegate = self
        emailPasswordText.tag = 103
        emailPasswordText.addTarget(self, action: #selector(editTextfieldText(value:)), for: .editingChanged)
        
        
        self.emailLoginView.isHidden = true
        self.findEmailPass.isHidden = true
        
        telLoginAndRegistStatus(value: "手机登陆")
        passWordLoginAndTelLogin(value: "手机登陆")
        
        // 先隐藏查看协议和第三方登录区域
        self.lookAgreement.isHidden = false
        
        // 手机号码背景属性调整
        self.phoneView.layer.borderWidth = 1
        self.phoneView.layer.borderColor = UIColor.gray.cgColor
        self.phoneView.layer.cornerRadius = customLayer(num: 22.5)
        self.phoneView.layer.masksToBounds = true
        
        // 验证码背景属性调整
        self.codeView.layer.borderWidth = 1
        self.codeView.layer.borderColor = UIColor.gray.cgColor
        self.codeView.layer.cornerRadius = customLayer(num: 22.5)
        self.codeView.layer.masksToBounds = true
        
        // 注册按钮属性调整
        self.registerBtn.layer.cornerRadius = customLayer(num: 22.5)
        self.registerBtn.layer.masksToBounds = true
        
        // 同意协议按钮属性调整
        self.agreeBtn.layer.borderWidth = 1
        self.agreeBtn.layer.borderColor = UIColor.gray.cgColor
        
        
        // 邮箱账号背景属性调整
        self.emailView.layer.borderWidth = 1
        self.emailView.layer.borderColor = UIColor.gray.cgColor
        self.emailView.layer.cornerRadius = customLayer(num: 22.5)
        self.emailView.layer.masksToBounds = true
        
        // 邮箱登陆密码背景属性调整
        self.emailPasswordView.layer.borderWidth = 1
        self.emailPasswordView.layer.borderColor = UIColor.gray.cgColor
        self.emailPasswordView.layer.cornerRadius = customLayer(num: 22.5)
        self.emailPasswordView.layer.masksToBounds = true
    }
    
    @objc private func editTextfieldText(value:UITextField) {
        
        if self.topTitle.text == "账号密码登陆" {
            codeText.isSecureTextEntry = true
        }
        else
        {
            codeText.isSecureTextEntry = false
        }
        
        regBackColor(value: value)
    }
    
    private func regBackColor(value:UITextField) {
        
        if value.tag == 100 || value.tag == 101
        {
            if phoneText.text?.count == 11 && codeText.text!.count > 0
            {
                registerBtn.isUserInteractionEnabled = true
                registerBtn.backgroundColor = RGBColor(r: 230, g: 100, b: 95)
            }
            else
            {
                registerBtn.isUserInteractionEnabled = false
                registerBtn.backgroundColor = RGBColor(r: 229, g: 174, b: 173)
            }
        }
        else
        {
            if valudataEmail(email: emailText.text!) && emailPasswordText.text!.count > 0
            {
                registerBtn.isUserInteractionEnabled = true
                registerBtn.backgroundColor = RGBColor(r: 230, g: 100, b: 95)
            }
            else
            {
                registerBtn.isUserInteractionEnabled = false
                registerBtn.backgroundColor = RGBColor(r: 229, g: 174, b: 173)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    // 验证码抖动文字内容
    private func judgeCodeTextplace() {
        // 判断当前提示文字显示内容
        if self.codeText.placeholder == "密码"
        {
            self.wrongText.text = "密码错误"
        }
        else
        {
            self.wrongText.text = "验证码错误"
        }
        
    }
    
    
    // 切换时晴空密码
    private func cleanText() {
        // 判断当前提示文字显示内容
        codeText.text = ""
        registerBtn.backgroundColor = RGBColor(r: 229, g: 174, b: 173)
    }
    
    // 手机登陆和账号注册 切换显示的不同的内容
    private func telLoginAndRegistStatus(value:String) {
        
        if value == "账号注册"
        {
            self.lookAgreement.isHidden = true
            self.readAgreementView.isHidden = false
            self.loginTypeView.isHidden = true
            self.topTitle.text = "账号注册"
            self.registerBtn.setTitle("注册", for: .normal)
            self.phoneLoginBtn.setTitle("手机登陆", for: .normal)
            self.senfBtn.setTitle("发送验证码", for: .normal)
            self.codeText.placeholder = "请输入验证码"
        }
        else
        {
            self.lookAgreement.isHidden = false
            self.readAgreementView.isHidden = true
            self.loginTypeView.isHidden = false
            self.topTitle.text = "登陆你的头条，精彩永不丢失"
            self.registerBtn.setTitle("进入头条", for: .normal)
            self.phoneLoginBtn.setTitle("账号注册", for: .normal)
            self.senfBtn.setTitle("发送验证码", for: .normal)
            self.codeText.placeholder = "请输入验证码"
        }
        
        self.wrongPhone.isHidden = true
        self.wrongText.isHidden = true
        
        self.emailLoginView.isHidden = true
        self.findEmailPass.isHidden = true
        
        self.wrongEmail.isHidden = true
        self.wrongEmailPass.isHidden = true
    }
    
    // 手机登陆和密码登陆 切换显示的不同的内容
    private func passWordLoginAndTelLogin(value:String) {
        
        if value == "手机登陆"
        {
            self.lookAgreement.isHidden = false
            self.readAgreementView.isHidden = false
            self.loginTypeView.isHidden = false
            self.topTitle.text = "登陆你的头条，精彩永不丢失"
            self.registerBtn.setTitle("进入头条", for: .normal)
            self.passwordLoginBtn.setTitle("密码登陆", for: .normal)
            self.senfBtn.setTitle("发送验证码", for: .normal)
            self.codeText.placeholder = "请输入验证码"
        }
        else
        {
            self.lookAgreement.isHidden = false
            self.readAgreementView.isHidden = true
            self.loginTypeView.isHidden = false
            self.topTitle.text = "账号密码登陆"
            self.registerBtn.setTitle("进入头条", for: .normal)
            self.passwordLoginBtn.setTitle("手机登陆", for: .normal)
            self.senfBtn.setTitle("找回密码", for: .normal)
            self.codeText.placeholder = "密码"
        }
        
        self.wrongPhone.isHidden = true
        self.wrongText.isHidden = true
        
        
        self.emailLoginView.isHidden = true
        self.findEmailPass.isHidden = true
        
        self.wrongEmail.isHidden = true
        self.wrongEmailPass.isHidden = true
    }
    
    // 文字抖动
    func shake(label:UILabel) {
        
        // 左右抖动函数
        let douDong = CAKeyframeAnimation()
        douDong.keyPath = "transform.translation.x"
        let s = 10
        // 抖动位置（左右）
        douDong.values = [-s,0,s,0,-s,0,s,0]
        // 抖动时间
        douDong.duration = 0.1
        // 抖动此时
        douDong.repeatCount = 2
        // 结束移除动画
        douDong.isRemovedOnCompletion = true
        label.layer.add(douDong, forKey: "shake")
    }
    
    // 错误提示颜色复位
    private func resetColor() {
        
        self.wrongPhone.isHidden = true
        self.wrongText.isHidden = true
        self.wrongEmail.isHidden = true
        self.wrongEmailPass.isHidden = true
        
        self.phoneView.layer.borderColor = UIColor.gray.cgColor
        self.codeView.layer.borderColor = UIColor.gray.cgColor
        
        self.emailView.layer.borderColor = UIColor.gray.cgColor
        self.emailPasswordView.layer.borderColor = UIColor.gray.cgColor
    }
    
}

extension LoginAndRegistView : UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 开始编辑
        resetColor()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // 编辑结束
        
        if self.topTitle.text == "邮箱登陆"
        {
            if textField.tag == 102
            {
                if !valudataEmail(email: textField.text!)
                {
                    // 这里测试一下错误提示
                    self.wrongEmail.isHidden = false
                    // 要抖动label
                    shake(label: self.wrongEmail)
                    // 错误时边框颜色
                    self.emailView.layer.borderColor = RGBColor(r: 230, g: 100, b: 95).cgColor
                }
            }
            else
            {
                if emailPasswordText.text!.count < 1
                {
                    // 这里测试一下错误提示
                    self.wrongEmailPass.isHidden = false
                    // 要抖动label
                    shake(label: self.wrongEmailPass)
                    // 错误时边框颜色
                    self.emailPasswordView.layer.borderColor = RGBColor(r: 230, g: 100, b: 95).cgColor
                }
            }
        }
        else
        {
            judgeCodeTextplace()
            
            if textField.tag == 100
            {
                if textField.text?.count != 11
                {
                    // 这里测试一下错误提示
                    self.wrongPhone.isHidden = false
                    // 要抖动label
                    shake(label: self.wrongPhone)
                    // 错误时边框颜色
                    self.phoneView.layer.borderColor = RGBColor(r: 230, g: 100, b: 95).cgColor
                }
            }
            else
            {
                if codeText.text!.count < 1
                {
                    // 这里测试一下错误提示
                    self.wrongText.isHidden = false
                    // 要抖动label
                    shake(label: self.wrongText)
                    // 错误时边框颜色
                    self.codeView.layer.borderColor = RGBColor(r: 230, g: 100, b: 95).cgColor
                }
            }
        }
    }
}
