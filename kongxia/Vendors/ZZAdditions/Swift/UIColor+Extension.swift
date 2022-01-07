//
//  Color.swift
//  SwiftProject
//
//  Created by Tony on 2018/8/28.
//  Copyright © 2018年 Qming.xiao. All rights reserved.
//

import UIKit

//let ColorMake: (UInt32) -> UIColor = {UIColor()}

//enum ColorSetting {
//    case 
//}

typealias Color = UIColor

let randomColor: () -> UIColor = { Color.random }
let hexColor: (String) -> UIColor = {Color.hexColor($0)}
let rgbColor: (_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor = {Color.rgbColor($0, $1, $2)}
let rgbaColor: (_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor = {Color.rgbColor($0, $1, $2, $3)}
public extension UIColor {
    internal static var random: Color {
        return self.randomColor()
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
    
    internal static func randomColor() -> Color {
        let red = arc4random() % 255
        let green = arc4random() % 255
        let blue = arc4random() % 255
        return self.rbga(red: Float(red),
                         green: Float(green),
                         blue: Float(blue))
    }
    
    internal static func rbg(red: Float,
                             green: Float,
                             blue: Float,
                             alpha: Float = 1.0) -> Color {
        return Color.rbga(red: red,
                          green: green,
                          blue: blue,
                          alpha: alpha)
    }
    
    internal static func rbga(red: Float,
                              green: Float,
                              blue: Float,
                              alpha: Float = 1.0) -> Color {
        return Color.init(red: CGFloat(red / 255.0),
                          green: CGFloat(green / 255.0),
                          blue: CGFloat(blue / 255.0),
                          alpha: CGFloat(alpha))
    }
}
