//
//  FourTableViewCell.swift
//  NewToday
//
//  Created by iMac on 2019/10/16.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

import SwiftyJSON

class FourTableViewCell: UITableViewCell {
    
    // 内容名称
    @IBOutlet weak var namtTitle: UILabel!
    // 发布者头像
    @IBOutlet weak var fromImg: UIImageView!
    // 来源信息（评论数量，发布时间）
    @IBOutlet weak var fromInfor: UILabel!
    
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
    public func cellFourData(value: JSON) {
        
        // n名称
        self.namtTitle.text = value["contentName"].stringValue
        
        // 加载图片（路径）
        self.fromImg.kf.setImage(with: URL(string: value["media_info"]["avatar_url"].stringValue))
        
        // 其它信息
        self.fromInfor.text = value["media_info"]["name"].stringValue + "  \(value["contentCommentNum"].stringValue)评论" + value["contentReleaseTime"].stringValue
    }
    
}

// 属性设置
extension FourTableViewCell
{
    private func setUI() {
        
        self.namtTitle.font = customFont(font: titleFont)
        self.fromInfor.font = customFont(font: 12)
        self.fromImg.layer.cornerRadius = 15
        self.fromImg.layer.masksToBounds = true
    }
}
