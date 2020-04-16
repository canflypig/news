//
//  TypeCollectionViewCell.swift
//  NewToday
//
//  Created by iMac on 2019/9/27.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

class TypeCollectionViewCell: UICollectionViewCell {
    
    // 频道分类文字
    @IBOutlet weak var textLabel: UILabel!
    // 关闭按钮
    @IBOutlet weak var text_delt: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        creatTextUI()
    }
    
    // 文字属性设置
    private func creatTextUI() {
        
        self.textLabel.layer.cornerRadius = 5
        self.textLabel.layer.masksToBounds = true
        self.textLabel.font = customFont(font: 16)
        
        self.text_delt.layer.cornerRadius = 9
        self.text_delt.layer.masksToBounds = true
        
        self.text_delt.isHidden = true
    }
    
    // cell赋值
    public func cellDaraText(value: String, cellSection: NSInteger, cell: TypeCollectionViewCell, idEdis: Bool) {
        
        if cellSection == 0
        {
            // 判断是否编辑状态
            if idEdis
            {
                cell.text_delt.isHidden = false
            }
            else
            {
                cell.text_delt.isHidden = true
            }
            
            // 一区标签背景色和标签文字
            cell.textLabel.backgroundColor = RGBColor(r: 244, g: 245, b: 246)
            cell.textLabel.text = value
            
        }
        else
        {
            // 一区标签背景色和标签文字
            cell.textLabel.backgroundColor = UIColor.white
            cell.textLabel.layer.borderWidth = 3
            cell.textLabel.layer.borderColor = UIColor.groupTableViewBackground.cgColor            
            cell.textLabel.text = "+"+value
            cell.text_delt.isHidden = true
        }
        
        
    }

}
