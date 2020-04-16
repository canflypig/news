//
//  TwoVideoViewController.swift
//  NewToday
//
//  Created by iMac on 2019/9/1.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

import SwiftyJSON

class TwoVideoViewController: UIViewController {
    
    // 当前statusBar使用的样式
    var style: UIStatusBarStyle = .lightContent
    // 重现statusBar相关方法
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.style
    }
    
    // 页面滑动内容视图
    var contentVC:WatersViewController?
    // 子控制器
    var childArr = [UIViewController]()
    // 接口请求参数
    var dicList = [String: Any]()
    // 标签数组
    var arrTitle = NSMutableArray()
    // 标签id数组
    var arrId = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 隐藏系统导航
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // 添加头部搜索/标签/内容滑动视图
        self.view.addSubview(horseView)
        
        // 获取数据
        requestData()
        
    }
    
    // 头部搜索视图
    private lazy var horseView : HomeHorseView = {
        
        let horse = HomeHorseView.loadFromNib()
        horse.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kNavigationBarH+8)
        horse.delegate = self
        
        return horse
    }()
    
    // 获取数据
    private func requestData() {
        
        let token = UserDefaults.standard.object(forKey: "token") as? String
        
        dicList = ["type":"2",
                   "token":token ?? ""
        ]
        
        // 获取标签数据接口
        HttpDatas.shareInstance.requestUserDatas(.get, URLString: todatAddres+"/user/news/homeTitles", paramaters: dicList) { (respnse) in
            
            let jsonData = JSON(respnse)
            
            if jsonData["code"].stringValue == "100"
            {
                // 遍历拿到需要的标签和id
                for (_,dic) in jsonData["data"]
                {
                    let strName = dic["name"].stringValue
                    let strId = dic["term_id"].stringValue
                    
                    self.arrTitle.add(strName)
                    self.arrId.add(strId)
                }
                
                // 刷新UI
                self.creatHomeViews(value: self.arrTitle)
            }
            
        }
        
    }
    
    // 头部标签和内容滑动视图
    private func creatHomeViews(value: NSArray) {
        
        // 标签
        let titles = value
        
        for _ in 0..<titles.count
        {
            // 初始化要显示控制器
            contentVC = WatersViewController()
            
            // 添加所有控制器到数组
            childArr.append(contentVC!)
        }
        
        // 闭包传值
        contentVC?.passCellData(value: self.arrId[0] as! String)
        
        // 初始化首页内容视图
        let homeV = HomeTitleView.init(frame: CGRect(x: 0, y: kNavigationBarH+8, width: kScreenW, height: kScreenH-kNavigationBarH-kTabBarH), titlesList: titles as! [String], childs: childArr)
        homeV.delegate = self
        
        self.view.addSubview(homeV)
       
    }

}


//HomeSearchDelegte
extension TwoVideoViewController : HomeSearchDelegte
{
    func searchChange() {
        print("搜索")
        
        self.navigationController?.pushViewController(HomeSearchViewController(), animated: false)
    }
}


// HomeTopTypeDelegte
extension TwoVideoViewController : HomeTopTypeDelegte
{
    func clicksTitle(value: NSInteger) {
        print("标签")
        
        // 闭包传值
        contentVC?.passCellData(value: self.arrId[value] as! String)
    }
    
    func homeTopClassChange() {
        print("123")
    }
}
