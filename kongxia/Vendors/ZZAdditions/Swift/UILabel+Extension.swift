//
//  UILabel+Extension.swift
//  zuwome
//
//  Created by qiming xiao on 2019/2/26.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    convenience init(text: String?, font: UIFont, textColor: UIColor) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
    }
}
