//
//  WatersViewController.swift
//  NewToday
//
//  Created by iMac on 2019/10/17.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

import MJRefresh

import SwiftyJSON

class WatersViewController: UIViewController {
    
    var titleId = ""
    
    var dicList = [String: Any]()
    
    var contentList = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.addSubview(tableViews)
        
    }
    
    public func passCellData(value: String) {
        
        titleId = value
        
        self.contentList.removeAllObjects()
        
        tableViews.reloadData()
        
        self.tableViews.mj_header.beginRefreshing()
    }
    
    
    private func requestData() {
        
        dicList = ["titleId":self.titleId]
        
        HttpDatas.shareInstance.requestDatas(.get, URLString: todatAddres+"/user/news/waterVideo", paramaters: dicList) { (response) in
            
            let jsonData = JSON(response)
            
            if jsonData["code"].stringValue == "100"
            {
                let list = NSMutableArray()
                
                for (_,dic) in jsonData["data"]["list"]
                {
                    list.add(dic)
                }
                
                self.contentList = list
                
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
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        // 注册cell
        table.register(WatersTableViewCell.self, forCellReuseIdentifier: "sellWater")
        
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
        
        requestData()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.tableViews.mj_header.endRefreshing()
        }
        
    }
    // 上拉加载
    @objc private func footRefresh() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.tableViews.mj_footer.endRefreshing()
        }
    }
    
}


//UITableViewDelegate,UITableViewDataSource
extension WatersViewController : UITableViewDelegate,UITableViewDataSource
{
    // 行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contentList.count
    }
    // 行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return customLayer(num: 274)
    }
    // cell内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 置顶cell
        var cell:WatersTableViewCell = tableView.dequeueReusableCell(withIdentifier: "sellWater") as! WatersTableViewCell
        
        // cell 复用
        if cell.isEqual(nil)
        {
            cell = WatersTableViewCell.init(style: .default, reuseIdentifier: "sellWater")
        }
        
        cell.cellDatas(value: self.contentList[indexPath.row] as! JSON)
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    //  点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

