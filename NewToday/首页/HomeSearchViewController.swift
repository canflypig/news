//
//  HomeSearchViewController.swift
//  NewToday
//
//  Created by iMac on 2019/9/29.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

class HomeSearchViewController: UIViewController {
    
    // 当前statusBar使用的样式
    var style: UIStatusBarStyle = .lightContent
    // 重现statusBar相关方法
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.style
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 添加头部视图
        self.view.addSubview(topView)
        // 添加内容视图
        self.view.addSubview(searView)
        
    }
    // 头部搜索视图
    private lazy var topView : SearchTopView = {
        
        let horse = SearchTopView.loadFromNib()
        horse.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kNavigationBarH+8)
        horse.cancelBtn.addTarget(self, action: #selector(setPopView), for: .touchUpInside)
        
        return horse
    }()
    
    // 返回上一页
    @objc private func setPopView() {
        self.navigationController?.popViewController(animated: false)
    }
    
    // 点击空白退出编辑
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        topView.searchText.resignFirstResponder()
    }
    // 页面出现时进入编辑状态
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        topView.searchText.becomeFirstResponder()
    }
    // 页面消失时退出编辑状态
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
        topView.searchText.resignFirstResponder()
    }
    // 推荐内容视图
    private lazy var searView : SearchHomeView = {
        
        let sear_View = SearchHomeView.init(frame: CGRect(x: 0, y: kNavigationBarH+8, width: kScreenW, height: kScreenH-kNavigationBarH-8))
        sear_View.backgroundColor = UIColor.gray
        sear_View.delegate = self
        
        return sear_View
    }()

}

extension HomeSearchViewController : SearchItemDelegte
{
    func itemChange(value: String) {
        
        topView.searchText.resignFirstResponder()
        
        print(value)
    }
}
