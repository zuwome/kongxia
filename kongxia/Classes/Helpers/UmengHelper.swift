//
//  WxHelper.swift
//  kongxia
//
//  Created by qiming xiao on 2024/11/13.
//  Copyright © 2024 TimoreYu. All rights reserved.
//

import Foundation
import UMCommon

@objc class UmengHelper: NSObject {
    @objc public static func configUmeng() {
        initUmeng()
        initUmengShare()
    }
    
    private static func initUmeng() {
        UMConfigure.initWithAppkey(Const.umeng_key, channel: Const.umeng_channel)
        
        UMSocialGlobal.shareInstance().universalLinkDic = [
            NSNumber(value: UMSocialPlatformType.wechatSession.rawValue): Const.wechat_universal_link,
            NSNumber(value: UMSocialPlatformType.QQ.rawValue): "https://umplus-sdk-download.oss-cn-shanghai.aliyuncs.com/qq_conn/101830139",
            NSNumber(value: UMSocialPlatformType.sina.rawValue): "https://umplus-sdk-download.oss-cn-shanghai.aliyuncs.com/"
        ]
        
        UMSocialGlobal.shareInstance().extraInitDic = [
            NSNumber(value: UMSocialPlatformType.wechatWork.rawValue): [
                "corpId": "wwac6ffb259ff6f66a",
                "agentId": "1000002"
            ]
        ]
    }
    
    private static func initUmengShare() {
        UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatSession, appKey: Const.wechat_id, appSecret: Const.wechat_secret, redirectURL: Const.umeng_redirect_url)
        UMSocialManager.default().setPlaform(UMSocialPlatformType.QQ, appKey: Const.qq_id, appSecret: Const.qq_key, redirectURL: Const.umeng_redirect_url)
        UMSocialManager.default().setPlaform(UMSocialPlatformType.sina, appKey: Const.sina_id, appSecret: Const.sina_secret, redirectURL: Const.umeng_sina_redirect_url)
    }
    
    @objc public static func authen(platform: UMSocialPlatformType, in controller: UIViewController, completion: @escaping (Any?, Error?) -> Void) {
        UMSocialManager.default().auth(with: platform, currentViewController: controller, completion: completion)
    }
    
    @objc public static func handle(url: URL) -> Bool {
        UMSocialManager.default().handleOpen(url, options: [:])
    }

}
