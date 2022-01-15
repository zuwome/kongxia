//
//  ConfigSwift.swift
//  zuwome
//
//  Created by qiming xiao on 2019/2/27.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import Foundation
import UIKit

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

let isiPhoneX = screenHeight == 812

let navigationBarHeight: CGFloat = isiPhoneX ? 88 : 64

let statusBarheight: CGFloat = isiPhoneX ? 44 : 20

let tabbarHeight: CGFloat = isiPhoneX ? (49 + 34) : 49

let screenSafeAreaBottomHeight: CGFloat = isiPhoneX ? 34 : 0
