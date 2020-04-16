//
//  TabBarViewController.swift
//  NewToday
//
//  Created by iMac on 2019/9/1.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    var indexFlag = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addControllers()
        
        UserDefaults.standard.setValue(1, forKey: "tabbarIndex")
        
        // tabbar背景色
        self.tabBar.barTintColor = UIColor.white
        
    }
    
    // 添加控制器
    private func addControllers() {
        
        addChildControllers(ViewController(), title: "首页", image: "tabbat_one_n", selectImg: "tabbat_one_s")
        addChildControllers(TwoVideoViewController(), title: "西瓜视频", image: "tabbat_two_n", selectImg: "tabbat_two_s")
        addChildControllers(ThreeVideoViewController(), title: "小视频", image: "tabbat_three_n", selectImg: "tabbat_three_s")
        addChildControllers(MineViewController(), title: "我的", image: "tabbat_four_n", selectImg: "tabbat_four_s")
    }
    
    // 自定义tabbar对应控制器初始化方法
    private func addChildControllers(_ childVC: UIViewController, title: String, image :String, selectImg :String) {
        
        // item文字
        childVC.tabBarItem.title = title
        // 未选中图片
        childVC.tabBarItem.image = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
        // 选中图片
        childVC.tabBarItem.selectedImage = UIImage(named: selectImg)?.withRenderingMode(.alwaysOriginal)
        // 选中文字颜色
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: RGBColor(r: 245, g: 90, b: 93)], for: .selected)
        
        // 头部导航
        let nav = UINavigationController()
        nav.navigationBar.barTintColor = UIColor.white
        nav.addChild(childVC)
        addChild(nav)
        
    }
    
    // 点击item方法
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if let index = tabBar.items?.firstIndex(of: item)
        {
            if indexFlag != index
            {
                animationWithIndex(index: index)
            }
        }
        
        switch indexFlag {
        case 0:
            UserDefaults.standard.setValue(1, forKey: "tabbarIndex")
        case 1:
            UserDefaults.standard.setValue(2, forKey: "tabbarIndex")
        case 2:
            UserDefaults.standard.setValue(3, forKey: "tabbarIndex")
        default:
            print("def")
        }
        
    }
    
    // 实现缩放动画
    private func animationWithIndex(index : Int) {
        
        var arrViews = [UIView]()
        
        // 遍历tabbar子视图拿到可点击的item加入到数组
        for tabbarButton in tabBar.subviews {
            
            if tabbarButton .isKind(of: NSClassFromString("UITabBarButton")!)
            {
                arrViews.append(tabbarButton)
            }
        }
        
        // 缩放动画
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        
        // 动画函数
        pulse.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        // 动画执行时间
        pulse.duration = 0.1
        
        // 执行次数
        pulse.repeatCount = 1
        
        // 执行完复位
        pulse.autoreverses = true
        
        // 开始动画缩小倍数
        pulse.fromValue = NSNumber(value: 0.7)
        
        // 放大倍数
        pulse.toValue = NSNumber(value: 1.0)
        
        // 添加动画到item
        arrViews[index].layer.add(pulse, forKey: nil)
        
        indexFlag = index
        
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
