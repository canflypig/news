//
//  HomeTitleView.swift
//  NewToday
//
//  Created by iMac on 2019/9/26.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

protocol HomeTopTypeDelegte : NSObjectProtocol{
    // 标签分类
    func homeTopClassChange()
    // 点击标签分类传回点击标签的下标
    func clicksTitle(value:NSInteger)
}

class HomeTitleView: UIView {
    
    // 标题信息数组
    private var titles : [String]
    // 标题组件UILabel的数组
    private lazy var titleLabels : [UIButton] = [UIButton]()
    // 标签间距
    var originX:CGFloat = 20
    // 当前按钮 x 坐标点
    var sizreWidth:CGFloat = 0
    // 标签按钮
    var button:UIButton!
    // 用来转换button的点击状态
    var temo_btn: UIButton?
    // 代理属性
    weak var delegate:HomeTopTypeDelegte?
    
    var indexFlog = 1
    
    private var childVC : [UIViewController]
    
    // 初始化获取内容
    init(frame: CGRect, titlesList: [String], childs: [UIViewController]) {
        self.titles = titlesList
        self.childVC = childs
        super.init(frame: frame)

        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 标题的滚动视图
    private lazy var scrollView : UIScrollView = {
        
        var width_t = kScreenW
        
        indexFlog = UserDefaults.standard.object(forKey: "tabbarIndex") as! NSInteger
        
        switch indexFlog {
        case 1:
            width_t = kScreenW-40
        case 2:
            width_t = kScreenW
        case 3:
            width_t = kScreenW - 100
        default:
            print("def")
        }
        
        let scroll = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: width_t, height: 40))
        // 设置不显示滚动条
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        // 背景色
        scroll.backgroundColor = UIColor.white
        
        return scroll
    }()
    
    // 标签栏左右侧分类按钮
    private lazy var typeButton : UIButton = {
        
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: kScreenW-40, y: 0, width: 40, height: 40)
        button.setImage(UIImage(named: "home_type"), for: .normal)
        button.addTarget(self, action: #selector(btnClickType), for: .touchUpInside)
        
        return button
    }()
    
    // 小视频头部右侧标签按钮
    private lazy var videoButton : UIButton = {
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect(x: kScreenW-90, y: 0, width: 80, height: 40)
        btn.setImage(UIImage(named: "right_release"), for: .normal)
        btn.setTitle(" 发布", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitleColor(RGBColor(r: 34, g: 34, b: 34), for: .normal)
        
        btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        
        return btn
    }()
    
    // 灰线
    private lazy var line : UILabel = {
        let label = UILabel.init(frame: CGRect(x: 0, y: 39, width: kScreenW, height: 1))
        label.backgroundColor = RGBColor(r: 245, g: 245, b: 245)
        
        return label
    }()
    
    // 内容滑动视图
    private lazy var homeView : HomeContentView = {
        
        let homeV = HomeContentView.init(frame: CGRect(x: 0, y: 40, width: kScreenW, height: self.frame.size.height-45), childs: childVC)
        homeV.delegate = self
        
        return homeV
    }()
    
    // 点击头部标签分类按钮
    @objc private func btnClickType() {
        
        delegate?.homeTopClassChange()
    }
    
}

// 其它属性设置
extension HomeTitleView
{
    private func setUI() {
        
        // 添加标签滑动视图
        self.addSubview(scrollView)
        
        if indexFlog == 1
        {
            // 添加右侧分类按钮
            self.addSubview(typeButton)
        }
        if indexFlog == 3
        {
            self.addSubview(videoButton)
        }
        
        
        // 添加标签栏下灰线
        self.addSubview(line)
        // 添加标签按钮到滑动视图
        creatScrollButton()
        // 内容滑动视图
        self.addSubview(homeView)
    }
    
    // 设置标签
    private func creatScrollButton() {
        
        sizreWidth = originX
        
        // 循环创建标题
        for (index, title) in titles.enumerated() {
            
            // 当前文字宽高
            let rect = title.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 40), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:customFont(font: titleFont)], context: .none)
            
            // 显示文字的按钮初始化
            button = UIButton.init(type: .custom)
            button.frame = CGRect(x: sizreWidth, y: 0, width: rect.size.width+10, height: 40)
            button.tag = index
            button.setTitle(title, for: .normal)
            button.setTitleColor(RGBColor(r: 34, g: 34, b: 34), for: .normal)
            button.setTitleColor(RGBColor(r: 216, g: 72, b: 72), for: .selected)
            button.titleLabel?.font = customFont(font: titleFont)
            button.addTarget(self, action: #selector(clickButton(value:)), for: .touchUpInside)
            
            // 将所有标签按钮存入数组
            titleLabels.append(button)
            // 添加按钮到滑动视图
            scrollView.addSubview(button)
            
            // 默认选中第一个
            if index == 0
            {
                clickButton(value: button)
            }
            
            // 当前按钮的X坐标点
            sizreWidth += rect.size.width+originX
        }
        
        // 滑动视图可滑动区域大小
        scrollView.contentSize = CGSize(width: sizreWidth, height: 40)
    }
    
    // 点击标签按钮执行的其它操作写在这里
    @objc private func clickButton(value: UIButton) {
        
        // 状态处理
        if (temo_btn != nil)
        {
            temo_btn?.isSelected = false
        }
        value.isSelected = !value.isSelected
        self.temo_btn = value
        
        // 改变当前选中的按钮的字体大小
        self.titleLabels.forEach { (btn) in
            
            if btn != self.temo_btn
            {
                btn.titleLabel?.font = customFont(font: titleFont)
            }
            else
            {
                btn.titleLabel?.font = customFont(font: titleFont+2)
            }
        }
        
        if indexFlog != 3
        {
            // 选中当前标签判断是否居中
            titleBtnCenter(centerBtn: value)
        }
        
        // 点击标签时滑动内容视图到对应的位置
        btnChange(value: value.tag)
        
    }
    
    // 点击标签时滑动内容视图到对应的位置
    private func btnChange(value: NSInteger) {
        
        // 传回当前点击的标签下标
        delegate?.clicksTitle(value: value)
        
        // 拿到要滑动的长度
        let w_index:CGFloat = CGFloat(value)*self.frame.size.width
        
        // 展示当前内容到对应位置
        homeView.setScrollContentView(value: value)
        
        // 滑动到和当前点击的标签对应的scrollview内容
        homeView.scrollView.setContentOffset(CGPoint.init(x: w_index, y: 0), animated: false)
        
    }
    
    // 滚动标题选中居中
    private func titleBtnCenter(centerBtn: UIButton) {
        
        //计算偏移量
        var offsetX:CGFloat = centerBtn.center.x - UIScreen.main.bounds.size.width * 0.5
        
        if offsetX < 0
        {
            offsetX = 0
        }
        
        // 获取最大滚动范围
        let maxOffSetX : CGFloat = scrollView.contentSize.width - UIScreen.main.bounds.size.width+40
        
        if offsetX > maxOffSetX
        {
            offsetX = maxOffSetX
        }
        
        // 内容开始滑动/切换
        scrollView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: true)
    }
    
    
}

// 滑动内容视图改变当前标签状态
extension HomeTitleView : HomeContDelegate
{
    func contentChange(value: NSInteger) {
        
        // 根据value确定当前应该选中的标签按钮
        let selectBtn = titleLabels[value]
        // 调用选中方法
        clickButton(value: selectBtn)
        
    }
    
}
