//
//  SearchCollectionViewCell.swift
//  NewToday
//
//  Created by iMac on 2019/9/29.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    // 初始化文字控件
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(labels)
        self.addSubview(lines)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 显示文字控件
    private lazy var labels : UILabel = {
        
        let lab = UILabel.init(frame: CGRect(x: 20, y: 0, width: kScreenW/2-40, height: 40))
        lab.font = customFont(font: 16)
        lab.textColor = RGBColor(r: 34, g: 34, b: 34)
        
        return lab
    }()
    
    // 灰线
    private lazy var lines : UILabel = {
        
        let lab = UILabel.init(frame: CGRect(x: kScreenW/2-5, y: 10, width: 1, height: 20))
        lab.backgroundColor = RGBColor(r: 216, g: 216, b: 216)
        lab.isHidden = true
        
        return lab
    }()
    
    // 内容展示
    public func setCellDatas(value: String, index: NSInteger) {
        
        self.labels.text = value
        
        if index % 2 == 0
        {
            self.lines.isHidden = false
        }
        else
        {
            self.lines.isHidden = true
        }
    }
    
}
