//
//  ViewController.swift
//  NewToday
//
//  Created by iMac on 2019/9/1.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

import SwiftyJSON

class ViewController: UIViewController {
    
    // 当前statusBar使用的样式
    var style: UIStatusBarStyle = .lightContent
    // 重现statusBar相关方法
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.style
    }
    // 页面滑动内容视图
    var contentVC:HomeScrViewController?
    // 弹出的登陆view最终y点
    var loginViewOriginY: CGFloat!
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
        
        // 登陆页最终y坐标点
        loginViewOriginY = kStatusBarH
        
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
        
        dicList = ["type":"1",
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
        let titles = value //["关注","推荐","关注","推荐","关注","推荐","关注","推荐","关注","推荐","关注","推荐"]
        
        for _ in 0..<titles.count
        {
            // 初始化要显示控制器
            contentVC = HomeScrViewController()
            
            // 添加所有控制器到数组
            childArr.append(contentVC!)
        }
        
        // 闭包传值
        contentVC?.passValueTitle(value: self.arrId[0] as! String, curIndex: 0)
        
        // 初始化首页内容视图
        let homeV = HomeTitleView.init(frame: CGRect(x: 0, y: kNavigationBarH+8, width: kScreenW, height: kScreenH-kNavigationBarH-kTabBarH), titlesList: titles as! [String], childs: childArr)
        homeV.delegate = self
        
        self.view.addSubview(homeV)
        
        // 添加灰色背景和频道弹框
        self.view.addSubview(grayView)
        self.view.addSubview(typeView)
    }
    
    
    // 懒加载灰色背景
    private lazy var grayView : UIView = {
        
        let gray = UIView.init(frame: self.view.bounds)
        gray.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        gray.alpha = 0.0
        
        return gray
    }()
    
    // 懒加载白色圆角登陆背景
    private lazy var typeView : HomeTypeView = {
        
        let cl_view = HomeTypeView()
        cl_view.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: kScreenH)
        cl_view.layer.cornerRadius = 10
        cl_view.layer.masksToBounds = true
        cl_view.backgroundColor = UIColor.white
        cl_view.delegate = self
        
        // 给弹出的登陆视图添加一个可以下移的拖动手势
        let panView = UIPanGestureRecognizer.init(target: self, action: #selector(pan(panGuesture:)))
        cl_view.addGestureRecognizer(panView)
        
        return cl_view
    }()
    
}

// HomeTopTypeDelegte
extension ViewController : HomeTopTypeDelegte
{
    func clicksTitle(value: NSInteger) {
        print("标签")
        
        // 闭包传值
        contentVC?.passValueTitle(value: self.arrId[value] as! String, curIndex: 1)
    }
    
    func homeTopClassChange() {
        btnClick()
    }
}

// 弹出分类视图
extension ViewController
{
    // 在这里弹出登陆视图操作
    @objc private func btnClick() {
        
        // 先隐藏导航和tabbar
        creatHidden(value: 1, time: 0.1)
        
        // 弹出登陆动画
        UIView.animate(withDuration: 0.5) {
            self.typeView.frame = CGRect(x: 0, y: kStatusBarH/2, width: kScreenW, height: kScreenH)
            
            self.grayView.alpha = 1.0
        }
        
        // 开始弹出登陆后延时执行下移一定距离
        self.perform(#selector(downMove), with: nil, afterDelay: 0.5)
    }
    
    // 登陆弹出后自动下移到状态栏下面
    @objc func downMove() {
        
        UIView.animate(withDuration: 0.2) {
            self.typeView.frame = CGRect(x: 0, y: kStatusBarH, width: kScreenW, height: kScreenH)
            
            self.grayView.alpha = 1.0
        }
    }
    
    // 这里判断是否隐藏导航和tabbar
    private func creatHidden(value:NSInteger, time:TimeInterval) {
        
        if value == 1
        {
            self.tabBarController?.tabBar.isHidden = true
        }
        else
        {
            self.perform(#selector(hidTabbar), with: nil, afterDelay: time)
        }
    }
    
    // tabbar没有动画所以延时后和导航同时显示
    @objc func hidTabbar() {
        
        self.tabBarController?.tabBar.isHidden = false
    }
}

// 拖动分类视图
extension ViewController
{
    // 拖动登陆视图时只允许向下拖动
    @objc private func pan(panGuesture:UIPanGestureRecognizer) {
        
        // 开始拖动
        if panGuesture.state == .began {
            //print("开始拖动")
        }
            // 拖动过程
        else if panGuesture.state == .changed {
            
            // 拖动后的y坐标
            let y = panGuesture.translation(in: self.view).y
            
            //滑动状态栏下面后不允许往上拖动
            if y <= kStatusBarH
            {
                self.typeView.frame = CGRect(x: 0, y: kStatusBarH, width: kScreenW, height: kScreenH)
            }
                // 只允许往下拖动
            else
            {
                self.typeView.frame = CGRect(x: 0, y: loginViewOriginY+y, width: kScreenW, height: kScreenH)
            }
            
            // 根据scrollview的偏移量属性来动态改变灰色背景的透明度
            var scrolAlpha = self.typeView.frame.origin.y/kScreenH/2
            
            if scrolAlpha > 0.5
            {
                scrolAlpha = 0.5
            }
            
            // 灰色背景的透明度
            self.grayView.alpha = 1-scrolAlpha
        }
            // 拖动结束
        else if panGuesture.state == .ended
        {
            // 拖动结束判断拖动偏移量是否超过屏幕的一半，没有泽回弹
            if self.typeView.frame.origin.y <= kScreenH/2
            {
                UIView.animate(withDuration: 0.25) {
                    self.typeView.frame = CGRect(x: 0, y: self.loginViewOriginY, width: kScreenW, height: kScreenH)
                    
                    self.grayView.alpha = 1.0
                }
            }
                // 超过则自动滑动到底部消失
            else
            {
                // 隐藏登陆view
                hiddenLoginView(tim: 0.25)
            }
            
        }
    }
        
        
    // 隐藏登陆页
    private func hiddenLoginView(tim:TimeInterval) {
        UIView.animate(withDuration: tim) {
            self.typeView.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: kScreenH)
            
            self.grayView.alpha = 0.0
        }
        creatHidden(value: 0, time: 0.25)
    }
        
}

// HomeChannlDelegte
extension ViewController : HomeChannlDelegte
{
    func channlChange() {
        // 隐藏分类view
        hiddenLoginView(tim: 0.5)
    }
}

//HomeSearchDelegte
extension ViewController : HomeSearchDelegte
{
    func searchChange() {
        print("搜索")
        
        self.navigationController?.pushViewController(HomeSearchViewController(), animated: false)
    }
}
