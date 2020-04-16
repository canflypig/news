//
//  SearchHomeView.swift
//  NewToday
//
//  Created by iMac on 2019/9/29.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

import SwiftyJSON

protocol SearchItemDelegte : NSObjectProtocol{
    // 标签分类
    func itemChange(value:String)
}

class SearchHomeView: UIView {

    // 存放推荐内容数组
    var arrList = NSMutableArray()
    var arr1 = NSMutableArray()
    var arr2 = NSMutableArray()
    var arr3 = NSMutableArray()
    
    // 代理属性
    weak var delegate:SearchItemDelegte?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let arr1 = ["1节航速是多少公里","1节航速是多少公里","1节航速是多少公里","1节航速是多少公里"]
        let arr2 = ["1节航速是多少公里","1节航速是多少公里","1节航速是多少公里"]
        let arr3 = ["1节航速是多少公里","1节航速是多少公里","1节航速是多少公里","1节航速是多少公里","1节航速是多少公里","1节航速是多少公里","1节航速是多少公里"]
        
        arrList.add(arr1)
        arrList.add(arr2)
        arrList.add(arr3)
        
        self.addSubview(collection)
        
        requestData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func requestData() {
        
        self.arrList.removeAllObjects()
        
        let token = UserDefaults.standard.object(forKey: "token") as? String
        
        HttpDatas.shareInstance.requestUserDatas(.get, URLString: todatAddres+"/user/news/searchRecommend", paramaters: ["token":token ?? ""]) { (response) in
            
            let jsonData = JSON(response)
            
            if jsonData["code"].stringValue == "100"
            {
                for (_,dic) in jsonData["data"]["recommendList"]
                {
                    let strName = dic["name"].stringValue
                    
                    self.arr1.add(strName)
                }
                if jsonData["data"]["historicalRecords"].count == 0
                {
                    self.arr2.add("暂无")
                }
                else
                {
                    for (_,dic) in jsonData["data"]["historicalRecords"]
                    {
                        let strName = dic["name"].stringValue
                        
                        self.arr2.add(strName)
                    }
                }
                for (_,dic) in jsonData["data"]["bottomList"]
                {
                    let strName = dic["name"].stringValue
                    
                    self.arr3.add(strName)
                }
                
                
                self.arrList.add(self.arr1)
                self.arrList.add(self.arr2)
                self.arrList.add(self.arr3)
                
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
        layout.minimumInteritemSpacing = 2
        //垂直行间距
        layout.minimumLineSpacing = 10
        //计算单元格的宽度
        let itemWidth = (kScreenW-10)/2
        //设置单元格宽度和高度
        layout.itemSize = CGSize(width: itemWidth, height: 40)
        
        
        //设置collectionView
        let collect = UICollectionView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH-kStatusBarH-60), collectionViewLayout: layout)
        collect.dataSource = self
        collect.delegate = self
        collect.backgroundColor = UIColor.white
       
        // 注册cell
        collect.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "collidTypes")
        //注册区头
        collect.register(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headers")
        
        return collect
        
    }()
    
}


//MARK: UICollectionViewDataSource
extension SearchHomeView : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    // 分区数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return arrList.count
    }
    // item个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (arrList[section] as! NSArray).count
    }
    // 每个分区头部高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if section == 0
        {
            return CGSize.init(width: kScreenW, height: 5)
        }
        else if section == 1
        {
            return CGSize.init(width: kScreenW, height: 80)
        }
        else
        {
            return CGSize.init(width: kScreenW, height: 36)
        }
        
    }
    
    // 区头内容
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var headerView : UICollectionReusableView?
        
        // 分区头部内容初始化
        if kind == UICollectionView.elementKindSectionHeader
        {
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headers", for: indexPath)
            
            // 灰线
            let label = UILabel.init(frame: CGRect(x: 15, y: 18, width: kScreenW-30, height: 1))
            label.backgroundColor = RGBColor(r: 231, g: 231, b: 231)
            
            // 一区
            if indexPath.section == 1
            {
                let hisLab = UILabel.init(frame: CGRect(x: 15, y: 35, width: 100, height: 25))
                hisLab.text = "历史记录"
                hisLab.font = customFont(font: 14)
                hisLab.textColor = RGBColor(r: 34, g: 34, b: 34)
                
                headerView?.addSubview(hisLab)
            }
            // 灰线
            if indexPath.section != 0
            {
                headerView?.addSubview(label)
            }
            
        }
        
        return headerView!
        
    }
    
    // cell内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:SearchCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collidTypes", for: indexPath) as! SearchCollectionViewCell
        
        cell.setCellDatas(value: (arrList[indexPath.section] as! NSArray)[indexPath.row] as! String, index: indexPath.row)

        return cell
    }
    
    // 点击第一分区时移动当前cell到第二分区，点击第二分区时添加当前cell到第一分区
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.itemChange(value: (arrList[indexPath.section] as! NSArray)[indexPath.row] as! String)
    }
}
