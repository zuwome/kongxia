//
//  ConfigSwift.swift
//  zuwome
//
//  Created by qiming xiao on 2019/2/27.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import Foundation
import UIKit

/**
  租我么常用黑色
 -* Color: (63, 58, 58)
 -* returns: Color
 */
let zzBlackColor = rgbColor(63, 58, 58)

/**
 租我么常用金色
 -* Color: (244, 203, 7)
 -* returns: Color
 */
let zzGoldenColor = rgbColor(244, 203, 7)

/**
 租我么背景灰色
 -* Color: (247, 247, 247)
 -* returns: Color
 */
let zzBackgroundColor = rgbColor(247, 247, 247)

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

let isiPhoneX = screenHeight == 812

let navigationBarHeight: CGFloat = isiPhoneX ? 88 : 64

let statusBarheight: CGFloat = isiPhoneX ? 44 : 20

let tabbarHeight: CGFloat = isiPhoneX ? (49 + 34) : 49

let screenSafeAreaBottomHeight: CGFloat = isiPhoneX ? 34 : 0
