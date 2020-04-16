//
//  SmallVCViewController.swift
//  NewToday
//
//  Created by iMac on 2019/10/18.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

import SwiftyJSON

class SmallVCViewController: UIViewController {
    
    var contentList = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.addSubview(collection)
        
        reqeestData()
        
    }
    // 获取数据
    private func reqeestData() {
        
        HttpDatas.shareInstance.requestDatas(.get, URLString: todatAddres+"/user/news/videos", paramaters: nil) { (response) in
            
            let jsonData = JSON(response)
            
            if jsonData["code"].stringValue == "100"
            {
                self.contentList = jsonData["data"]["list"].arrayValue as NSArray
                
                self.collection.reloadData()
            }
        }
    }
    
    
    // 初始化显示控件
    private lazy var collection : UICollectionView = {
        
        //设置 Layout
        let layout = UICollectionViewFlowLayout.init()
        //滚动方向
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        //水平间隔
        layout.minimumInteritemSpacing = 1
        //垂直行间距
        layout.minimumLineSpacing = 1
        //计算单元格的宽度
        let itemWidth = (kScreenW-1)/2
        //设置单元格宽度和高度
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth*1.6)
        
        
        //设置collectionView
        let collect = UICollectionView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH-kNavigationBarH-kTabBarH), collectionViewLayout: layout)
        collect.dataSource = self
        collect.delegate = self
        collect.backgroundColor = UIColor.white
        
        // 注册cell
        collect.register(UINib.init(nibName: "SmallVCCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collSmal")
        
        return collect
        
    }()

}

extension SmallVCViewController : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.contentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:SmallVCCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collSmal", for: indexPath) as! SmallVCCollectionViewCell
        
        cell.cellData(value: self.contentList[indexPath.row] as! JSON)
        
        return cell
    }
}
