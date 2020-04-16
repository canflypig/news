//
//  HomeContentView.swift
//  NewToday
//
//  Created by iMac on 2019/9/26.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

// 代理传值
protocol HomeContDelegate : NSObjectProtocol {
    
    func contentChange(value:NSInteger)
}

class HomeContentView: UIView {
    
    // 子控制器数组
    private var childVC : [UIViewController]
    // 代理属性
    weak var delegate : HomeContDelegate?
    
    // 初始化获取内容
    init(frame: CGRect, childs: [UIViewController]) {
        self.childVC = childs
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 内容滚动视图
    public lazy var scrollView : UIScrollView = {
        
        let scrol = UIScrollView.init(frame: self.bounds)
        scrol.isPagingEnabled = true
        scrol.showsVerticalScrollIndicator = false
        scrol.showsHorizontalScrollIndicator = false
        scrol.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
        scrol.delegate = self
        
        return scrol
    }()

}

// 其它属性设置
extension HomeContentView
{
    // 添加视图
    private func setUI() {
        
        self.addSubview(scrollView)
        
        setScrollContentView(value: 0)
    }
    
    // 初始化滑动视图要展示的控制器
    public func setScrollContentView(value:NSInteger) {
        
        // 遍历标签，以便确定有多少控制器
        for (index,_) in childVC.enumerated() {
            
            // 大小
            self.childVC[index].view.frame = CGRect(x: kScreenW*CGFloat(value), y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
            
            // 添加内容控制器到滑动视图
            scrollView.addSubview(self.childVC[index].view)
        }
        
        // 所有控制器加起来的最大长度
        let width = CGFloat(childVC.count)*self.frame.size.width
        
        // 滑动视图可滑动的最大区域
        scrollView.contentSize = CGSize(width: width, height: self.frame.size.height)
        
    }
    
    
}

extension HomeContentView : UIScrollViewDelegate
{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let currentIndex: NSInteger = NSInteger(scrollView.contentOffset.x)/NSInteger(scrollView.frame.size.width)
        
        delegate?.contentChange(value: currentIndex)
    }
}
