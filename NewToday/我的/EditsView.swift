//
//  EditsView.swift
//  NewToday
//
//  Created by iMac on 2019/9/25.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

import WisdomHUD
// 代理传值
protocol EditDelegate : NSObjectProtocol {
    
    func editChange(value:String)
}

class EditsView: UIView {
    
    // 输入框
    @IBOutlet weak var textCont: UITextView!
    // 提示文字
    @IBOutlet weak var placeText: UITextField!
    // 字数
    @IBOutlet weak var numLbel: UILabel!
    // 确定按钮
    @IBOutlet weak var deterBtn: UIButton!
    // 代理属性
    weak var delegate : EditDelegate?
    
    var num = 0
    var defText = ""
    
    
    
    // 点击确定按钮
    @IBAction func deterClick(_ sender: Any) {
        
        if textCont.text.count == 0
        {
            WisdomHUD.showError(text: "内容不能为空", delay: 1.0, enable: true)
        }
        else
        {
            delegate?.editChange(value: textCont.text)
            textCont.text = ""
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUI()
    }
    
}


// 加载xib
extension EditsView
{
    class func loadFromNib() -> EditsView
    {
        return Bundle.main.loadNibNamed("EditsView", owner: nil, options: nil)?[0] as! EditsView
    }
}


// 属性设置
extension EditsView
{
    private func setUI() {
        
        self.deterBtn.layer.cornerRadius = 5
        self.deterBtn.layer.masksToBounds = true
        
        self.textCont.isScrollEnabled = false
        self.textCont.delegate = self
        
        self.placeText.isEnabled = false
    }
}

// UITextViewDelegate
extension EditsView : UITextViewDelegate
{
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count == 0
        {
            self.deterBtn.backgroundColor = UIColor.lightGray
            self.deterBtn.isEnabled = false
        }
        else
        {
            self.deterBtn.backgroundColor = RGBColor(r: 32, g: 140, b: 251)
            self.deterBtn.isEnabled = true
        }
        
        requestTextViewUI(value: textView.text, nums: num, plactT: defText)
    }
    
    // 字数限制
    func requestTextViewUI(value: String, nums: NSInteger, plactT: String) {
        
        if value.count == 0
        {
            self.placeText.placeholder = plactT
            self.placeText.isHidden = false
            self.numLbel.text = "\(nums)"
        }
        else
        {
            self.placeText.isHidden = true
            let curNum = nums - value.count
            self.numLbel.text = "\(curNum)"
            
            let textStr = value as NSString
            if textStr.length > nums
            {
                WisdomHUD.showError(text: "超过限制字数", delay: 1.0, enable: true)
                self.numLbel.text = "0"
                
                let str = textStr.substring(to: nums)
                self.textCont.text = str
            }
        }
    }
}

