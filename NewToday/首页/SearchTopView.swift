//
//  SearchTopView.swift
//  NewToday
//
//  Created by iMac on 2019/9/29.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

class SearchTopView: UIView {
    
    // 搜索框白色背景视图
    @IBOutlet weak var searBJ: UIView!
    // 取消按钮属性
    @IBOutlet weak var cancelBtn: UIButton!
    // 搜索文字
    @IBOutlet weak var searchText: UITextField!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUI()
    }

}

// 加载xib
extension SearchTopView
{
    class func loadFromNib() -> SearchTopView
    {
        return Bundle.main.loadNibNamed("SearchTopView", owner: nil, options: nil)?[0] as! SearchTopView
    }
}

extension SearchTopView
{
    // 属性调整
    private func setUI() {
        
        self.searchText.font = customFont(font: 15)
        self.cancelBtn.titleLabel?.font = customFont(font: 16)
        
        self.searBJ.layer.cornerRadius = 5
        self.searBJ.layer.masksToBounds = true
    }
}
