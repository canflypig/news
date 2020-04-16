//
//  ThreeHomesTableViewCell.swift
//  NewToday
//
//  Created by iMac on 2019/9/27.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

import SwiftyJSON

class ThreeHomesTableViewCell: UITableViewCell {
    
    // 内容名称
    @IBOutlet weak var imagesTopTile: UILabel!
    // 内容信息/来源/评论/发布时间
    @IBOutlet weak var imagesInfor: UILabel!
    // 第一张图片
    @IBOutlet weak var firstImg: UIImageView!
    // 第二张图片
    @IBOutlet weak var twoImg: UIImageView!
    // 第三张图片
    @IBOutlet weak var threeImg: UIImageView!
    
    
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
    public func cellThreeData(value: JSON) {
        
        self.imagesTopTile.text = value["contentName"].stringValue
        
        self.firstImg.kf.setImage(with: URL(string: value["image_list"][0]["url"].stringValue))
        self.twoImg.kf.setImage(with: URL(string: value["image_list"][1]["url"].stringValue))
        self.threeImg.kf.setImage(with: URL(string: value["image_list"][2]["url"].stringValue))
        
        self.imagesInfor.text = value["media_info"]["name"].stringValue + "  \(value["contentCommentNum"].stringValue)评论" + value["contentReleaseTime"].stringValue
    }
    
}

// 属性设置
extension ThreeHomesTableViewCell
{
    private func setUI() {
        
        self.imagesTopTile.font = customFont(font: titleFont)
        self.imagesInfor.font = customFont(font: 12)
    }
}
