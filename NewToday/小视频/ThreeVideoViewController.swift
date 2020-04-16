//
//  ThreeVideoViewController.swift
//  NewToday
//
//  Created by iMac on 2019/9/1.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

class ThreeVideoViewController: UIViewController {
    
    // 页面滑动内容视图
    var contentVC:SmallVCViewController?
    // 子控制器
    var childArr = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        // 隐藏系统导航
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let arrList: NSArray = ["关注","推荐","附近","活动","游戏"]
        
        self.creatHomeViews(value: arrList)
        
    }
    
    // 头部标签和内容滑动视图
    private func creatHomeViews(value: NSArray) {
        
        // 标签
        let titles = value
        
        for _ in 0..<titles.count
        {
            // 初始化要显示控制器
            contentVC = SmallVCViewController()
            
            // 添加所有控制器到数组
            childArr.append(contentVC!)
        }
        
        // 初始化首页内容视图
        let homeV = HomeTitleView.init(frame: CGRect(x: 0, y: kStatusBarH+8, width: kScreenW, height: kScreenH-kStatusBarH-kTabBarH), titlesList: titles as! [String], childs: childArr)
        
        self.view.addSubview(homeV)
        
    }

    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
