//
//  UIColor+Extension.swift
//  CWWeChat
//
//  Created by chenwei on 16/6/22.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    /// Constructing color from hex string
    ///
    /// - Parameter hex: A hex string, can either contain # or not
    convenience init(hex string: String) {
        var hex = string.hasPrefix("#")
            ? String(string.dropFirst())
            : string
        guard hex.count == 3 || hex.count == 6
            else {
                self.init(white: 1.0, alpha: 0.0)
                return
        }
        if hex.count == 3 {
            for (index, char) in hex.enumerated() {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
            }
        }
        
        self.init(
            red:   CGFloat((Int(hex, radix: 16)! >> 16) & 0xFF) / 255.0,
            green: CGFloat((Int(hex, radix: 16)! >> 8) & 0xFF) / 255.0,
            blue:  CGFloat((Int(hex, radix: 16)!) & 0xFF) / 255.0, alpha: 1.0)
    }


    // 主要文字
    class func normalTextColor() -> UIColor {
        return UIColor(hex: "#353535")
    }
    
    class func chatSystemColor() -> UIColor {
        return UIColor(hex: "#09BB07")
    }
    
    class func navigationBarCocor() -> UIColor {
        return UIColor(hex: "#141414")
    }
    
    //tableView背景色
    class func tableViewBackgroundColor() -> UIColor {
        return UIColor(hex: "#EFEFF4")
    }
    
    //tableView分割线颜色
    class func tableViewCellLineColor() -> UIColor {
        return UIColor(hex: "#D9D9D9")
    }
    
    //searchBar Color
    class func searchBarTintColor() -> UIColor {
        return UIColor(hex: "#EEEEF3")
    }
    
    class func defaultBlackColor() -> UIColor {
        return UIColor(hex: "#2e3132")
    }
    
    class func searchBarBorderColor() -> UIColor {
        return UIColor(hex: "#EEEEF3")
    }
    
    class func redTipColor() -> UIColor {
        return UIColor(hex: "#D84042")
    }
    
    class func chatBoxColor() -> UIColor {
        return UIColor(hex: "#F4F4F6")
    }
    
    class func chatBoxLineColor() -> UIColor {
        return UIColor(hex: "#BCBCBC")
    }
    
}
