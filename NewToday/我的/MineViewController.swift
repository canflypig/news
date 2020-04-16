//
//  MineViewController.swift
//  NewToday
//
//  Created by iMac on 2019/9/1.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

import SwiftyJSON
import Kingfisher

class MineViewController: UIViewController,LoginAndRegistDelegate,FindViewDelegate,PrivacyViewDelegate,OneKeyLoginViewDelegate {

    // 状态栏默认颜色
    var style: UIStatusBarStyle = .default
    // 修改状态栏颜色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.style
    }
    // 弹出的登陆view最终y点
    var loginViewOriginY: CGFloat!
    // 默认文字数组
    var arrList = NSArray()
    // 头部视图高度
    let headHeight = kStatusBarH + 180
    
    var model : MineModel?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
                
        loginViewOriginY = kStatusBarH   // 登陆页最终y坐标点
        
        self.view.backgroundColor = UIColor.white
        
        //view.addSubview(button)
        
        creatData()                      // 默认文字数据
        view.addSubview(tableV)          // 添加表格
        tableV.addSubview(headTabView)   // 头部视图
        
        view.addSubview(grayView)        // 灰色透明背景
        view.addSubview(loginV)          // 圆角登陆视图
        loginV.addSubview(findView)      // 找回密码
        loginV.addSubview(keyLoginView)  // 一键登陆
        loginV.addSubview(privzcyV)      // 协议
        
    }
    
    // 获取个人信息数据
    private func requestData() {
        
        let token = UserDefaults.standard.object(forKey: "token") as? String
        
        if token != "nil" || token?.count != 0 || token != ""
        {
            
            // 弱引用
            weak var weakSelf = self
            
            HttpDatas.shareInstance.requestUserDatas(.get, URLString: todatAddres+"/user/news/mineInformation", paramaters: ["token":token ?? ""]) { (response) in
                
                // json格式
                let jsonData = JSON(response)
                
                //print("my = \(jsonData)")
                
                // 请求成功
                if jsonData["code"].stringValue == "100"
                {
                    // 显示个人信息
                    self.headTabView.viewWithTag(102)?.isHidden = false
                    
                    // 数据存入model
                    weakSelf?.model = MineModel.init(jsonData: jsonData["data"])
                    
                    // 头像获取
                    weakSelf?.headTabView.headImg?.kf.setImage(with: URL(string: weakSelf!.model!.user_url), placeholder: UIImage(named: "mine_def"), options: nil, progressBlock: nil, completionHandler: nil)
                    
                    // 昵称获取
                    if weakSelf?.model?.user_login.count != 0
                    {
                        weakSelf?.headTabView.nick_name.text = weakSelf?.model?.user_login
                    }
                }
                
            }
        }
        else
        {
            // 显示个人信息
            self.headTabView.viewWithTag(102)?.isHidden = true
        }
    }
    
    // table初始化
    private lazy var tableV : UITableView = {
        
        let table = UITableView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH-kTabBarH), style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.contentInset = UIEdgeInsets(top: headHeight, left: 0, bottom: 0, right: 0)
        
        // 去掉头部空白
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        return table
    }()
    
    // 默认信息数组
    private func creatData() {
        // 默认信息数组初始化
        self.arrList = [[""],[""],["我的关注","我的钱包","消息通知"],["扫一扫","免流量服务","阅读公益","广告推广"],["用户反馈","系统设置"]]
    }
    
    // tableHeadView
    private lazy var headTabView : HeadMineView = {
        
        let head_v = HeadMineView.loadFromNib()
        head_v.frame = CGRect(x: 0, y: -headHeight, width: kScreenW, height: headHeight)
        head_v.bjView.tag = 101
        head_v.delegate = self
        head_v.inforView.isHidden = true
        head_v.inforView.tag = 102
        
        return head_v
    }()
    
    // 页面出现时隐藏导航
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        requestData()
    }
    
    // 页面消失时显示导航
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // 测试按钮 点击弹出登陆视图
    private lazy var button : UIButton = {

        let btn = UIButton.init(type: .roundedRect)
        btn.frame = CGRect(x: 10, y: 300, width: kScreenW-20, height: 100)
        btn.backgroundColor = UIColor.green
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)

        return btn
    }()
    
    // 懒加载灰色背景
    private lazy var grayView : UIView = {
        
        let gray = UIView.init(frame: self.view.bounds)
        gray.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        gray.alpha = 0.0
        
        return gray
    }()
    
    // 懒加载白色圆角登陆背景
    private lazy var loginV : LoginAndRegistView = {
        
        let logV = LoginAndRegistView.loadFromNib()
        logV.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: kScreenH)
        logV.layer.cornerRadius = 10
        logV.layer.masksToBounds = true
        logV.delegate = self
        
        // 给弹出的登陆视图添加一个可以下移的拖动手势
        let panView = UIPanGestureRecognizer.init(target: self, action: #selector(pan(panGuesture:)))
        logV.addGestureRecognizer(panView)
        
        return logV
    }()
    
    // 找回密码背景
    private lazy var findView : FindPassView = {
        
        let find = FindPassView.loadFromNib()
        find.frame = CGRect(x: kScreenW, y: 0, width: kScreenW, height: kScreenH)
        find.layer.cornerRadius = 10
        find.layer.masksToBounds = true
        find.delegate = self
        
        return find
    }()
    
    // 协议
    private lazy var privzcyV : PrivacyView = {
        
        let find = PrivacyView.loadFromNib()
        find.frame = CGRect(x: kScreenW, y: 0, width: kScreenW, height: kScreenH)
        find.layer.cornerRadius = 10
        find.layer.masksToBounds = true
        find.delegate = self
        
        return find
    }()
    
    // 一键登陆
    private lazy var keyLoginView : OneKeyLoginView = {
        
        let keyL = OneKeyLoginView.loadFromNib()
        keyL.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH-kStatusBarH)
        keyL.layer.cornerRadius = 10
        keyL.layer.masksToBounds = true
        keyL.delegate = self
        
        return keyL
    }()
    
    // 收藏 评论 点赞 历史
    private lazy var oneCellView : UIView = {
        
        let cell_view = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: customLayer(num: 79)))
        
        let titleArr = ["我的收藏","我的评论","我的点赞","浏览历史"]
        let imgArr = ["mine_sc","mine_pl","mine_dz","mine_ls"]
        
        // for循环创建4个button
        for index in 0..<titleArr.count
        {
            let button = UIButton.init(type: .roundedRect)
            button.frame = CGRect(x: kScreenW/4*CGFloat(index), y: 0, width: kScreenW/4, height: customLayer(num: 79))
            cell_view.addSubview(button)
            
            
            let img = UIImageView.init(frame: CGRect(x: button.frame.size.width/2-customLayer(num: 10), y: customLayer(num: 20), width: customLayer(num: 20), height: customLayer(num: 20)))
            img.image = UIImage(named: imgArr[index])
            button.addSubview(img)
            
            let label = UILabel.init(frame: CGRect(x: 0, y: customLayer(num: 50), width: kScreenW/4, height: 20))
            label.text = titleArr[index]
            label.textAlignment = NSTextAlignment.center
            label.textColor = RGBColor(r: 34, g: 34, b: 34)
            label.font = customFont(font: 14)
            button.addSubview(label)
        }
        
        return cell_view
    }()
    
}

// 拖动登陆view
extension MineViewController
{
    // 拖动登陆视图时只允许向下拖动
    @objc private func pan(panGuesture:UIPanGestureRecognizer) {
        
        // 开始拖动
        if panGuesture.state == .began {
            //print("开始拖动")
        }
            // 拖动过程
        else if panGuesture.state == .changed {
            
            // 拖动后的y坐标
            let y = panGuesture.translation(in: self.view).y
            
            //滑动状态栏下面后不允许往上拖动
            if y <= kStatusBarH
            {
                self.loginV.frame = CGRect(x: 0, y: kStatusBarH, width: kScreenW, height: kScreenH)
            }
                // 只允许往下拖动
            else
            {
                self.loginV.frame = CGRect(x: 0, y: loginViewOriginY+y, width: kScreenW, height: kScreenH)
            }
            
            // 根据scrollview的偏移量属性来动态改变灰色背景的透明度
            var scrolAlpha = self.loginV.frame.origin.y/kScreenH/2
            
            if scrolAlpha > 0.5
            {
                scrolAlpha = 0.5
            }
            
            // 灰色背景的透明度
            self.grayView.alpha = 1-scrolAlpha
        }
        // 拖动结束
        else if panGuesture.state == .ended
        {
            // 拖动结束判断拖动偏移量是否超过屏幕的一半，没有泽回弹
            if self.loginV.frame.origin.y <= kScreenH/2
            {
                UIView.animate(withDuration: 0.25) {
                    self.loginV.frame = CGRect(x: 0, y: self.loginViewOriginY, width: kScreenW, height: kScreenH)
                    
                    self.grayView.alpha = 1.0
                }
            }
                // 超过则自动滑动到底部消失
            else
            {
                // 隐藏登陆view
                hiddenLoginView(tim: 0.25)
            }
            
            // 状态栏刷新
            if self.grayView.alpha >= 0.5
            {
                self.style = .lightContent
                setNeedsStatusBarAppearanceUpdate()
            }
            else
            {
                self.style = .default
                setNeedsStatusBarAppearanceUpdate()
                
                // 导航和tabbar显示
                creatHidden(value: 0, time: 0.25)
            }
        }
    }
    
    // 隐藏登陆页
    private func hiddenLoginView(tim:TimeInterval) {
        UIView.animate(withDuration: tim) {
            self.loginV.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: kScreenH)
            
            self.grayView.alpha = 0.0
        }
        
        self.perform(#selector(hiddenOtherView), with: nil, afterDelay: 0.5)
    }
    
    @objc private func hiddenOtherView() {
        self.findView.frame = CGRect(x: kScreenW, y: 0, width: kScreenW, height: kScreenH)
        self.privzcyV.frame = CGRect(x: kScreenW, y: 0, width: kScreenW, height: kScreenH)
        
        self.keyLoginView.isHidden = false
    }
}

// 弹出登陆视图和状态栏改变
extension MineViewController
{
    // 在这里弹出登陆视图操作
    @objc private func btnClick() {
        
        let token = UserDefaults.standard.object(forKey: "token") as? String
        let phone:String = model?.phoneNumber ?? ""
        
        if token?.count == 0
        {
            keyLoginView.isHidden = true
        }
        else
        {
            if phone.count == 0
            {
                keyLoginView.isHidden = true
            }
            else
            {
                keyLoginView.isHidden = false
                //截取某字符串的前n个字符串
                let headStr = phone.prefix(3)
                //截取某字符串的后n个字符串
                let foorStr = phone.suffix(4)
                
                let phoneNum:String = headStr+"****"+foorStr
                
                keyLoginView.telPhoneText.text = phoneNum
            }
        }
        
        // 先隐藏导航和tabbar
        creatHidden(value: 1, time: 0.1)
        
        // 弹出登陆时改变状态栏文字颜色
        self.style = .lightContent
        setNeedsStatusBarAppearanceUpdate()
        
        // 弹出登陆动画
        UIView.animate(withDuration: 0.5) {
            self.loginV.frame = CGRect(x: 0, y: kStatusBarH/2, width: kScreenW, height: kScreenH)
            
            self.grayView.alpha = 1.0
        }
        
        // 开始弹出登陆后延时执行下移一定距离
        self.perform(#selector(downMove), with: nil, afterDelay: 0.5)
    }
    
    // 登陆弹出后自动下移到状态栏下面
    @objc func downMove() {
        
        UIView.animate(withDuration: 0.2) {
            self.loginV.frame = CGRect(x: 0, y: kStatusBarH, width: kScreenW, height: kScreenH)
            
            self.grayView.alpha = 1.0
        }
    }
    
    // 这里判断是否隐藏导航和tabbar
    private func creatHidden(value:NSInteger, time:TimeInterval) {
        
        if value == 1
        {
            self.tabBarController?.tabBar.isHidden = true
        }
        else
        {
            self.perform(#selector(hidTabbar), with: nil, afterDelay: time)
        }
    }
    
    // tabbar没有动画所以延时后和导航同时显示
    @objc func hidTabbar() {
        
        self.tabBarController?.tabBar.isHidden = false
    }
}

// LoginAndRegistDelegate
extension MineViewController
{
    func loginChange(value: NSInteger) {
        
        // 1、关闭view，回到个人中心   2、找回密码   3、用户协议    4、隐私政策
        switch value {
            
        case 1:
            self.style = .default
            setNeedsStatusBarAppearanceUpdate()
            
            hiddenLoginView(tim: 0.5)
            creatHidden(value: 0, time: 0.5)
            
            headTabView.viewWithTag(102)?.isHidden = false
            
            requestData()
            
        case 2:
            forgetPassWord()
            
        case 3:
            //print("用户协议")
            self.privzcyV.titlePrivacy.text = "今日头条用户协议"
            setPrivacyView()
            
        case 4:
            //print("隐私政策")
            self.privzcyV.titlePrivacy.text = "今日头条隐私政策"
            setPrivacyView()
            
        default:
            print("defaults")
        }
    }
    // 找回密码view弹出动画
    func forgetPassWord() {
        
        UIView.animate(withDuration: 0.5) {
            self.findView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH)
        }
    }
    
    // 协议view弹出动画
    func setPrivacyView() {
        
        UIView.animate(withDuration: 0.5) {
            self.privzcyV.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH)
        }
    }
}

// FindViewDelegate
extension MineViewController
{
    
    func findChange(value: NSInteger) {
        
        // 1、关闭当前找回密码view，回到登陆view   2、关闭找回密码view，回到个人中心
        switch value {
            
        case 1:
            hiddenFindView()
            
        case 2:
            hiddenLoginView(tim: 0.5)
            creatHidden(value: 0, time: 0.5)
            
        default:
            print("defaults")
        }
    }
    
    // 关闭找回密码view
    func hiddenFindView() {
        
        UIView.animate(withDuration: 0.5) {
            self.findView.frame = CGRect(x: kScreenW, y: 0, width: kScreenW, height: kScreenH)
        }
    }
    
}

// PrivacyViewDelegate
extension MineViewController
{
    func PrivacyChange(value: NSInteger) {
        
        // 1、关闭协议view，回到登陆view   2、更多
        switch value {
            
        case 1:
            hiddenPrivacyView()
            
        case 2:
            print("更多")
            
        default:
            print("defaults")
        }
    }
    
    // 关闭协议view
    func hiddenPrivacyView() {
        
        UIView.animate(withDuration: 0.5) {
            self.privzcyV.frame = CGRect(x: kScreenW, y: 0, width: kScreenW, height: kScreenH)
        }
    }
    
}

// OneKeyLoginViewDelegate
extension MineViewController
{
    func keyLoginChange(value: NSInteger) {
        
        // 1、关闭   2、更多登陆  3、隐私设置  4、移动协议  5、用户协议  6、隐私政策
        switch value {
            
        case 1:
            self.style = .default
            setNeedsStatusBarAppearanceUpdate()
            
            hiddenLoginView(tim: 0.5)
            creatHidden(value: 0, time: 0.5)
            
            headTabView.viewWithTag(102)?.isHidden = false
            
            requestData()

        case 2:
            print("更多")
            self.keyLoginView.isHidden = true
            
        case 3:
            print("隐私设置")
            
            let setVC = SetSViewController()
            self.navigationController?.pushViewController(setVC, animated: true)
            
        case 4:
            //print("移动协议")
            self.privzcyV.titlePrivacy.text = "中国移动认证服务协议"
            setPrivacyView()
            
        case 5:
            //print("用户协议")
            self.privzcyV.titlePrivacy.text = "今日头条用户协议"
            setPrivacyView()
            
        case 6:
            //print("隐私政策")
            self.privzcyV.titlePrivacy.text = "今日头条隐私政策"
            setPrivacyView()
            
        default:
            print("defaults")
        }
        
    }
    
}

// UITableViewDelegate,UITableViewDataSource
extension MineViewController : UITableViewDelegate,UITableViewDataSource
{
    // 分区数量
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrList.count
    }
    // 每区行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (arrList[section] as! NSArray).count
    }
    // 行高
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0
        {
            return 0.01
        }
        else if indexPath.section == 1
        {
            return customLayer(num: 79)
        }
        else
        {
            return customLayer(num: 46)
        }
    }
    // 分区头高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.01 : 5
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
        var cell = tableView.dequeueReusableCell(withIdentifier: "seller")
        
        if cell == nil
        {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "seller")
        }
        
        // 第一分区内容
        if indexPath.section == 1
        {
            cell?.contentView.addSubview(oneCellView)
        }
        
        // cell 属性（颜色、字体、大小）
        cell?.textLabel?.text = (arrList[indexPath.section] as! NSArray)[indexPath.row] as? String
        cell?.textLabel?.font = customFont(font: 16)
        cell?.textLabel?.textColor = RGBColor(r: 34, g: 34, b: 34)
        
        // 箭头类型cell
        if indexPath.section == 2 || indexPath.section == 3
        {
            cell?.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        }
        
        // 取消第一行cellg分割线
        if indexPath.section == 0
        {
            cell?.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: kScreenW)
        }
        
        return cell!
    }
    
    // 点击cell时处理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.section != arrList.count - 1  else {
            
            guard indexPath.row != 1 else {
                self.navigationController?.pushViewController(SetSViewController(), animated: true)
                return
            }
            
            return
        }
    }
    
    // 滑动时方法头部保持白色背景
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let point = scrollView.contentOffset
        
        var rect = headTabView.viewWithTag(101)?.frame
        
        if point.y < -headHeight
        {
            let y = abs(point.y)
            
            rect?.size.height = y
            rect?.origin.y = -y
            
            headTabView.viewWithTag(101)?.frame = rect!
        }
    }
    
    
}

// LoginClickDelegate
extension MineViewController : LoginClickDelegate
{
    func logClickChange(value: NSInteger) {
        
        // 1、登陆  2、个人信息
        switch value {
        case 1:
            //headTabView.viewWithTag(102)?.isHidden = false
            btnClick()
            
        case 2:
            //headTabView.viewWithTag(102)?.isHidden = true
            
            let perVC = PersonsViewController()
            perVC.perModel = model
            self.navigationController?.pushViewController(perVC, animated: true)
                        
        default:
            print("def")
        }
        
    }
}

