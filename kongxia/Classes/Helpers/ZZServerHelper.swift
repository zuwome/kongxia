//
//  ZZServerHelper.swift
//  kongxia
//
//  Created by qiming xiao on 2022/5/15.
//  Copyright © 2022 TimoreYu. All rights reserved.
//

import Foundation

@objc class ZZServerHelper: NSObject {
    @objc public static func showServer() {
        let req = WXOpenCustomerServiceReq()
        req.corpid = "ww1066becb2c99e97b";    //企业ID
        req.url = "https://work.weixin.qq.com/kfid/kfc934ce09454760ab7";            //客服URL
        WXApi.send(req, completion: nil)
    }
}
