//
//  WatersTableViewCell.swift
//  NewToday
//
//  Created by iMac on 2019/10/17.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

import BMPlayer

import SwiftyJSON

class WatersTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(playView)
        self.contentView.addSubview(headImg)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(guanZhuBtn)
        self.contentView.addSubview(moreBtn)
        self.contentView.addSubview(inforBtn)
        
        creatUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 视频播放UI
    private lazy var playView : BMPlayer = {
        
        let playV = BMPlayer.init(customControlView: videoView())
        
        return playV
    }()
    // 来源头像
    private lazy var headImg : UIImageView = {
        
        let img = UIImageView.init()
        img.layer.cornerRadius = 20
        img.layer.masksToBounds = true
        img.backgroundColor = UIColor.orange
        img.image = UIImage(named: "water_img_Def")
        
        return img
    }()
    // 来源名称
    private lazy var nameLabel : UILabel = {
        
        let label = UILabel.init()
        label.text = "鲤鱼影视"
        label.textColor = RGBColor(r: 34, g: 34, b: 34)
        label.font = customFont(font: 14)
        
        return label
    }()
    // 关注按钮
    private lazy var guanZhuBtn : UIButton = {
        
        let btn = UIButton.init(type: .roundedRect)
        btn.setTitle("关注", for: .normal)
        btn.setTitleColor(RGBColor(r: 248, g: 89, b: 89), for: .normal)
        btn.titleLabel?.font = customFont(font: 14)
        
        
        return btn
    }()
    // 更多按钮
    private lazy var moreBtn : UIButton = {
        
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage(named: "water_more"), for: .normal)
        
        return btn
    }()
    // 评论数量按钮
    private lazy var inforBtn : UIButton = {
        
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage(named: "water_num"), for: .normal)
        btn.setTitle("  1232", for: .normal)
        btn.setTitleColor(RGBColor(r: 34, g: 34, b: 34), for: .normal)
        btn.titleLabel?.font = customFont(font: 12)
        
        btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        
        return btn
    }()
}


extension WatersTableViewCell
{
    // 对应控件位置属性
    private func creatUI() {
        
        playView.snp.makeConstraints { (make) in
            
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(self.contentView.snp_bottom).offset(-63)
        }
        
        headImg.snp.makeConstraints { (make) in
            
            make.left.equalTo(15)
            make.bottom.equalTo(-11)
            make.width.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            
            make.left.equalTo(self.headImg.snp_right).offset(12)
            make.bottom.equalTo(-11)
            make.width.lessThanOrEqualTo(150)
            make.height.equalTo(40)
        }
        
        guanZhuBtn.snp.makeConstraints { (make) in
            
            make.left.equalTo(self.nameLabel.snp_right).offset(18)
            make.bottom.equalTo(-11)
            make.width.lessThanOrEqualTo(40)
            make.height.equalTo(40)
        }
        
        moreBtn.snp.makeConstraints { (make) in
            
            make.right.equalTo(self.contentView.snp_right).offset(-15)
            make.bottom.equalTo(-21)
            make.width.height.equalTo(20)
        }
        
        inforBtn.snp.makeConstraints { (make) in
            
            make.right.equalTo(self.moreBtn.snp_left).offset(-28)
            make.bottom.equalTo(-21)
            make.width.lessThanOrEqualTo(70)
            make.height.equalTo(20)
        }
    }
    
    
    public func cellDatas(value: JSON) {
        
        self.headImg.kf.setImage(with: URL(string: value["fromImage"].stringValue), placeholder: UIImage(named: "water_img_Def"), options: nil, progressBlock: nil, completionHandler: nil)
        
        self.nameLabel.text = value["videoFrom"].stringValue
        self.inforBtn.setTitle("  "+value["videoCommentNum"].stringValue, for: .normal)
        
        let strUrl = value["videoUrl"].stringValue
        
        let videoUrl = URL(string: strUrl) ?? URL(string: def_url)!
        
        let asset = BMPlayerResource(url: videoUrl, name: value["videoName"].stringValue, cover: URL(string: value["videoImg"].stringValue), subtitle: nil)
        
        playView.setVideo(resource: asset)
        
    }
    
}
