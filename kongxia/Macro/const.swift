//
//  const.swift
//  kongxia
//
//  Created by qiming xiao on 2024/11/13.
//  Copyright © 2024 TimoreYu. All rights reserved.
//

import Foundation

struct Const {
    
    public static let umeng_key = "5d1dbbe13fc19512d3000025"
    public static let umeng_channel = "App Store"

    public static let umeng_redirect_url = "http://mobile.umeng.com/social"
    public static let umeng_sina_redirect_url = "http://sns.whalecloud.com/sina2/callback"
}

// MARK: wechat
extension Const {
    public static let wechat_id = "wxb712a8b40aed6d29"
    public static let wechat_secret = "fec73d5eaab29d326ecc735f9c5d76be"
    public static let wechat_universal_link = "https://active.zuwome.com/app/"
    
    public static let enterprice_wechat_id = "ww1066becb2c99e97b" // 企业ID
    public static let enterprice_wechat_url = "https://work.weixin.qq.com/kfid/kfc934ce09454760ab7" // 客服URL
}

// MARK: qq
extension Const {
    public static let qq_id = "1107772645"
    public static let qq_key = "njY4o0XywM3eYxoJ"
}

// MARK: sina
extension Const {
    public static let sina_id = "1107772645"
    public static let sina_secret = "njY4o0XywM3eYxoJ"
}

@objc class Consts: NSObject {
    
}
