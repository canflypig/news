//
//  HomeScrViewController.swift
//  NewToday
//
//  Created by iMac on 2019/9/26.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

import MJRefresh

import SwiftyJSON

class HomeScrViewController: UIViewController {
    
    // 首页当前选中的title下标
    var indexCurrent: NSInteger = 0
    // 首页所有标签接收数组
    var array:NSArray?
    // 接口参数
    var dicList = [String: Any]()
    // 获取数据页数
    var page = 1
    // 当前选中标签对应的内容数组
    var contentList = NSMutableArray()
    
    var titleId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 添加table到当前页面
        self.view.addSubview(tableViews)
        
    }
    
    // 首页传过来的当前title下标
    func passValueTitle(value: String, curIndex: NSInteger) {
        
        // 页面出现刷新
        self.tableViews.mj_header.beginRefreshing()
        // 标签id
        self.titleId = value
        // 0时是首页有置顶文字
        self.indexCurrent = curIndex
        // 页面出现先清空内容
        self.contentList.removeAllObjects()
        // 刷新为没有数据的状态，防止闪动
        self.tableViews.reloadData()
        
    }
    
    // 获取数据接口
    private func requestData(value: String) {
        
        dicList = ["titleId":value,
                   "page":page,
                   "pageSize":"10"
        ]
        // 请求数据
        HttpDatas.shareInstance.requestDatas(.get, URLString: todatAddres+"/user/news/homeContents", paramaters: dicList) { (response) in
            
            let jsonData = JSON(response)
            
            if jsonData["code"].stringValue == "100"
            {
                // 拿到需要展示的数据
                let list = NSMutableArray()
                
                for (_,dic) in jsonData["data"]["list"]
                {
                    list.add(dic)
                }
                
                self.contentList = list
                
                // 刷新列表展示数据
                self.tableViews.reloadData()
            }
            
        }
        
    }
    
    
    // table初始化
    private lazy var tableViews : UITableView = {
        
        let table = UITableView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH-kNavigationBarH-kTabBarH-48), style: .plain)
        table.delegate = self
        table.dataSource = self
        // cell 分割线左右间距一样
        table.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        // 注册cell
        table.register(UINib.init(nibName: "OneHomesTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cellOne")
        table.register(UINib.init(nibName: "TwoHomesTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cellTwo")
        table.register(UINib.init(nibName: "ThreeHomesTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cellThree")
        table.register(UINib.init(nibName: "FourTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cellFour")
        table.backgroundColor = UIColor.groupTableViewBackground
        
        table.tableFooterView = UIView.init()
        
        // 给表格添加 下拉刷新/上拉加载
        table.mj_header = refeshHead()
        table.mj_header.setRefreshingTarget(self, refreshingAction: #selector(headRefresh))
        
        table.mj_footer = MJRefreshBackGifFooter()
        table.mj_footer.setRefreshingTarget(self, refreshingAction: #selector(footRefresh))
        
        
        return table
    }()
    
    // 下拉刷新
    @objc private func headRefresh() {
        
        page = 1
        
        // 根据传过来的标签ID获取对应的数据
        self.requestData(value: self.titleId)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.tableViews.mj_header.endRefreshing()
        }
        
    }
    // 上拉加载
    @objc private func footRefresh() {
        
        page += 1
        
        // 根据传过来的标签ID获取对应的数据
        self.requestData(value: self.titleId)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.tableViews.mj_footer.endRefreshing()
        }
    }

}

//UITableViewDelegate,UITableViewDataSource
extension HomeScrViewController : UITableViewDelegate,UITableViewDataSource
{
    // 行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contentList.count
    }
    // 行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // 0 时展示置顶文字
        if indexCurrent == 0
        {
            // 在第一二行展示置顶文字
            if indexPath.row == 0 || indexPath.row == 1
            {
                return customLayer(num: 65)
            }
            else  // 其它cell类型 （纯文字、一张大图、三张图）
            {
                if (self.contentList[indexPath.row] as! JSON)["image_list"].arrayValue.count == 0
                {
                    return customLayer(num: 80)
                }
                else if (self.contentList[indexPath.row] as! JSON)["image_list"].arrayValue.count == 1
                {
                    return customLayer(num: 279)
                }
                else
                {
                    return customLayer(num: 157)
                }
            }
        }
        else  // 除默认有置顶文字外其它列表cell类型 （纯文字、一张大图、三张图）
        {
            if (self.contentList[indexPath.row] as! JSON)["image_list"].arrayValue.count == 0
            {
                return customLayer(num: 80)
            }
            else if (self.contentList[indexPath.row] as! JSON)["image_list"].arrayValue.count == 1
            {
                return customLayer(num: 279)
            }
            else
            {
                return customLayer(num: 157)
            }
        }
        
    }
    // cell内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 置顶cell
        var cell:OneHomesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellOne") as! OneHomesTableViewCell
        // 大图cell
        var cellOneImg:TwoHomesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellTwo") as! TwoHomesTableViewCell
        // 多张图cell
        var cellImgs:ThreeHomesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellThree") as! ThreeHomesTableViewCell
        // 单张图cell
        var cellText:FourTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellFour") as! FourTableViewCell
        
        // 取消第一行cellg分割线
        if indexPath.row == 0
        {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: kScreenW)
        }
        
        // cell 复用
        if cell.isEqual(nil)
        {
            cell = OneHomesTableViewCell.init(style: .default, reuseIdentifier: "cellOne")
        }
        if cellOneImg.isEqual(nil)
        {
            cellOneImg = TwoHomesTableViewCell.init(style: .default, reuseIdentifier: "cellTwo")
        }
        if cellImgs.isEqual(nil)
        {
            cellImgs = ThreeHomesTableViewCell.init(style: .default, reuseIdentifier: "cellThree")
        }
        if cellText.isEqual(nil)
        {
            cellText = FourTableViewCell.init(style: .default, reuseIdentifier: "cellFour")
        }
        
        // cell数据   0时有置顶文字否则是其它列表
        if indexCurrent == 0
        {
            if indexPath.row == 0 || indexPath.row == 1
            {
                cell.cellData(value: self.contentList[indexPath.row] as! JSON)
            }
            else   // 其它cell类型 （纯文字、一张大图、三张图）
            {
                if (self.contentList[indexPath.row] as! JSON)["image_list"].arrayValue.count == 0
                {
                    cellText.cellFourData(value: self.contentList[indexPath.row] as! JSON)
                }
                else if (self.contentList[indexPath.row] as! JSON)["image_list"].arrayValue.count == 1
                {
                    cellOneImg.cellTwoData(value: self.contentList[indexPath.row] as! JSON)
                }
                else
                {
                    cellImgs.cellThreeData(value: self.contentList[indexPath.row] as! JSON)
                }
            }
        }
        else  // 除默认有置顶文字外其它列表cell类型 （纯文字、一张大图、三张图）
        {
            if (self.contentList[indexPath.row] as! JSON)["image_list"].arrayValue.count == 0
            {
                cellText.cellFourData(value: self.contentList[indexPath.row] as! JSON)
            }
            else if (self.contentList[indexPath.row] as! JSON)["image_list"].arrayValue.count == 1
            {
                cellOneImg.cellTwoData(value: self.contentList[indexPath.row] as! JSON)
            }
            else
            {
                cellImgs.cellThreeData(value: self.contentList[indexPath.row] as! JSON)
            }
        }
        
        
        
        
        // 返回不同的cell
        if indexCurrent == 0
        {
            // 一二行置顶文字
            if indexPath.row == 0 || indexPath.row == 1
            {
                return cell
            }
            else  // 其它cell类型 （纯文字、一张大图、三张图）
            {
                if (self.contentList[indexPath.row] as! JSON)["image_list"].arrayValue.count == 0
                {
                    return cellText
                }
                else if (self.contentList[indexPath.row] as! JSON)["image_list"].arrayValue.count == 1
                {
                    return cellOneImg
                }
                else
                {
                    return cellImgs
                }
            }
        }
        else  // 除默认有置顶文字外其它列表cell类型 （纯文字、一张大图、三张图）
        {
            if (self.contentList[indexPath.row] as! JSON)["image_list"].arrayValue.count == 0
            {
                return cellText
            }
            else if (self.contentList[indexPath.row] as! JSON)["image_list"].arrayValue.count == 1
            {
                return cellOneImg
            }
            else
            {
                return cellImgs
            }
        }
        
    }
    
    //  点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
