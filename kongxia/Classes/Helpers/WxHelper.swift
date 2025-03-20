//
//  WxHelper.swift
//  kongxia
//
//  Created by qiming xiao on 2024/11/13.
//  Copyright © 2024 TimoreYu. All rights reserved.
//

import Foundation

@objc class WxHelper: NSObject {
    @objc public static let shared = WxHelper()
    
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
    
    @objc public static func fetchAuthen() {
        WxHelper.shared.fetchAuthen()
    }
    
    @objc public static func fetchWxInfo(code: String, success: @escaping (String, String) -> Void, failure: @escaping (Error?, String) -> Void) {
        
        WxHelper.shared.fetchWechatAccessToken(code: code,
                                               success: success,
                                               failure: failure)
    }
}

extension WxHelper {
    private func fetchAuthen() {
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = "wx_oauth_authorization_state"
        WXApi.send(req, completion: nil)
    }
    
    private func fetchWechatAccessToken(code: String, success: @escaping (String, String) -> Void, failure: @escaping (Error?, String) -> Void) {
        let url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(Const.wechat_id)&secret=\(Const.wechat_secret)&code=\(code)&grant_type=authorization_code"
        
        requestData(url: url) { code, res in
            guard let dic = res as? [String: Any] else {
                return
            }
            
            if let accessToken = dic["access_token"] as? String, let openid = dic["openid"] as? String {
                success(accessToken, openid)
            }
        } failure: { error, errMsg in
            failure(error, errMsg)
        }

    }
    
    func requestData(url: String, success: @escaping (Int, Any) -> Void, failure: @escaping (Error?, String) -> Void) {
        guard let url = URL(string: url) else {
            failure(nil, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                failure(error, error.localizedDescription)
                return
            }
            
            guard let data = data else {
                failure(nil, "No data received")
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let httpResponse = response as? HTTPURLResponse {
                        let statusCode = httpResponse.statusCode
                        if statusCode == 200 {
                            success(statusCode, jsonResponse)
                        } else {
                            failure(nil, "HTTP Error \(statusCode)")
                        }
                    }
                }
            } catch let jsonError {
                failure(jsonError, jsonError.localizedDescription)
            }
        }
        
        task.resume()
    }
}
