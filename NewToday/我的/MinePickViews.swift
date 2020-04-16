//
//  MinePickViews.swift
//  NewToday
//
//  Created by iMac on 2019/9/25.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

// 代理传值
protocol MinePickDelegate : NSObjectProtocol {
    // 确定 取消
    func minePickChange(value:String, index:NSInteger, address: String)
}

class MinePickViews: UIView {
    
    var  jsonArr = NSArray()
    var comArr = NSArray()
    var first = "", twoText = ""
    
    
    
    // pickView  日期
    @IBOutlet weak var pickData: UIDatePicker!
    // pick 地址
    @IBOutlet weak var pickAddress: UIPickerView!
    // 声明一个变量用来记录选择的日期
    private var birthdayStr:String?
    // 是否操作过datapick
    var clickTag : Bool = false
    
    // 代理属性
    weak var delegate : MinePickDelegate?
    
    // 取消按钮
    @IBAction func cancelClick(_ sender: Any) {
        
        delegate?.minePickChange(value: "", index: 1, address: "")
    }
    
    // 确定按钮
    @IBAction func quedingClick(_ sender: Any) {
        
        if pickAddress.isHidden == false
        {
            delegate?.minePickChange(value: "", index: 2, address: "\(first)\(twoText)")
        }
        
        
        // 如果没有滑动日期，直接点击确定则返回当天日期
        if !clickTag
        {
            // 获取当天日期
            let date = Date()
            let calendar = Calendar.current
            
            // 转换年月日
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            
            // 拼接需要的日期
            birthdayStr = "\(year)-\(month)-\(day)"
        }
        
        // 通过代理返回当前日期
        delegate?.minePickChange(value: birthdayStr!, index: 2, address: "")
        
    }
    
    // 日期data
    @IBAction func pickChange(_ sender: UIDatePicker) {
        
        clickTag = true
        
        let formate = DateFormatter.init()
        // 想的要的类型，如：1991-02-03，yyyy代表年，MM代表月，dd是日，“-”是分隔符
        formate.dateFormat = "yyyy-MM-dd"
        // 需要的日期字符串
        birthdayStr = formate.string(from: sender.date)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func layoutSubviews() {
        super.layoutSubviews()
        createData()
    }
    
}

// 加载xib
extension MinePickViews
{
    class func loadFromNib() -> MinePickViews
    {
        return Bundle.main.loadNibNamed("MinePickViews", owner: nil, options: nil)?[0] as! MinePickViews
    }
}

extension MinePickViews : UIPickerViewDelegate,UIPickerViewDataSource
{
    // 多少列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // 每列个数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0
        {
            return jsonArr.count
        }
        else
        {
            return comArr.count
        }
    }
    
    // 每列内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0
        {
            return (jsonArr[row] as! NSDictionary)["t"] as? String
        }
        else
        {
            return (comArr[row] as! NSDictionary)["t"] as? String
        }
    }
    
    // 点击每个内容时
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0
        {
            // 点击第一个component获取第二个component的内容数组
            comArr = (jsonArr[row] as! NSDictionary)["c"] as! NSArray
            
            // 只点击城市默认地址
            first = (jsonArr[row] as! NSDictionary)["t"] as! String
            
            pickAddress.selectRow(0, inComponent: 1, animated: true)
            
            twoText = (comArr[0] as! NSDictionary)["t"] as! String
        }
        else
        {
            // 只点击城市对应的区默认地址
            let curInd = pickerView.selectedRow(inComponent: 0)
            
            first = (jsonArr[curInd] as! NSDictionary)["t"] as! String
            
            twoText = (comArr[row] as! NSDictionary)["t"] as! String
        }
        
        pickAddress.reloadComponent(1)
        
    }
    
}

extension MinePickViews
{
    private func createData() {
        
        let path = Bundle.main.path(forResource: "addre", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        // 带throws的方法需要抛异常
        do {
            /*
             * try 和 try! 的区别
             * try 发生异常会跳到catch代码中
             * try! 发生异常程序会直接crash
             */
            
            let data = try Data(contentsOf: url)
            let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            
            // 获取所有内容
            jsonArr = jsonData as! NSArray
            comArr = (jsonArr[0] as! NSDictionary)["c"] as! NSArray
            
            // 默认地址
            first = (jsonArr[0] as! NSDictionary)["t"] as! String
            twoText = (comArr[0] as! NSDictionary)["t"] as! String
            
        } catch let error as Error? {
            print("读取失败 \(String(describing: error))")
        }
        
        // 属性pick
        pickAddress.reloadAllComponents()
    }
    
    
    // 显示地址选择器
    func hiddecPickUI() {
        self.pickData.isHidden = true
        self.pickAddress.isHidden = false
    }
    // 显示日期选择器
    func hiddecAddressPick() {
        self.pickData.isHidden = false
        self.pickAddress.isHidden = true
    }
}
