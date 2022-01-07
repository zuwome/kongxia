//
//  ZZWXOrderModel.swift
//  zuwome
//
//  Created by qiming xiao on 2019/2/25.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit
import ObjectMapper

enum WxOrderStatus {
    case buyer_bought  // 买方待添加
    case buyer_confirm // 买方已添加,待评价
    case buyer_commented // 买方已评价
    case buyer_reporting // 买方举报中
    case buyer_reportSuccess // 买方举报完成
    case buyer_reportFail // 买方举报失败
    case buyer_waitToBeEvaluated // 卖方已添加,等待买方确认
    
    case seller_bought // 卖方待添加
    case seller_confirm // 卖方已添加,等待买方确认
    case seller_waitToBeEvaluated // 买方已添加,等待卖方确认
    case seller_complete // 买方确认添加,已评价
    case seller_autoComplete // 自动结束
    case seller_beingReported // 卖方被举报中
    case seller_reported // 卖方举报完成
    case seller_reportSuccess // 卖方举报完成
    case seller_reportFail // 卖方举报失败
    case none
}

class ZZWXOrderModel: Mappable {
    var orderStatus: WxOrderStatus = .none
    var isBuy: Bool = true
    
    var isNew: Bool?
    var _doc: WXOrderInfoModel?
    var to_msg: Dictionary<String, Any>?
    var from_msg: Dictionary<String, Any>?
    
    var customerService: String = "zwm"
    
    var cellOrWechat: String?
    
    init(){
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        isNew    <- map["isNew"]
        to_msg   <- map["to_msg"]
        from_msg <- map["from_msg"]
        _doc     <- map["_doc"]
        
        setOrderStatus(userID: ZZUserHelper.shareInstance()!.loginerId)
    }
    
    func setOrderStatus(userID: String) {
        let from_confirm_type = _doc?.from_confirm_type ?? -999
        let to_confirm_type = _doc?.to_confirm_type ?? -999
        let arrival_type = _doc?.arrival_type ?? -999
        
        if userID == _doc?.from?._id! {
            isBuy = true
            // 买方
            switch from_confirm_type {
            case 0:
                orderStatus = .buyer_bought
                
                if arrival_type == -1 {
                    orderStatus = .buyer_reporting
                }
                else if arrival_type == -2 {
                    orderStatus = .buyer_reportSuccess
                }
                else if arrival_type == -3 {
                    orderStatus = .buyer_reportFail
                }
            case 1:
                orderStatus = .buyer_confirm
            case 2:
                orderStatus = .buyer_commented
            case 3:
                orderStatus = .buyer_waitToBeEvaluated
                if arrival_type == -1 {
                    orderStatus = .buyer_reporting
                }
                else if arrival_type == -2 {
                    orderStatus = .buyer_reportSuccess
                }
                else if arrival_type == -3 {
                    orderStatus = .buyer_reportFail
                }
            case -1:
                orderStatus = .buyer_reportSuccess
            default:
                orderStatus = .none
            }

        }
        else if userID == _doc?.to?._id! {
            isBuy = false
            // 卖方
            switch to_confirm_type {
            case 0:
                orderStatus = .seller_bought
                
                if arrival_type == -1 {
                    orderStatus = .seller_beingReported
                }
                else if arrival_type == -2 {
                    orderStatus = .seller_reportSuccess
                }
                else if arrival_type == -3 {
                    orderStatus = .seller_reportFail
                }
            case 1:
                orderStatus = .seller_confirm
                if arrival_type == -1 {
                    orderStatus = .seller_beingReported
                }
                else if arrival_type == -2 {
                    orderStatus = .seller_reportSuccess
                }
                else if arrival_type == -3 {
                    orderStatus = .seller_reportFail
                }
            case 3:
                orderStatus = .seller_waitToBeEvaluated
            case 2:
                orderStatus = .seller_complete
            case 4:
                orderStatus = .seller_autoComplete
            case -1:
                orderStatus = .seller_reportSuccess
            default:
                orderStatus = .none
            }
        }

    }
    
    func setStatus(isBuy: Bool) {
        self.isBuy = isBuy
        let from_confirm_type = _doc?.from_confirm_type ?? -999
        let to_confirm_type = _doc?.to_confirm_type ?? -999
        let arrival_type = _doc?.arrival_type ?? -999
        
        if isBuy {
            switch from_confirm_type {
            case 0:
                orderStatus = .buyer_bought
                
                if arrival_type == -1 {
                    orderStatus = .buyer_reporting
                }
                else if arrival_type == -2 {
                    orderStatus = .buyer_reportSuccess
                }
                else if arrival_type == -3 {
                    orderStatus = .buyer_reportFail
                }
            case 1:
                orderStatus = .buyer_confirm
            case 2:
                orderStatus = .buyer_commented
                
            default:
                orderStatus = .none
            }
        }
        else {
            switch to_confirm_type {
            case 0:
                orderStatus = .seller_bought
                
                if arrival_type == -1 {
                    orderStatus = .seller_beingReported
                }
                else if arrival_type == -2 {
                    orderStatus = .seller_reportSuccess
                }
                else if arrival_type == -3 {
                    orderStatus = .seller_reportFail
                }
            case 1:
                orderStatus = .seller_confirm
            case 3:
                orderStatus = .seller_waitToBeEvaluated
            case 2:
                orderStatus = .seller_complete
            default:
                orderStatus = .none
            }
        }
    }
}

class WXOrderInfoModel: Mappable {
    var wechat_no: String?
    var status: Int?
    var created_at: String?
    var order_type: Int?
    
    // 到账状态 0 未到账，1 到账 -1举报状态 -2举报成功 -3举报失败
    var arrival_type: Int?
    
    // 发起人确认状态 0 待添加，1 已添加/待评价     2 完成状态   3待确认（达人确认，用户未确认）
    var from_confirm_type: Int?
    
    // 被查看人确认状态 0 待添加，1 已添加（等待用户方确认）    2 已完成   3 待评价（等待用户评价）
    var to_confirm_type: Int?
    var __v: Int?
    var price: Double?
    var yj_price: Double?
    var to_price: Double?
    var paid_channel: String?
    var paid_at: String?
    var chargeId: Int?
    var action_by: String?
    var _id: String?
    var from: WXOrderUserInfoModel?
    var to: WXOrderUserInfoModel?
    var to_wechat_img: String?
    var wechat_comment: ZZWxOrderCommentModel?
    
    init(){
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        wechat_no         <- map["wechat_no"]
        status            <- map["status"]
        created_at        <- map["created_at"]
        order_type        <- map["order_type"]
        arrival_type      <- map["arrival_type"]
        from_confirm_type <- map["from_confirm_type"]
        to_confirm_type   <- map["to_confirm_type"]
        __v               <- map["__v"]
        price             <- map["price"]
        yj_price          <- map["yj_price"]
        to_price          <- map["to_price"]
        paid_channel      <- map["paid_channel"]
        paid_at           <- map["paid_at"]
        chargeId          <- map["chargeId"]
        action_by         <- map["action_by"]
        _id               <- map["_id"]
        from              <- map["from"]
        to                <- map["to"]
        to_wechat_img     <- map["to_wechat_img"]
        wechat_comment    <- map["wechat_comment"]
    }
    
}

class ZZWxOrderCommentModel: Mappable {
    var _id: String?
    var score: Int?
    var to: String?
    var from: String?
    var __v: Int?
    var created_at: String?
    var content: NSArray?
    
    init(){
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _id      <- map["_id"]
        score    <- map["score"]
        to   <- map["to"]
        from <- map["from"]
        __v   <- map["__v"]
        created_at    <- map["created_at"]
        content    <- map["content"]
    }
    
}

class WXOrderUserInfoModel: Mappable {
    var _id: String?
    var ZWMId: Int?
    var avatar: String?
    var nickname: String?
    var wechat: WXOrderUserInfoWechatModel?
    var weibo: WXOrderUserInfoWeiboModel?
    var gender: Int?
    var level: Int?
    var avatar_detect_status: Int?
    var avatar_manual_status: Int?
    var old_avatar: String?
    
    init(){
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _id      <- map["_id"]
        ZWMId    <- map["ZWMId"]
        avatar   <- map["avatar"]
        nickname <- map["nickname"]
        wechat   <- map["wechat"]
        weibo    <- map["weibo"]
        gender   <- map["gender"]
        level    <- map["level"]
        avatar_detect_status <- map["avatar_detect_status"]
        avatar_manual_status <- map["avatar_manual_status"]
    }
}

class WXOrderUserInfoWechatModel: Mappable {
    var no: String?
    
    init(){
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        no         <- map["no"]
    }
}

class WXOrderUserInfoWeiboModel: Mappable {
    var verified: Bool?
    
    init(){
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        verified <- map["verified"]
    }
}

class WXOrderEvaluationModel: Mappable {
    var content: [String]?
    var score: Int? = -1
    
    init(){
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        content         <- map["content"]
        score         <- map["score"]
    }
}
