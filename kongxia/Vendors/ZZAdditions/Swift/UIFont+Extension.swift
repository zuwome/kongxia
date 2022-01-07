//
//  UIFont+Extension.swift
//  zuwome
//
//  Created by qiming xiao on 2019/2/28.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import Foundation

let font: (Float) -> UIFont = { UIFont.systemFont(ofSize: CGFloat($0)) }

let sysFont: (Float) -> UIFont = { UIFont.systemFont(ofSize: CGFloat($0)) }

let boldFont: (Float) -> UIFont = { UIFont.boldSystemFont(ofSize: CGFloat($0)) }
