//
//  ZZPaymentManager.swift
//  zuwome
//
//  Created by qiming xiao on 2019/2/26.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit


@objc class ZZPaymentManager: NSObject {
    @objc static let shared = ZZPaymentManager()
    var parentVC: UIViewController? = nil
    var buyCompleteClosure: ((_ isComplete: Bool, _ type: NSString) -> Void)?
    var rechargeCompleteClosure: ((Bool) -> Void)?
    var paymentView: ZZPaymentView? = nil
    var payView: ZZIAPPayView? = nil
    
    var payItem: ZZWeiChatEvaluationModel?
    
    private override init() {
        SVProgressHUD.setDefaultMaskType(.clear)
    }
    
    deinit {
        SVProgressHUD.setDefaultMaskType(.none)
    }
    
    class func sharedInstance() -> ZZPaymentManager {
        return ZZPaymentManager.shared
    }

    @objc func buyItem(payItem: ZZWeiChatEvaluationModel,
                       in viewController: UIViewController?,
                       buyComplete: @escaping (_ isComplete: Bool, _ type: NSString) -> Void,
                       rechargeComplete: @escaping (Bool) -> Void) {
        self.buyCompleteClosure = buyComplete
        self.rechargeCompleteClosure = rechargeComplete
        
        self.parentVC = viewController
        self.payItemClicked(type: payItem.type)
        self.payItem = payItem
        // 还未购买
        if !payItem.isBuy {
            
            // 统计点击购买的次数
            self.viewClicked()
            
            // 正在电话中不允许其他消费
            guard ZZUtils.isConnecting() != true else {
                return
            }
            
            SVProgressHUD.show()
            
            // 获取用户的账户信息(余额)
            fetchBalance {
                if payItem.type == .WX {
                    // 只有微信才能使用优惠卷 其他的都不行
                    self.fetchCoupon(block: { (coupon) in
                        if let userHelper = ZZUserHelper.shareInstance() {
                            // 如果钱够的话就不需要获取iIAP了
                            if userHelper.loginer.mcoin.doubleValue > payItem.mcoinForItem {
                                self.showPaymentView(vc: viewController, payItem: payItem, iapList: nil, coupon: coupon)
                            }
                            else {
                                // 获取内购
                                self.fetchIAPList(closure: { (iapArray) in
                                    self.showPaymentView(vc: viewController, payItem: payItem, iapList: iapArray, coupon: coupon)
                                })
                            }
                        }
                    })
                }
                else if payItem.type == .gift || payItem.type == .ktvGift {
                    // 礼物直接跳出内购的
                    self.fetchFullIAPList(closure: { (iapArray) in
                        self.showPayView(payItem: payItem, iapList: iapArray)
                    })
                }
                else {
                    if let userHelper = ZZUserHelper.shareInstance() {
                        // 如果钱够的话就不需要获取iIAP了
                        if userHelper.loginer.mcoin.doubleValue > payItem.mcoinForItem {
                            self.showPaymentView(vc: viewController, payItem: payItem, iapList: nil, coupon: nil)
                        }
                        else {
                            // 获取内购
                            self.fetchIAPList(closure: { (iapArray) in
                                self.showPaymentView(vc: viewController, payItem: payItem, iapList: iapArray, coupon: nil)
                            })
                        }
                    }
                }
            }
        }
    }
    
    func showPaymentView(vc: Any?, payItem: ZZWeiChatEvaluationModel, iapList: [ZZMeBiModel]?, coupon: ZZWxCouponModel?) {
        paymentView = ZZPaymentView.show(paymentModel: payItem, iapList: iapList, coupon: coupon)
        paymentView?.delegate = self
    }
    
    func showPayView(payItem: ZZWeiChatEvaluationModel, iapList: [ZZMeBiModel]?) {
        payView = ZZIAPPayView.show(paymentModel: payItem, iapList: iapList)
        payView?.delegate = self
    }
    
    // 统计是查看微信还是查看证件照
    func payItemClicked(type: PaymentType) {
        if type == .idPhoto {
            MobClick.event(Event_click_userpage_IDPhoto_check)
        }
        else if type == .WX {
            MobClick.event(Event_click_userpage_wx_check)
        }
    }
}

// MARK: - Request
extension ZZPaymentManager {
    // 统计点击购买的次数
    func viewClicked() {
        guard let version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, version != "3.7.5" else {
            return
        }
        ZZRequest.method("GET", path: "/api/user/mcoin/recharge/click", params: nil, next: nil)
    }
    
    // 获取当前余额
    func fetchBalance(closure: @escaping () -> Void) {
        ZZUserHelper.updateTheBalanceNext { (error, data, task) in
            guard error == nil else {
                return
            }
            closure()
        }
    }
    
    // 获取内购项目列表(比较少的)
    func fetchIAPList(closure: @escaping (_ iapList: [ZZMeBiModel]) -> Void) {
        ZZMeBiModel.getIAPWithWechatPayList { (error, data, task) in
            if error != nil {
                ZZHUD.showTastInfoError(with: error?.message)
                return;
            }
            
            var IAPArray = [ZZMeBiModel]()
            
            if let iapRowArray = data as? NSArray {
                iapRowArray.forEach({ (iap) in
                    if let iapDic = iap as? NSDictionary {
                        let iapModel = try? ZZMeBiModel(dictionary: iapDic as? [AnyHashable : Any])
                        IAPArray.append(iapModel!)
                    }
                })
                
                closure(IAPArray)
            }
        }
    }
    
    // 获取内购的所有项目
    func fetchFullIAPList(closure: @escaping (_ iapList: [ZZMeBiModel]) -> Void) {
        ZZMeBiModel.fetchRechargeMebiList { (error, data, _) in
            if let error = error {
                ZZHUD.showError(withStatus: error.message)
                return
            }
            
            var IAPArray = [ZZMeBiModel]()
            
            if let iapRowArray = data as? NSArray {
                iapRowArray.forEach({ (iap) in
                    if let iapDic = iap as? NSDictionary {
                        let iapModel = try? ZZMeBiModel(dictionary: iapDic as? [AnyHashable : Any])
                        IAPArray.append(iapModel!)
                    }
                })
                
                closure(IAPArray)
            }
        }
    }
     
    func fetchPriceList(closure: @escaping (_ iapList: [ZZMeBiModel]) -> Void) {
        var type: String = "wechat"
        if payItem?.type == .WX {
            type = "wechat"
        }
        else if payItem?.type == .idPhoto {
            type = "id_photo"
        }
        ZZMeBiModel.fetchPriceList(type) { (error, data, _) in
            if error != nil {
                ZZHUD.showTastInfoError(with: error?.message)
                return;
            }
            
            var IAPArray = [ZZMeBiModel]()
            
            if let iapRowArray = data as? NSArray {
                iapRowArray.forEach({ (iap) in
                    if let iapDic = iap as? NSDictionary {
                        let iapModel = try? ZZMeBiModel(dictionary: iapDic as? [AnyHashable : Any])
                        IAPArray.append(iapModel!)
                    }
                })
                
                closure(IAPArray)
            }
        }
    }
    
    // 获取优惠卷
    func fetchCoupon(block: @escaping (_ coupon: ZZWxCouponModel?) -> Void) {
        guard let userID = ZZUserHelper.shareInstance().loginer.uid else {
            return
        }
        ZZRequest.method("GET", path: "/api/wechat/voucher", params: ["userId": userID]) { (error, data, _) in
            guard let _ = error else {
                if let dataArray = data as? Array<Any> {
                    if dataArray.count > 0 {
                        if let dataDic = dataArray[0] as? Dictionary<String, Any> {
                            if let model = ZZWxCouponModel(JSON: dataDic) {
                                block(model)
                                return
                            }
                        }
                    }
                }
                
                block(nil)
                return
            }
            block(nil)
        }
    }
    
    // 购买微信
    func buyWeChat(view: ZZPaymentView, paymentModel: ZZWeiChatEvaluationModel) {
        
        MobClick.event(Event_click_userpage_wx_buy)
        
        weak var weakSelf = self
        ZZMeBiModel.buyWeChat(paymentModel.user.uid,
                              byMcoin: String(format: "%.0f", paymentModel.mcoinForItem),
                              source: paymentModel.source == .SourceChat ? "chat" : "detail") { (error, data, task) in
                                if error != nil {
                                    ZZHUD.showError(withStatus: error?.message)
                                    return
                                }
                                
                                ZZUser.load(ZZUserHelper.shareInstance()?.loginerId, param: nil, next: { (error, userData, task) in
                                    let user = try? ZZUser.init(dictionary: userData as? [AnyHashable : Any])
                                    if let user = user {
                                        ZZUserHelper.shareInstance()?.saveLoginer(user, postNotif: false)
                                    }
                                    
                                })
                                
                                if let buyCompleteClosure = weakSelf?.buyCompleteClosure {
                                    buyCompleteClosure(true, "pay_for_wechat")
                                }
                                
                                view.dismiss()
        }
    }
    
    // 使用优惠卷购买
    func buyWechatUsingCoupon(view: ZZPaymentView, paymentModel: ZZWxCouponModel) {
        guard let payItem = payItem, let couponID = paymentModel._id, let toId = payItem.user.uid, let userId = ZZUserHelper.shareInstance()!.loginerId else {
            return
        }
        MobClick.event(Event_click_userpage_wx_buy)
        
        let params: [String : Any] = [
            "voucherId": couponID,
            "fromId": userId,
            "toId": toId,
            "channel": "查看微信",
            "action_by": "detail",
            "price": payItem.mcoinForItem
            ]

        ZZRequest.method("POST", path:"/api/wechat/voucherPaySeenWechat", params: params) { (error, data, _) in
            print("data");
            
            if error != nil {
                ZZHUD.showError(withStatus: error?.message)
                return
            }
            
            ZZUser.load(ZZUserHelper.shareInstance()?.loginerId, param: nil, next: { (error, userData, task) in
                let user = try? ZZUser.init(dictionary: userData as? [AnyHashable : Any])
                if let user = user {
                    ZZUserHelper.shareInstance()?.saveLoginer(user, postNotif: false)
                }
                
            })
            
            if let buyCompleteClosure = self.buyCompleteClosure {
                buyCompleteClosure(true, "pay_for_wechat")
            }
            
            view.dismiss()
        }
    }
    
    // 购买证件照
    func buyIDPhoto(view: ZZPaymentView, paymentModel: ZZWeiChatEvaluationModel) {
        MobClick.event(Event_click_userpage_IDPhoto_buy)
        
        weak var weakSelf = self
        ZZMeBiModel.buyIDPhoto(paymentModel.user.uid, byMcoin: String(format: "%.0f", paymentModel.mcoinForItem)) { (error, data, task) in
            if error != nil {
                ZZHUD.showError(withStatus: error?.message)
                return
            }
            
            ZZUser.load(ZZUserHelper.shareInstance()?.loginerId, param: nil, next: { (error, userData, task) in
                let user = try? ZZUser.init(dictionary: userData as? [AnyHashable : Any])
                if let user = user {
                    ZZUserHelper.shareInstance()?.saveLoginer(user, postNotif: false)
                }
            })
            
            if let buyCompleteClosure = weakSelf?.buyCompleteClosure {
                buyCompleteClosure(true, "pay_for_idphoto")
            }
            
            view.dismiss()
        }
    }
}


// MARK: - ZZIAPPayViewDelegate
extension ZZPaymentManager: ZZIAPPayViewDelegate {
    func recharge(view: ZZIAPPayView, selectedItem: ZZMeBiModel?, paymentModel: ZZWeiChatEvaluationModel) {
        MobClick.event(Event_click_MeBi_TopUp)
        
        guard selectedItem != nil else {
            return
        }
        
        let payHelper = ZZPayHelper.shared()
        payHelper?.delegate = self
        ZZHUD.show(withStatus: "正在购买中")
        
        ZZPayHelper.requestProduct(withId: selectedItem?.productId)
    }
    
    func viewDismissed(view: ZZIAPPayView) {
        SVProgressHUD.setDefaultMaskType(.none)
        buyCompleteClosure = nil
        rechargeCompleteClosure = nil
    }
}


// MARK: - ZZPaymentViewDelegate
extension ZZPaymentManager: ZZPaymentViewDelegate {
    // 购买微信或者证件照
    func buyWeChatOrIDPhoto(view: ZZPaymentView, paymentType: WechatPaymentType, paymentModel: Any?) {
        ZZHUD.show(withStatus: "支付中...")
        
        if paymentType == .mebi {
            // 使用么币购买
            if let paymentModel = paymentModel as? ZZWeiChatEvaluationModel {
                if paymentModel.type == .WX {
                    buyWeChat(view: view, paymentModel: paymentModel)
                }
                else if paymentModel.type == .idPhoto {
                    buyIDPhoto(view: view, paymentModel: paymentModel)
                }
            }
        }
        else {
            // 使用优惠卷购买
            if let couponModel = paymentModel as? ZZWxCouponModel {
                buyWechatUsingCoupon(view: view, paymentModel: couponModel)
            }
        }
    }
    
    // 充值界面消失
    func viewDismissed(view: ZZPaymentView) {
        SVProgressHUD.setDefaultMaskType(.none)
        buyCompleteClosure = nil
        rechargeCompleteClosure = nil
    }

    // 显示充值协议
    func showAgreement(view: ZZPaymentView) {
        if let vc = parentVC {
            let webViewController = ZZLinkWebViewController()
            webViewController.urlString = H5Url.rechargeAgreement
            webViewController.navigationItem.title = "充值协议";
            vc.navigationController?.pushViewController(webViewController, animated: true)
        }
    }
    
    // 内购充值
    func recharge(view: ZZPaymentView, selectedItem: ZZMeBiModel?, paymentModel: ZZWeiChatEvaluationModel) {
        
        MobClick.event(Event_click_MeBi_TopUp)
        
        guard selectedItem != nil else {
            return
        }
        
        let payHelper = ZZPayHelper.shared()
        payHelper?.delegate = self
        ZZHUD.show(withStatus: "正在购买中")
        
        ZZPayHelper.requestProduct(withId: selectedItem?.productId)
    }

    // 使用微信或者支付宝充值
    func recharge(view: ZZPaymentView, selectedItem: ZZMeBiModel?, paymentModel: ZZWeiChatEvaluationModel, selectedType: Int) {
        MobClick.event(Event_click_MeBi_TopUp)
        
        guard let selectedItem = selectedItem else {
            return
        }
        
        selectedItem.recharge(by: selectedType, model: selectedItem) { (isSuccess) in
            if isSuccess {
                DispatchQueue.main.async {
                    weak var weakSelf = self
                    // 内购成功
                    ZZHUD.show(withStatus: "充值成功")
                    weakSelf?.paymentView?.updateMebi()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        ZZHUD.dismiss()
                    })
                }
            }
        }
        
    }
}

// MARK: - ZZPayHelperDelegate
extension ZZPaymentManager: ZZPayHelperDelegate {
    // 内购失败
    func filedWithErrorCode(_ errorCode: Int, andError error: String!, transactionIdentifier: String!) {
        
        var transactionID = ""
        
        if let transactionIdentifier = transactionIdentifier {
            transactionID = transactionIdentifier
        }
        
        var transError = ""
        if let error = error {
            transError = error
        }
        
        let params: [String : Any] = ["errorCodeType": errorCode,
                      "errorCodeString": transError,
                      "transactionIdentifier": transactionID]
        
        ZZPayManager.upload(toServerData: params)
        ZZHUD.dismiss()
        parentVC?.showOKAlert(
            withTitle: "温馨提示",
            message: transError,
            okTitle: "确定",
            okBlock: nil
        )
    }
    
    // 内购成功
    func paySuccessWithtransactionInfo(_ infoDic: [AnyHashable : Any]!) {
        DispatchQueue.main.async {
            weak var weakSelf = self
            if let info = infoDic {
                if let error = info["error"] as? [String : Any] {
                    // 内购失败
                    let errorMessage = error["message"] as! String
                    ZZHUD.show(withStatus: errorMessage)
                    
                    if weakSelf?.payItem?.type == .gift {
                        // 如果是礼物充值直接过
                        weakSelf?.rechargeCompleteClosure?(false)
//                        weakSelf?.paymentView?.dismiss()
                        weakSelf?.payView?.dismiss()
                    }
                }
                else {
                    // 内购成功
                    ZZHUD.show(withStatus: "充值成功")
                    
                    if weakSelf?.payItem?.type == .gift {
                        // 如果是礼物充值直接过
                        weakSelf?.rechargeCompleteClosure?(true)
//                        weakSelf?.paymentView?.dismiss()
                        weakSelf?.payView?.dismiss()
                    }
                    else if weakSelf?.payItem?.type == .ktvGift {
                        let currentMcoin: Double = Double(truncating: ZZUserHelper.shareInstance()?.loginer.mcoin ?? 0.0)
                        let needTopay: Double = weakSelf?.payItem?.mcoinForItem ?? 0.0
                        if needTopay > currentMcoin {
                            // 如果还是不够
                            weakSelf?.payView?.updateMebi()
                        }
                        else {
                            // 如果是礼物充值直接过
                            weakSelf?.rechargeCompleteClosure?(true)
                            weakSelf?.payView?.dismiss()
                        }
                        
                    }
                    else {
                        weakSelf?.paymentView?.updateMebi()
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                ZZHUD.dismiss()
            })
        }
    }
}
