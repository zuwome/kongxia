//
//  PingppHelper.swift
//  kongxia
//
//  Created by qiming xiao on 2024/11/12.
//  Copyright © 2024 TimoreYu. All rights reserved.
//

import Foundation

let kBackendChargeURL = "http://218.244.151.190/demo/charge" // 你的服务端创建并返回 charge 的 URL 地址，此地址仅供测试用。如果该地址失效，请使用你自己的后端接口。
// 以下参数的相关说明请查看 Objective-C 相关文件
let kAppURLScheme = "demoappswift" // 这个是你定义的 URL Scheme，支付宝、微信支付和测试模式需要。

struct PingPPConst {
    public static let kAppUrlScheme = "kongxia"
}

@objc class PingppHelper:NSObject {

    @objc public static func pay(payment: NSData,
                           completeHandler: @escaping (_ result: String?, _ error: PingppError?) -> Void) {
        
        Pingpp.createPayment(payment as NSObject,
                             appURLScheme: PingPPConst.kAppUrlScheme) { (result, error) -> Void in
            completeHandler(result, error)
            print(result)
        }
    }
    
    @objc public static func handle(url: URL) -> Bool {
        Pingpp.handleOpen(url, withCompletion: nil)
    }
}
