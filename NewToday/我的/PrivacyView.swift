//
//  PrivacyView.swift
//  NewToday
//
//  Created by iMac on 2019/9/4.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

// 代理传值
protocol PrivacyViewDelegate : NSObjectProtocol {
    
    func PrivacyChange(value:NSInteger)
}

class PrivacyView: UIView {

    // 头部标题
    @IBOutlet weak var titlePrivacy: UILabel!
    // 代理属性
    weak var delegate : PrivacyViewDelegate?
    
    
    // 点击返回按钮
    @IBAction func backPrivacyClick(_ sender: Any) {
        
        delegate?.PrivacyChange(value: 1)
    }
    // 点击更多按钮
    @IBAction func more_click(_ sender: Any) {
        
        delegate?.PrivacyChange(value: 2)
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

// 加载xib
extension PrivacyView
{
    class func loadFromNib() -> PrivacyView
    {
        return Bundle.main.loadNibNamed("PrivacyView", owner: nil, options: nil)?[0] as! PrivacyView
    }
}
