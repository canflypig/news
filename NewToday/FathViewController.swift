//
//  FathViewController.swift
//  NewToday
//
//  Created by iMac on 2019/9/23.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

class FathViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addBackBtn()
        
    }
    
    
    // 设置页返回按钮
    private func addBackBtn(){
        
        // 隐藏导航栏下面的黑线
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.view.backgroundColor = UIColor.white
        // 隐藏系统返回按钮
        self.navigationController?.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        // 自定义返回按钮样式
        let leftBtn:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_img")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(actionBack))
        
        self.navigationItem.leftBarButtonItem = leftBtn;
        
    }
    
    //返回按钮事件
    @objc func actionBack(){
        self.navigationController?.popViewController(animated: true);
        
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
