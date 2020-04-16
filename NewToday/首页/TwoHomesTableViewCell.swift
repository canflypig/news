//
//  TwoHomesTableViewCell.swift
//  NewToday
//
//  Created by iMac on 2019/9/27.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

import SwiftyJSON

class TwoHomesTableViewCell: UITableViewCell {
    
    // 视频文字
    @IBOutlet weak var titleName: UILabel!
    // 视频播放背景视图
    @IBOutlet weak var onlyImg: UIImageView!
    // 视频其它信息/来源/作者/发布时间
    @IBOutlet weak var videoInfo: UILabel!
    
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
    public func cellTwoData(value: JSON) {
        
        self.titleName.text = value["contentName"].stringValue
        
        self.onlyImg.kf.setImage(with: URL(string: value["image_list"][0]["url"].stringValue))
        
        self.videoInfo.text = value["media_info"]["name"].stringValue + "  \(value["contentCommentNum"].stringValue)评论" + value["contentReleaseTime"].stringValue
    }
    
}

// 属性设置
extension TwoHomesTableViewCell
{
    private func setUI() {
        
        self.titleName.font = customFont(font: titleFont)
        self.videoInfo.font = customFont(font: 12)
    }
}
