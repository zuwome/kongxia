//
//  H5Urls.swift
//  kongxia
//
//  Created by qiming xiao on 2021/9/25.
//  Copyright © 2021 TimoreYu. All rights reserved.
//

import Foundation

@objc public class H5Url : NSObject {
    // 获取IP地址
    @objc static let fetchIpAddress: String = "http://pv.sohu.com/cityjson?ie=utf-8"
    
    // 充值协议
    @objc static let rechargeAgreement_zuwome: String  = "http://7xwsly.com1.z0.glb.clouddn.com/agreement/iosRecharge.html"
    @objc static let rechargeAgreement: String  = "http://7xwsly.com1.z0.glb.clouddn.com/agreement/iosRechargekx.html"

    // 苹果充值
    @objc static let rechargeAppleGuide: String  = "http://7xwsly.com1.z0.glb.clouddn.com/activity/applePay/applePay.html"
    
    // 提现规则
    @objc static let withdrawalRules : String  = "http://static.zuwome.com/transfer_rule.html"
    
    // 空虾隐私权政策
    @objc static let privacyProtocol: String = "http://v2.zuwome.com/agreementknew"
    
    // 空虾用户协议
    @objc static let userProtocol: String = "http://v2.zuwome.com/agreementk"
    
    // 优享邀约
    @objc static let youxiangOrderDetail: String = "http://7xwsly.com1.z0.glb.clouddn.com/wechat_service/detail376.html"
    
    // 申诉处理规则
    @objc static let chuliguize: String = "http://7xwsly.com1.z0.glb.clouddn.com/helper/zurengonglue/chuliguize-num-zwm.html"

    // 发布服务费退款规则
    @objc static let tonggaoPrepayRefundRules: String = "http://7xwsly.com1.z0.glb.clouddn.com/helper/shanzu_tonggao4.html"
    
    // 发布通告平台保障
    @objc static let tonggaoPlatformGuarantee : String = "http://7xwsly.com1.z0.glb.clouddn.com/helper/zurengonglueshanzu_tonggao.html"
    
    // 开通闪聊H5
    @objc static let fastChatOpeon = "http://7xwsly.com1.z0.glb.clouddn.com/activity/qChatApply/qChatApply.html"
    
    // 闪聊介绍
    @objc static let fastChatIntroduce = "http://7xwsly.com1.z0.glb.clouddn.com/activity/qChat/qChat.html"
    
    // 帮助与反馈
    @objc static let helpAndFeedback = "http://7xwsly.com1.z0.glb.clouddn.com/helper/helpAndfeedback.html?v=12"
    
    // 邀请达人
    @objc static let inviteDaren = "http://7xwsly.com1.z0.glb.clouddn.com/rent/sixingonglv2.html"
    @objc static let inviteDaren_zuwome = "http://7xwsly.com1.z0.glb.clouddn.com/rent/sixingonglv1.html"
    
    // 申请达人
    @objc static let registerRent = "http://static.zuwome.com/rent/apply.html"
    
    // 申请达人成功_头像人工审核中 (full_screen)
    @objc static let registerRentComplete_AvatarReviewing_fullScreen = "http://7xwsly.com1.z0.glb.clouddn.com/rent/apply_successkxx2.html"
    
    // 申请达人成功_头像人工审核中
    @objc static let registerRentComplete_AvatarReviewing = "http://7xwsly.com1.z0.glb.clouddn.com/rent/apply_successkx.html"
    
    // 达人信息管理
    @objc static let darenInfoManagement = "http://static.zuwome.com/rent/about_topic.html"
    
    // 积分规则说明
    @objc static let pointsRuleDescription = "http://static.zuwome.com/jifen/integral_rule.html"
    
    // 分享快照
    @objc static let sharePhoto = "http://static.zuwome.com/jifen/share_photo.html"
    
    // 违规行为手册
    @objc static let violationManual = "http://7xwsly.com1.z0.glb.clouddn.com/helper/zurengonglue/ruhepanding-num-zwm.html"
    
    // 平台担保支付
    @objc static let platformGuaranteePayment = "http://7xwsly.com1.z0.glb.clouddn.com/helper/zurengonglue/pingtaidanbao.html"
    
    // 紧急求助使用教程
    @objc static let emergencyHelpTutorial = "http://static.zuwome.com/emergency_help.html"
    
    // 如何找到自己的微信号
    @objc static let findWechatNoGuide = "http://7xwsly.com1.z0.glb.clouddn.com/wechat/how_to_get_wechat.html"
    
    // 成为闪租达人
    @objc static let becomeShanZuDaren = "http://7xwsly.com1.z0.glb.clouddn.com/manrent/index.html"
    
    // 达人邀约服务协议
    @objc static let invitationServiceAgreement = "http://7xr43m.com1.z0.glb.clouddn.com/leasedPeople.html"
    
    // 出租审核服务协议
    @objc static let rentalAuditServiceAgreement = "http://7xr43m.com1.z0.glb.clouddn.com/rentalAudit.html"
    
    // 达人攻略
    @objc static let darenGuide = "http://7xwsly.com1.z0.glb.clouddn.com/zqgl/moneyStrategy2.html?v=3"
    
    // 租我么攻略
    @objc static let kongXiaGuide = "http://7xwsly.com1.z0.glb.clouddn.com/wmgy/playHelp.html"
    
    // 如何上精选视频
    @objc static let beingSelectedRecommendVideoGuide = "http://7xwsly.com1.z0.glb.clouddn.com/iWant/iWant.html"
    
    // 么么哒, 钱包
    @objc static let mmdDesc = "http://7xwsly.com1.z0.glb.clouddn.com/agreement/mmd_desc.html"
    
    // 分享app
    @objc static let shareApp_debug = "http://7xwsly.com1.z0.glb.clouddn.com/rent/gonglvjieshao_test.html?channelCode=allChannel"
    @objc static let shareApp = "http://7xwsly.com1.z0.glb.clouddn.com/rent/gonglvjieshao.html?channelCode=allChannel"
    
    static let DeleAccount = "http://7xwsly.com1.z0.glb.clouddn.com/logoutRule.html"
}

