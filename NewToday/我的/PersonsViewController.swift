//
//  PersonsViewController.swift
//  NewToday
//
//  Created by iMac on 2019/9/23.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

import WisdomHUD
import SwiftyJSON

class PersonsViewController: FathViewController,UITableViewDelegate,UITableViewDataSource {
    
    // 默认文字数组
    var arrList = NSArray()
    // cell副标题数组
    var detiArray = NSMutableArray()
    // 头像
    var headImg:UIImageView?
    // model接收个人信息数据
    var perModel : MineModel? = nil
    // 1/用户名 2/个人介绍
    var rowType = ""
    // pick选择器高度
    let pickHeight = 240 + kTabBarH-49
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 监听键盘弹出高度
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        // 监听键盘收回
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // 导航文字
        self.navigationItem.titleView = titleNav
        // 默认文字
        creatData()
        // 添加表格
        self.view.addSubview(tableView)
        // 添加灰色背景
        keyWindow.addSubview(grayView)
        // 添加编辑昵称/个性签名弹框
        keyWindow.addSubview(editView)
        
        KeyWindow?.addSubview(pickView)
        
    }
    
    // 导航标题
    private lazy var titleNav : UILabel = {
        
        let label = UILabel()
        label.text = "编辑资料"
        label.textAlignment = NSTextAlignment.center
        label.font = customFont(font: 18)
        label.textColor = RGBColor(r: 34, g: 34, b: 34)
        
        return label
    }()
    // 默认文字
    private func creatData() {
        self.arrList = [["头像","用户名","介绍"],["性别","生日","地区"]]
        self.detiArray = [["",perModel?.user_login,perModel?.introduceText],[perModel?.gender,perModel?.birthday,perModel?.area]]
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
        editView.textCont.resignFirstResponder()
    }
    // table初始化
    private lazy var tableView : UITableView = {
        
        let table = UITableView.init(frame: self.view.bounds, style: .grouped)
        table.delegate = self
        table.dataSource = self
        
        return table
    }()
    // 灰色背景
    private lazy var grayView : UIView = {
        
        let grayV = UIView.init(frame: self.view.bounds)
        grayV.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        grayV.isHidden = true
        
        let tapp = UITapGestureRecognizer.init(target: self, action: #selector(grayClick))
        grayV.addGestureRecognizer(tapp)
        
        return grayV
    }()
    // 昵称/个人介绍编辑视图
    private lazy var editView : EditsView = {
        
        let edit = EditsView.loadFromNib()
        edit.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: 160)
        edit.textCont.tag = 101
        edit.delegate = self
        
        return edit
    }()
    // pick
    private lazy var pickView : MinePickViews = {
        
        let pick = MinePickViews.loadFromNib()
        pick.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: pickHeight)
        pick.delegate = self
        
        return pick
    }()
    // 移除通知
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// UITableViewDelegate,UITableViewDataSource
extension PersonsViewController
{
    // 分区数量
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrList.count
    }
    // 每区行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.arrList[section] as! NSArray).count
    }
    // 行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return customLayer(num: 46)
    }
    // 分区头高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    // 分区尾高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    // 分区头视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    // 分区尾视图
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    // cell内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell
        var cell = tableView.dequeueReusableCell(withIdentifier: "perCell")

        if cell == nil
        {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "perCell")
        }
        
        // cell 属性（颜色、字体、大小）
        cell?.textLabel?.text = ((self.arrList[indexPath.section] as! NSArray)[indexPath.row] as! String)
        cell?.textLabel?.font = customFont(font: 16)
        cell?.textLabel?.textColor = RGBColor(r: 34, g: 34, b: 34)
        
        // 副标题属性
        cell?.detailTextLabel?.text = ((self.detiArray[indexPath.section] as! NSArray)[indexPath.row] as? String)
        cell?.detailTextLabel?.font = customFont(font: 14)
        cell?.detailTextLabel?.textColor = RGBColor(r: 153, g: 153, b: 153)
        
        // 第一行cell头像
        if indexPath.section == 0 && indexPath.row == 0
        {
            headImg = UIImageView.init(frame: CGRect(x: kScreenW-70, y: customLayer(num: 12), width: customLayer(num: 22), height: customLayer(num: 22)))
            //headImg?.image = UIImage(named: "mine_def")
            headImg?.layer.cornerRadius = customLayer(num: 11)
            headImg?.layer.masksToBounds = true
            headImg?.isUserInteractionEnabled = true
            cell?.contentView.addSubview(headImg!)
            
            headImg?.kf.setImage(with: URL(string: perModel?.user_url ?? ""), placeholder: UIImage(named: "mine_def"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        // 箭头
        cell?.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        return cell!
    }
    
    // 点击cell状态
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 点击两个分区第一行 （头像，性别）
        if indexPath.section == 0 && indexPath.row == 0 || indexPath.section == 1 && indexPath.row == 0
        {
            clickCells(value: indexPath.section)
        }
        // 点击第一分区第二三行 （昵称，个人介绍）
        else if indexPath.section == 0
        {
            if indexPath.row == 1
            {
                editView.num = 20
                editView.defText = "请输入用户名"
                rowType = "1"
            }
            if indexPath.row == 2
            {
                editView.num = 60
                editView.defText = "请输入用个性签名"
                rowType = "2"
            }
            
            grayView.isHidden = false
            editView.viewWithTag(101)?.becomeFirstResponder()
            
            editView.requestTextViewUI(value: "", nums: editView.num, plactT: editView.defText)
        }
        else
        {
            if indexPath.row == 1
            {
                creatPickView()
                pickView.hiddecAddressPick()
            }
            if indexPath.row == 2
            {
                creatPickView()
                pickView.hiddecPickUI()
            }
        }
        
    }
    // pickView
    private func creatPickView() {
        
        grayView.isHidden = false
        weak var weakSelf = self
        UIView.animate(withDuration: 0.2) {
            weakSelf?.pickView.frame = CGRect(x: 0, y: kScreenH-weakSelf!.pickHeight, width: kScreenW, height: weakSelf!.pickHeight)
        }
    }
    // 底部弹框初始化
    private func clickCells(value:NSInteger) {
        
        var actionList = NSArray()
        
        if value == 0
        {
            actionList = ["拍照","从相册选择"]
        }
        else
        {
            actionList = ["男","女"]
        }
        
        // 底部弹框
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for alertString in actionList {
            
            let alertAct = UIAlertAction(title: alertString as? String, style: .default) { (alert) in
                
                if value == 0
                {
                    self.imgPhotoFrom(value: alertString as! String)
                }
                else
                {
                    self.genderFrom(value: alertString as! String)
                }
            }
            
            alertController.addAction(alertAct)
        }
        
        let cancelAct = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAct)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    // 头像
    private func imgPhotoFrom(value:String) {
        
        if value == "拍照"
        {
            WisdomHUD.showError(text: "请使用真机", delay: 1.0, enable: true)
        }
        else
        {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            
            self.present(picker, animated: true, completion: nil)
        }
    }
    // 性别
    private func genderFrom(value:String) {
        
        // 调用对应的接口
        modiftDatas(value: value, typeRow: "4")
        
        let genderArr = NSMutableArray()
        
        // 拿到要修改的区域数组
        for strGender in self.detiArray[1] as! NSArray {
            genderArr.add(strGender)
        }
        
        // 替换掉修改的内容
        genderArr.replaceObject(at: 0, with: value)
        self.detiArray.replaceObject(at: 1, with: genderArr)
        
        // 只刷新当前cell
        let inde = NSIndexPath.init(row: 0, section: 1)
        tableView.reloadRows(at: [inde as IndexPath], with: .none)
        
    }
    // 键盘弹出
    @objc private func keyBoardWillShow(notification:NSNotification)
    {
        let keyboardInfo = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey]
        
        let heightBoard = kScreenH - (keyboardInfo as AnyObject).cgRectValue.size.height - 160
        
        UIView.animate(withDuration: 0.35) {
            self.editView.frame = CGRect(x: 0, y: heightBoard, width: kScreenW, height: 160)
        }
    }
    // 键盘收回
    @objc private func keyBoardWillHide(notification:NSNotification)
    {
        UIView.animate(withDuration: 0.35) {
            self.editView.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: 160)
        }
    }
    // 退出编辑
    @objc private func grayClick() {
        
        grayView.isHidden = true
        editView.viewWithTag(101)?.resignFirstResponder()
        
        pickView.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: pickHeight)
    }
    
    
}

// UIImagePickerControllerDelegate,UINavigationControllerDelegate
extension PersonsViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    // 选择完图片调用这里
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // 拿到选择的图片
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        headImg?.image = image
        picker.dismiss(animated: true, completion: nil)
        
        let imageArr = NSMutableArray()
        imageArr.add(image)
        
        // 弱引用，防止循环引用
        weak var weakSelf = self
        
        // 上传选中的图片获取路径
        HttpDatas.shareInstance.uploadDatas(.post, URLString: updataImgUrl, paramaters: imageArr as! [UIImage]) { (response) in
            
            let jsonData = JSON(response)
            
            //print("jsonData = \(jsonData)")
            
            // 成功则恶调用修改接口
            if jsonData["code"].stringValue == "200"
            {
                weakSelf?.modiftDatas(value: jsonData["data"].stringValue, typeRow: "1")
            }
            
        }
        
    }
    
    // 取消选择图片
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // 修改接口
    private func modiftDatas(value : String, typeRow : String) {
        
        let token = UserDefaults.standard.object(forKey: "token") as? String
        
        var dicList = [String : Any]()
        
        // typeRow == 1、头像 2、昵称 3、个人介绍 4、性别 5、生日 6、地区
        if typeRow == "1"
        {
            dicList = ["token":token ?? "",
                       "headImg":value
            ]
        }
        if typeRow == "2"
        {
            dicList = ["token":token ?? "",
                       "name":value
            ]
        }
        if typeRow == "3"
        {
            dicList = ["token":token ?? "",
                       "introduce":value
            ]
        }
        if typeRow == "4"
        {
            dicList = ["token":token ?? "",
                       "gender":value
            ]
        }
        if typeRow == "5"
        {
            dicList = ["token":token ?? "",
                       "birthday":value
            ]
        }
        if typeRow == "6"
        {
            dicList = ["token":token ?? "",
                       "area":value
            ]
        }
        
        
        // 修改接口
        HttpDatas.shareInstance.requestUserDatas(.post, URLString: todatAddres+"/user/news/mineModify", paramaters: dicList) { (response) in
            
            let jsonData = JSON(response)
            
            // 提示是否成功成功
            if jsonData["code"].stringValue == "100"
            {
                WisdomHUD.showSuccess(text: "修改成功", delay: 1.0, enable: true)
            }
            else
            {
                WisdomHUD.showError(text: "修改失败", delay: 1.0, enable: true)
            }
            
        }
    }
    
}

// EditDelegate
extension PersonsViewController : EditDelegate
{
    func editChange(value: String) {
        
        grayClick()
        
        let genderArr = NSMutableArray()
        
        // 拿到要修改的区域数组
        for strGender in self.detiArray[0] as! NSArray {
            genderArr.add(strGender)
        }
        
        if rowType == "1"
        {
            //print("用户 = \(value)")
            // 调用对应的接口
            modiftDatas(value: value, typeRow: "2")
            
            // 替换掉修改的内容
            genderArr.replaceObject(at: 1, with: value)
            self.detiArray.replaceObject(at: 0, with: genderArr)
            
            // 只刷新当前cell
            let inde = NSIndexPath.init(row: 1, section: 0)
            tableView.reloadRows(at: [inde as IndexPath], with: .none)
        }
        else
        {
            //print("介绍 = \(value)")
            
            // 调用对应的接口
            modiftDatas(value: value, typeRow: "3")
            
            // 替换掉修改的内容
            genderArr.replaceObject(at: 2, with: value)
            self.detiArray.replaceObject(at: 0, with: genderArr)
            
            // 只刷新当前cell
            let inde = NSIndexPath.init(row: 2, section: 0)
            tableView.reloadRows(at: [inde as IndexPath], with: .none)
        }
        
    }
}

// MinePickDelegate
extension PersonsViewController : MinePickDelegate
{
    func minePickChange(value: String, index: NSInteger, address: String) {
        
        grayClick()
        
        let genderArr = NSMutableArray()
        
        // 拿到要修改的区域数组
        for strGender in self.detiArray[1] as! NSArray {
            genderArr.add(strGender)
        }
        
        if index == 2
        {
            if address == ""
            {
                //print("生日 = \(value)")
                // 调用对应的接口
                modiftDatas(value: value, typeRow: "5")
                
                // 替换掉修改的内容
                genderArr.replaceObject(at: 1, with: value)
                self.detiArray.replaceObject(at: 1, with: genderArr)
                
                // 只刷新当前cell
                let inde = NSIndexPath.init(row: 1, section: 1)
                tableView.reloadRows(at: [inde as IndexPath], with: .none)
            }
            else
            {
                //print("地址 = \(value)")
                // 调用对应的接口
                modiftDatas(value: address, typeRow: "6")
                
                // 替换掉修改的内容
                genderArr.replaceObject(at: 2, with: address)
                self.detiArray.replaceObject(at: 1, with: genderArr)
                
                // 只刷新当前cell
                let inde = NSIndexPath.init(row: 2, section: 1)
                tableView.reloadRows(at: [inde as IndexPath], with: .none)
            }
        }
        
    }
    
}

