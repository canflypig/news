//
//  SetSViewController.swift
//  NewToday
//
//  Created by iMac on 2019/9/7.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

class SetSViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    // 默认文字数组
    var arrList = NSArray()
    // 所有cell高度数组
    var heightArray = NSMutableArray()
    // cell副标题数组
    var detiArray = NSMutableArray()
    // 通知是否打开
    var isSwitch : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "设置"
        
        caratDatas()                // 页面默认信息处理
        
        addBackBtn()                // 返回按钮
        
        view.addSubview(tableV)     // 添加表格
        
    }
    
    // 默认信息数组
    private func caratDatas() {
        
        // 默认文字数组
        self.arrList = [["夜间模式","清理缓存","字体大小","列表显示摘要","非WIFI网络流量","非WIFI网络播放提醒","推送通知","提示赢开关","H5广告过滤"],["允许给我推荐可能认识的人"],["广告设置"],["头条封面","关于头条"]]
        
        // 子标题数组
        self.detiArray = [["","0.00MB","中","","最佳效果(下载大图)","提醒一次","","",""],[""],[""],["",""]]
        
        // cell高度数组
        for (curInt,array) in self.arrList.enumerated() {
            
            let curArr = NSMutableArray()
            
            for index in 0..<(array as AnyObject).count
            {
                if curInt == 0 && index == (array as AnyObject).count - 1
                {
                    curArr.addObjects(from: [customLayer(num: 72)])
                }
                else
                {
                    curArr.addObjects(from: [customLayer(num: 47)])
                }
            }
            
            self.heightArray.add(curArr)
        }
        
        
    }
    
    // 设置页返回按钮
    private func addBackBtn() {
        
        // 设置页面白色背景色  隐藏导航栏系统返回按钮
        self.view.backgroundColor = UIColor.white
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        // 隐藏导航栏下面的黑线  设置导航白色背景
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        // 自定义返回按钮样式
        let leftBtn:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_img")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(actionBackClick))
        self.navigationItem.leftBarButtonItem = leftBtn
        
    }
    
    //返回按钮事件
    @objc func actionBackClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // 页面出现时隐藏导航
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // 页面消失时显示导航
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // table初始化
    private lazy var tableV : UITableView = {
        
        let table = UITableView.init(frame: CGRect(x: 0, y: kNavigationBarH, width: kScreenW, height: kScreenH-kNavigationBarH), style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView.init()
        
        return table
    }()

}

// UITableViewDelegate,UITableViewDataSource
extension SetSViewController
{
    // 分区数量
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrList.count
    }
    // 每区行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.arrList[section] as! NSArray).count
    }
    // 行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.heightArray[indexPath.section] as! Array)[indexPath.row]
    }
    // 分区头高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 41 : 10
    }
    // 分区尾高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 3 ? 114 : 0.01
    }
    // 分区头视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let head_view = UIView()
        let head_label = UILabel(frame: CGRect(x: 20, y: 0, width: kScreenW-40, height: 41))
        head_label.text = "隐私设置"
        head_label.font = customFont(font: 12)
        head_label.textColor = RGBColor(r: 153, g: 153, b: 153)
        head_view.addSubview(head_label)
        
        return section == 1 ? head_view : nil
    }
    // 分区尾视图
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let foot_view = UIView()
        let foot_label = UILabel(frame: CGRect(x: 20, y: 83, width: kScreenW-40, height: 14))
        foot_label.text = "All Rights Reserved By Toutiao.com"
        foot_label.font = customFont(font: 14)
        foot_label.textColor = RGBColor(r: 153, g: 153, b: 153)
        foot_label.textAlignment = .center
        foot_view.addSubview(foot_label)
        
        return section == 3 ? foot_view : nil
    }
    // cell内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell
        var cell = tableView.cellForRow(at: indexPath)
        var cellValue = tableView.dequeueReusableCell(withIdentifier: "sellValue")
        
        if cell == nil
        {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "seller")
        }
        
        if cellValue == nil
        {
            cellValue = UITableViewCell.init(style: .value1, reuseIdentifier: "sellValue")
        }
        
        // cell 属性（颜色、字体、大小）
        cell?.textLabel?.text = ((self.arrList[indexPath.section] as! NSArray)[indexPath.row] as! String)
        cell?.textLabel?.font = customFont(font: 16)
        cell?.textLabel?.textColor = RGBColor(r: 34, g: 34, b: 34)
        
        // cellValue 属性（颜色、字体、大小）
        cellValue?.textLabel?.text = ((self.arrList[indexPath.section] as! NSArray)[indexPath.row] as! String)
        cellValue?.textLabel?.font = customFont(font: 16)
        cellValue?.textLabel?.textColor = RGBColor(r: 34, g: 34, b: 34)
        cellValue?.detailTextLabel?.text = ((self.detiArray[indexPath.section] as! NSArray)[indexPath.row] as! String)
        cellValue?.detailTextLabel?.font = customFont(font: 14)
        cellValue?.detailTextLabel?.textColor = RGBColor(r: 153, g: 153, b: 153)
        
        // switch 开关
        let heightCell = (self.heightArray[indexPath.section] as! NSMutableArray)[indexPath.row] as! CGFloat
        
        let styleSwitch = UISwitch(frame: CGRect(x: kScreenW-66, y: heightCell/2-15, width: 51, height: 31))
        styleSwitch.tag = indexPath.row
        styleSwitch.addTarget(self, action: #selector(switchChange(switchCell:)), for: .valueChanged)
        
        if indexPath.section == 0 && indexPath.row == 6
        {
            styleSwitch.isOn = isSwitch
        }

        // 指定cell添加switch开关
        if indexPath.section == 0 && indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8 || indexPath.section == 1 && indexPath.row == 0
        {
            cell?.contentView.addSubview(styleSwitch)
        }
        
        // cell 内容处理
        if indexPath.section == 0
        {
            if indexPath.row == 6
            {
                if !isSwitch
                {
                    cell?.detailTextLabel?.text = "你可能错过重要资讯通知，点击去设置允许通知"
                    cell?.detailTextLabel?.textColor = RGBColor(r: 229, g: 100, b: 95)
                    cell?.detailTextLabel?.font = customFont(font: 12)
                }
            }
            if indexPath.row == 8
            {
                cell?.detailTextLabel?.text = "智能过滤网络广告，为你节省更多流量"
                cell?.detailTextLabel?.textColor = RGBColor(r: 153, g: 153, b: 153)
                cell?.detailTextLabel?.font = customFont(font: 12)
            }
        }
        
        // 返回指定cell
        if indexPath.section == 0
        {
            if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 5
            {
                return cellValue!
            }
        }
        else
        {
            return cell!
        }
        
        return cell!
    }
    // switch改变
    @objc func switchChange(switchCell:UISwitch) {
        
        print(switchCell.tag)
        
        guard switchCell.tag != 6 else {
            
            var one_array = NSMutableArray()
            
            one_array = self.heightArray[0] as! NSMutableArray
            
            if switchCell.isOn
            {
                one_array.replaceObject(at: 6, with: customLayer(num: 47))
                
                self.heightArray.replaceObject(at: 0, with: one_array)
                
                isSwitch = true
            }
            else
            {
                one_array.replaceObject(at: 6, with: customLayer(num: 72))
                
                self.heightArray.replaceObject(at: 0, with: one_array)
                
                isSwitch = false
            }
            
            tableV.reloadData()
            
            return
        }
    }
    // 点击cell时处理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        var sheetTitle = ""
        var arrSheet = NSArray()
        
        if indexPath.section == 0
        {
            if indexPath.row == 1
            {
                sheetTitle = "确定清除所有缓存？问答草稿、离线内容以及图片均会被清除"
                arrSheet = ["确定"]
                creatSheetUI(title: sheetTitle, titleArray: arrSheet, currentRow: indexPath.row)
            }
            if indexPath.row == 2
            {
                sheetTitle = "设置字体大小"
                arrSheet = ["小","中","大","特大"]
                creatSheetUI(title: sheetTitle, titleArray: arrSheet, currentRow: indexPath.row)
            }
            if indexPath.row == 4
            {
                sheetTitle = "非WIfi网络流量"
                arrSheet = ["最佳效果(下载大图)","较省流量(智能下图)","极省流量(不下载图)"]
                creatSheetUI(title: sheetTitle, titleArray: arrSheet, currentRow: indexPath.row)
            }
            if indexPath.row == 5
            {
                sheetTitle = "非WIFI网络播放提醒"
                arrSheet = ["每次提醒","提醒一次"]
                creatSheetUI(title: sheetTitle, titleArray: arrSheet, currentRow: indexPath.row)
            }
        }
        
    }
    
}

// 底部弹框
extension SetSViewController
{
    private func creatSheetUI(title: String, titleArray: NSArray, currentRow: NSInteger) {
        
        // 底部弹框
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        for alertString in titleArray {
            
            let alertAct = UIAlertAction(title: alertString as? String, style: .default) { (alert) in
                
                //print(alert.title!)
                
                self.loadDetiArray(value: alert.title!, curIndex: currentRow)
            }
            
            alertController.addAction(alertAct)
        }
        
        let cancelAct = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAct)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 更新当前点击内容
    private func loadDetiArray(value: String, curIndex: NSInteger) {
        
        guard curIndex == 1 else {
            
            var deti_Arr = NSArray()
            deti_Arr = self.detiArray[0] as! NSArray
            
            let deti_array = NSMutableArray()
            for curString in deti_Arr
            {
                deti_array.add(curString)
            }
            
            deti_array.replaceObject(at: curIndex, with: value)
            deti_Arr = deti_array
            
            self.detiArray.replaceObject(at: 0, with: deti_Arr)
            
            tableV.reloadData()
            
            return
        }
        
    }
    
    
}
