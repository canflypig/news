//
//  videoView.swift
//  NewToday
//
//  Created by iMac on 2019/10/17.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

import BMPlayer

class videoView: BMPlayerControlView {
    
    override func customizeUIComponents() {
        BMPlayerConf.shouldAutoPlay = false
        backButton.removeFromSuperview()
        fullscreenButton.removeFromSuperview()
    }
    
    var playerTitleLabel        : UILabel?  { get { return  titleLabel } }
    var playerCurrentTimeLabel  : UILabel?  { get { return  currentTimeLabel } }
    var playerTotalTimeLabel    : UILabel?  { get { return  totalTimeLabel } }

    var playerPlayButton        : UIButton? { get { return  playButton } }
//    var playerFullScreenButton  : UIButton? { get { return  fullscreenButton } }
//    var playerBackButton        : UIButton? { get { return  backButton } }
//
    var playerTimeSlider        : UISlider? { get { return  timeSlider } }
    var playerProgressView      : UIProgressView? { get { return  progressView } }
//
//    // 若不存在，则直接返回 nil
//    var playerSlowButton        : UIButton? { get { return  nil } }
//    var playerMirrorButton      : UIButton? { get { return  nil } }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        creaUI()
        
        setUI()
    }
    
}

extension videoView
{
    func setUI() {
        
        playerTitleLabel?.snp.makeConstraints({ (make) in
            
            make.top.equalTo(10)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.lessThanOrEqualTo(40)
        })

//        playerPlayButton?.snp.makeConstraints({ (make) in
//
//            make.center.equalTo(superview!.snp.center)
//            make.width.height.equalTo(50)
//        })
//
        playerCurrentTimeLabel?.snp.makeConstraints({ (make) in

            make.left.equalTo(playerPlayButton!.snp_right).offset(10)
            make.bottom.equalTo(0)
            make.width.equalTo(40)
        })

        playerTotalTimeLabel?.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(playerCurrentTimeLabel!)
            make.right.equalTo(-30)
            make.width.equalTo(40)
        }
        
        playerTimeSlider?.snp.makeConstraints { (make) in

            make.centerY.equalTo(playerCurrentTimeLabel!)
            make.left.equalTo(playerCurrentTimeLabel!.snp_right).offset(10)
            make.right.equalTo(playerTotalTimeLabel!.snp_left).offset(-10)
            make.height.equalTo(30)
        }

        playerProgressView?.snp.makeConstraints { (make) in

            make.centerY.left.right.equalTo(playerTimeSlider!)
            make.height.equalTo(2)
        }

        

//        playerFullScreenButton?.snp.makeConstraints { (make) in
//
//            make.width.equalTo(50)
//            make.height.equalTo(50)
//            make.centerY.equalTo(playerCurrentTimeLabel!)
//            make.left.equalTo(playerTotalTimeLabel!.snp.right)
//            make.right.equalToSuperview()
//        }
    }
    
    func creaUI () {
        //self.addSubview(playerPlayButton!)
        
        playerTitleLabel?.numberOfLines = 0
        
//        playerPlayButton?.setImage(UIImage(named: "play_play"), for: .normal)
//        playerPlayButton?.setImage(UIImage(named: "play_stop"), for: .selected)
    }
    
}
