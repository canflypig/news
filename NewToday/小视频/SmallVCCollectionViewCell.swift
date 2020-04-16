//
//  SmallVCCollectionViewCell.swift
//  NewToday
//
//  Created by iMac on 2019/10/18.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

import SwiftyJSON

class SmallVCCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var def_img: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var num_play: UILabel!
    
    @IBOutlet weak var num_zan: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

// 赋值
extension SmallVCCollectionViewCell
{
    public func cellData(value: JSON) {
        
        self.def_img.kf.setImage(with: URL(string: value["videoImg"].stringValue), placeholder: UIImage(named: "mp4_def"), options: nil, progressBlock: nil, completionHandler: nil)
        
        self.titleLabel.text = value["videoTitle"].stringValue
        self.num_play.text = value["playNum"].stringValue+"次播放"
        self.num_zan.text = value["fabulousNum"].stringValue+"赞"
    }
}
