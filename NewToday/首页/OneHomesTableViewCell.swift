//
//  OneHomesTableViewCell.swift
//  NewToday
//
//  Created by iMac on 2019/9/27.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

import SwiftyJSON

class OneHomesTableViewCell: UITableViewCell {
    
    // 置顶文字
    @IBOutlet weak var topText: UILabel!
    // 红色置顶文字
    @IBOutlet weak var topRed: UILabel!
    // 置顶内容其它信息/来源/评论数量
    @IBOutlet weak var topFrom: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUI()
    }
    
    // cell赋值
    public func cellData(value: JSON) {
        
        self.topText.text = value["contentName"].stringValue
        self.topFrom.text = value["contentFrom"].stringValue + "  \(value["contentCommentNum"].stringValue)评论"
    }
    
    
}

// 属性设置
extension OneHomesTableViewCell
{
    private func setUI() {
        
        self.topText.font = customFont(font: titleFont)
        self.topRed.font = customFont(font: 12)
        self.topFrom.font = customFont(font: 12)
    }
}
