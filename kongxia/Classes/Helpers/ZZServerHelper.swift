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
        req.corpid = Const.enterprice_wechat_id;
        req.url = Const.enterprice_wechat_url;
        WXApi.send(req, completion: nil)
    }
}
