//
//  HomeTypeView.swift
//  NewToday
//
//  Created by iMac on 2019/9/27.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

import SwiftyJSON

// 代理传值
protocol HomeChannlDelegte : NSObjectProtocol{
    
    func channlChange()
}

class HomeTypeView: UIView {
    
    //区头
    var headerView : UICollectionReusableView!
    // 默认文字数组
    var arrList = NSMutableArray()
    // 是否编辑状态
    var isEdits:Bool = false
    // 编辑按钮
    var editButton:UIButton!
    // cell
    var cell: TypeCollectionViewCell!
    
    var dicList = [String : Any]()
    
    var arr1 = NSMutableArray()
    var arr2 = NSMutableArray()
    
    var dragindexPa : IndexPath?
    // 代理属性
    weak var delegate : HomeChannlDelegte?
    
    // 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 初始化默认文字数组
//        let arr1:NSMutableArray = ["关注","推荐","视频","热点","影视","视频","音乐","图片","宠物","上海","测试"]
//        let arr2:NSMutableArray = ["时尚","推荐","123","qwe","fdsa","zxc","321","oc","432","56","7654","h65h","g56g","g623",">>>>","<<<<","==","swift"]
//
//        arrList.add(arr1)
//        arrList.add(arr2)
        
        // 添加关闭按钮和展示标签的wcollection
        self.addSubview(colse_btn)
        self.addSubview(collection)
        
        requestData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func requestData() {
        
        let token = UserDefaults.standard.object(forKey: "token") as? String
        
        dicList = ["type":"0",
                   "token":token ?? "",
                   "titleId":""
        ]
        
        HttpDatas.shareInstance.requestUserDatas(.get, URLString: todatAddres+"/user/news/homeChannels", paramaters: dicList) { (response) in
            
            let jsonData = JSON(response)
            
            if jsonData["code"].stringValue == "100"
            {
                for (_,dic) in jsonData["data"]["myChannels"]
                {
                    let strName = dic["name"].stringValue
                    
                    self.arr1.add(strName)
                }
                for (_,dic) in jsonData["data"]["channelsRecommend"]
                {
                    let strName = dic["name"].stringValue
                    
                    self.arr2.add(strName)
                }
                
                self.arrList.add(self.arr1)
                self.arrList.add(self.arr2)
                
                self.collection.reloadData()
            }
            
        }
        
    }
    
    
    // 关闭按钮
    private lazy var colse_btn : UIButton = {
        
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: 20, y: 20, width: 20, height: 20)
        button.setImage(UIImage(named: "close_img"), for: .normal)
        button.addTarget(self, action: #selector(closeClass), for: .touchUpInside)
        
        return button
    }()
    
    // 关闭分类
    @objc func closeClass() {
        delegate?.channlChange()
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
        let itemWidth = (kScreenW-6)/4
        //设置单元格宽度和高度
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth/2)
        //头部视图高度
        layout.headerReferenceSize = CGSize.init(width: kScreenW, height: 50)
        
        //设置collectionView
        let collect = UICollectionView(frame: CGRect(x: 0, y: 60, width: kScreenW, height: kScreenH-kStatusBarH-60), collectionViewLayout: layout)
        collect.dataSource = self
        collect.delegate = self
        collect.backgroundColor = UIColor.white
        
        // 开启拖放手势，设置代理。
        collect.dragInteractionEnabled = true
        collect.dragDelegate = self
        collect.dropDelegate = self
        
        // 注册cell
        collect.register(UINib.init(nibName: "TypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "collidType")
        //注册区头
        collect.register(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        return collect
        
    }()

}

//MARK: UICollectionViewDataSource
extension HomeTypeView : UICollectionViewDelegate,UICollectionViewDataSource
{
    // 分区数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return arrList.count
    }
    // item个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (arrList[section] as! NSArray).count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
                
        // 分区头部内容初始化
        if kind == UICollectionView.elementKindSectionHeader
        {
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
            
            // 标题文字
            let label = UILabel.init(frame: CGRect(x: 20, y: 0, width: 100, height: 50))
            label.font = UIFont.systemFont(ofSize: 21, weight: .init(1))
            
            // 一区
            if indexPath.section == 0
            {
                label.text = "我的频道"
                
                // 编辑按钮初始化
                editButton = UIButton.init(type: .custom)
                editButton.frame = CGRect(x: kScreenW-70, y: 12, width: 50, height: 26)
                editButton.setTitle("编辑", for: .normal)
                editButton.setTitle("完成", for: .selected)
                editButton.titleLabel?.font = customFont(font: 14)
                editButton.setTitleColor(RGBColor(r: 248, g: 89, b: 89), for: .normal)
                editButton.layer.borderWidth = 1
                editButton.layer.borderColor = RGBColor(r: 248, g: 89, b: 89).cgColor
                editButton.layer.cornerRadius = 13
                editButton.layer.masksToBounds = true
                editButton.addTarget(self, action: #selector(clickEdit(sender:)), for: .touchUpInside)
                
                headerView.addSubview(editButton)
                
            }
            // 二区
            else if indexPath.section == 1
            {
                label.text = "频道推荐"
            }
            
            headerView?.addSubview(label)
        }
        
        return headerView
        
    }
    
    // 点击编辑按钮
    @objc private func clickEdit(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        
        // 改变编辑状态
        if sender.isSelected
        {
            isEdits = true
        }
        else
        {
            isEdits = false
        }
        
        // 编辑时之刷新一区
        let indexSet: NSIndexSet = NSIndexSet.init(index: 0)
        collection.reloadSections(indexSet as IndexSet)
        
        // 改变编辑按钮状态
        editButton.removeFromSuperview()
        headerView.addSubview(sender)
    }
    
    // cell内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collidType", for: indexPath) as? TypeCollectionViewCell
        
        // 传值给每一行cell赋值
        cell.cellDaraText(value: (arrList[indexPath.section] as! NSArray)[indexPath.row] as! String, cellSection: indexPath.section, cell: cell, idEdis: isEdits)
        
        return cell
        
    }
    
    // 点击第一分区时移动当前cell到第二分区，点击第二分区时添加当前cell到第一分区
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 编辑状态下才可以点击
        if isEdits
        {
            // 先拿到两个分区的内容存入数组
            let listOnes:NSMutableArray = arrList[0] as! NSMutableArray
            let listTwos:NSMutableArray = arrList[1] as! NSMutableArray
            
            // 获取当前点击的cell
            let cellCurs:TypeCollectionViewCell = collectionView.cellForItem(at: indexPath) as! TypeCollectionViewCell
            
            if indexPath.section == 0
            {
                // 点击第一分区内容时在这里当前cell变为和第二分区相同样式的cell
                cell.cellDaraText(value: listOnes[indexPath.row] as! String, cellSection: 1, cell: cellCurs, idEdis: isEdits)
                
                // 先添加当前数据到二区，在移除一区当前内容，否则会崩溃
                listTwos.insert(listOnes[indexPath.row], at: 0)
                listOnes.removeObject(at: indexPath.row)
                
                // 获取要移动到二区的位置并动画移动
                let indexPath11 = IndexPath.init(row: 0, section: 1)
                collectionView.moveItem(at: indexPath, to: indexPath11)
            }
            else
            {
                // 点击第二分区内容时在这里当前cell变为和第一分区t相同样式的cell
                cell.cellDaraText(value: listTwos[indexPath.row] as! String, cellSection: 0, cell: cellCurs, idEdis: isEdits)
                
                // 先添加当前数据到一区，在移除二区当前内容，否则会崩溃
                listOnes.add(listTwos[indexPath.row])
                listTwos.removeObject(at: indexPath.row)
                
                // 获取要移动到一区的位置并动画移动
                let indexPath2 = IndexPath.init(item: listOnes.count-1, section: 0)
                collectionView.moveItem(at: indexPath, to: indexPath2)
            }
            
            // 刷新整个数据源
            arrList.replaceObject(at: 0, with: listOnes)
            arrList.replaceObject(at: 1, with: listTwos)
            collectionView.reloadData()
        }
        
    }
    
}
// MARK: - UICollectionViewDragDelegate
extension HomeTypeView : UICollectionViewDragDelegate
{
    // 处理首次拖动时，是否响应
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        // 只响应第一分区
        guard indexPath.section != 1 else {
            return []
        }
        
        let item = (arrList[indexPath.section] as! NSMutableArray)[indexPath.row] as! String
        
        let itemProvider = NSItemProvider.init(object: item as NSItemProviderWriting)
        
        let dragItem = UIDragItem.init(itemProvider: itemProvider)
        
        dragItem.localObject = item
        
        dragindexPa = indexPath
        
        return [dragItem]
        
    }
}

//MARK: - UICollectionViewDropDelegate
extension HomeTypeView : UICollectionViewDropDelegate
{
    // 处理拖动放下后如何处理
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        // 如果coordinator.destinationIndexPath存在，直接返回；如果不存在，则返回（0，0)位置
        guard let destinationIndex = coordinator.destinationIndexPath else {
            return
        }
        
        let items = coordinator.items
        if let item = items.first, let souceIndesPath = item.sourceIndexPath
        {
            // 将移除添加操作合并为一个动画。
            collectionView.performBatchUpdates({
                
                // 将拖动内容从数据源删除，插入到新的位置
                (self.arrList[destinationIndex.section] as! NSMutableArray).removeObject(at: souceIndesPath.row)
                (self.arrList[destinationIndex.section] as! NSMutableArray).insert(item.dragItem.localObject as! String, at: destinationIndex.row)
                
            }, completion: nil)
            // 将项目动画化到视图层次结构中的任意位置
            coordinator.drop(item.dragItem, toItemAt: destinationIndex)
        }
    }
    
    //拖动过程中不断反馈item位置
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        guard dragindexPa?.section == destinationIndexPath?.section else {
            return UICollectionViewDropProposal.init(operation: .forbidden)
        }
        
        return UICollectionViewDropProposal.init(operation: .move, intent: .insertAtDestinationIndexPath)
        
    }
}


