//
//  HomeHorseView.swift
//  NewToday
//
//  Created by iMac on 2019/9/26.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

protocol HomeSearchDelegte : NSObjectProtocol{
    // 标签分类
    func searchChange()
}

class HomeHorseView: UIView {
    
    // 搜索按钮
    @IBOutlet weak var searchBtn: UIButton!
    // 搜索按钮默认文字
    @IBOutlet weak var searchText: UILabel!
    // 代理属性
    weak var delegate:HomeSearchDelegte?
    
    // 点击搜索按钮执行这里
    @IBAction func searchClick(_ sender: Any) {
        
        delegate?.searchChange()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUI()
    }

}

// 加载xib
extension HomeHorseView
{
    class func loadFromNib() -> HomeHorseView
    {
        return Bundle.main.loadNibNamed("HomeHorseView", owner: nil, options: nil)?[0] as! HomeHorseView
    }
}

// 其它属性在这里设置
extension HomeHorseView
{
    private func setUI() {
        
        self.searchBtn.layer.cornerRadius = 5
        self.searchBtn.layer.masksToBounds = true
        
        self.searchText.font = customFont(font: 15)
    }
}
