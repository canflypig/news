//
//  refeshHead.swift
//  NewToday
//
//  Created by iMac on 2019/9/29.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit
import MJRefresh

class refeshHead: MJRefreshGifHeader {
    
    // 初始化刷新样式
    override func prepare() {
        super.prepare()
        
        // 隐藏自带的上次刷新时间
        lastUpdatedTimeLabel.isHidden = true
        
        // 图片数组
        var images = [UIImage]()
        // 遍历方法存图片到数组
        for index in 0..<16 {
            let image = UIImage(named: "refresh_\(index)")
            images.append(image!)
        }
        // 设置空闲状态的图片
        setImages(images, for: .idle)
        // 设置刷新状态的图片
        setImages(images, for: .refreshing)
        setTitle("下拉刷新", for: .idle)
        setTitle("松开刷新", for: .pulling)
        setTitle("刷新中", for: .refreshing)
        
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        gifView.contentMode = .center
        gifView.frame = CGRect(x: 0, y: 4, width: mj_w, height: 25)
        stateLabel.font = UIFont.systemFont(ofSize: 12)
        stateLabel.frame = CGRect(x: 0, y: 35, width: mj_w, height: 14)
    }
    

}
