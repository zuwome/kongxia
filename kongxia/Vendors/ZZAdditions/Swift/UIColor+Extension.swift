//
//  Color.swift
//  SwiftProject
//
//  Created by Tony on 2018/8/28.
//  Copyright © 2018年 Qming.xiao. All rights reserved.
//

import UIKit

public extension UIColor {
    /**
      租我么常用黑色
     -* Color: (63, 58, 58)
     -* returns: Color
     */
    static var zzBlack: UIColor {
        return .rgbColor(63, 58, 58)
    }

    /**
     租我么常用金色
     -* Color: (244, 203, 7)
     -* returns: Color
     */
    static var golden: UIColor {
        return .rgbColor(244, 203, 7, 1)
    }

    /**
     租我么背景灰色
     -* Color: (247, 247, 247)
     -* returns: Color
     */
    static var zzBackground: UIColor {
        return .rgbColor(247, 247, 247, 1)
    }
}

public extension UIColor {
    
    static var random: UIColor {
        let red = arc4random() % 255
        let green = arc4random() % 255
        let blue = arc4random() % 255
        return self.rbga(red: Float(red),
                         green: Float(green),
                         blue: Float(blue))
    }

    static func hexColor(_ hexString: String) -> UIColor {
        
        if !hexString.hasPrefix("#") {
            return .white
        }
        
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if (cString.count) != 6 {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    
    static func rgbColor(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1.0) -> UIColor {
        return rbg(red: Float(r), green: Float(g), blue: Float(b), alpha: Float(a))
    }
    
    static func rbg(red: Float,
                             green: Float,
                             blue: Float,
                             alpha: Float = 1.0) -> UIColor {
        return UIColor.rbga(red: red,
                          green: green,
                          blue: blue,
                          alpha: alpha)
    }
    
    static func rbga(red: Float,
                              green: Float,
                              blue: Float,
                              alpha: Float = 1.0) -> UIColor {
        return UIColor.init(red: CGFloat(red / 255.0),
                          green: CGFloat(green / 255.0),
                          blue: CGFloat(blue / 255.0),
                          alpha: CGFloat(alpha))
    }
}
