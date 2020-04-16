//
//  HeadMineView.swift
//  NewToday
//
//  Created by iMac on 2019/9/21.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

// 代理传值
protocol LoginClickDelegate : NSObjectProtocol {
    
    func logClickChange(value:NSInteger)
}

class HeadMineView: UIView {
    
    // 头部白色背景
    @IBOutlet weak var bjView: UIView!
    // 个人信息背景
    @IBOutlet weak var inforView: UIView!
    // 申请认证
    @IBOutlet weak var applyBtn: UIButton!
    // 头像
    @IBOutlet weak var headImg: UIImageView!
    // 昵称
    @IBOutlet weak var nick_name: UILabel!
    
    // 代理属性
    weak var delegate : LoginClickDelegate?
    
    // 点击登陆按钮
    @IBAction func loginClick(_ sender: Any) {
        
        delegate?.logClickChange(value: 1)
    }
    // 点击个人信息区域
    @IBAction func userInforBtn(_ sender: Any) {
        
        delegate?.logClickChange(value: 2)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        creatUI()
    }

}

// 加载xib
extension HeadMineView
{
    class func loadFromNib() -> HeadMineView
    {
        return Bundle.main.loadNibNamed("HeadMineView", owner: nil, options: nil)?[0] as! HeadMineView
    }
}

// 属性设置
extension HeadMineView
{
    private func creatUI() {
        
        self.applyBtn.layer.cornerRadius = 9
        self.applyBtn.layer.masksToBounds = true
        
        
        self.headImg.layer.cornerRadius = 30
        self.headImg.layer.masksToBounds = true
    }
}
