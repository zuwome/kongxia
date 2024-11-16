//
//  WxHelper.swift
//  kongxia
//
//  Created by qiming xiao on 2024/11/13.
//  Copyright © 2024 TimoreYu. All rights reserved.
//

import Foundation

@objc class WxHelper: NSObject {
    
    @objc public static func IsWechatInstalled() -> Bool {
        WXApi.isWXAppInstalled()
    }
    
    @objc public static func openWechat() {
        guard let url = URL(string: "weixin://") else { return }
        
        guard UIApplication.shared.canOpenURL(url) else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc public static func register() {
        WXApi.registerApp(Const.wechat_id, universalLink: Const.wechat_universal_link)
    }
    
}
