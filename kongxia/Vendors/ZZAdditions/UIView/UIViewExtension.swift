//
//  UIViewExtension.swift
//  kongxia
//
//  Created by qiming xiao on 2022/1/8.
//  Copyright © 2022 TimoreYu. All rights reserved.
//

import UIKit

extension UIView {
    var top : CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set(newValue) {
            if newValue != self.frame.origin.y {
                var frame = self.frame
                frame.origin.y = newValue
                self.frame = frame
            }
        }
    }
    
    var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        
        set(newValue) {
            if newValue != self.frame.origin.x {
                var frame = self.frame
                frame.origin.x = newValue
                self.frame = frame
            }
        }
    }
    
    var right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        
        set(newValue) {
            var frame = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
    }
    
    var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        
        set(newValue) {
            var frame = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.width
        }
        
        set(newValue) {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.height
        }
        
        set(newValue) {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
}
