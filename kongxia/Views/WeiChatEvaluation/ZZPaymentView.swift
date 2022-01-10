//
//  ZZPaymentView.swift
//  zuwome
//
//  Created by qiming xiao on 2019/2/26.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

enum WechatPaymentType {
    case mebi
    case coupon
    case recharge
    case none
}

protocol ZZPaymentViewDelegate: NSObjectProtocol {
    func showAgreement(view: ZZPaymentView)
    func buyWeChatOrIDPhoto(view: ZZPaymentView, paymentType: WechatPaymentType, paymentModel: Any?)
    
    // 使用内购充值
    func recharge(view: ZZPaymentView, selectedItem: ZZMeBiModel?, paymentModel: ZZWeiChatEvaluationModel)
    
    // 使用微信或者支付宝充值
    func recharge(view: ZZPaymentView, selectedItem: ZZMeBiModel?, paymentModel: ZZWeiChatEvaluationModel, selectedType: Int)
    func viewDismissed(view: ZZPaymentView)
}

class ZZPaymentView: UIView {
    weak var delegate: ZZPaymentViewDelegate?
    var paymentModel: ZZWeiChatEvaluationModel
    var iapList: [ZZMeBiModel]? = []
    var coupon: ZZWxCouponModel? = nil
    var currentSelectPayment: WechatPaymentType = .none
    var currentChoosedMebiModel: ZZMeBiModel?
    var currentSelectRechargeType:Int = 1
    
    var frameHeight: CGFloat = 0
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var infoView: ZZPaymentInfoView = {
        let infoView = ZZPaymentInfoView(paymentModel: paymentModel, iapList: iapList, coupon: coupon)
        infoView.delegate = self
        infoView.closeBtn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        infoView.buyBtn.addTarget(self, action: #selector(proceedAction), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectMebi))
        infoView.balanceView.addGestureRecognizer(tapGesture)
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(selectCoupon))
        infoView.couponView.addGestureRecognizer(tapGesture1)
        return infoView
    }()
    
    static func show(paymentModel: ZZWeiChatEvaluationModel,
                     iapList: [ZZMeBiModel]?,
                     coupon: ZZWxCouponModel?) -> ZZPaymentView {
        let infoView = ZZPaymentView(paymentModel: paymentModel, iapList: iapList, coupon: coupon)
        infoView.paymentModel = paymentModel

        UIApplication.shared.keyWindow?.addSubview(infoView)
        infoView.mas_makeConstraints { (make) in
            make?.edges.equalTo()(UIApplication.shared.keyWindow)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            infoView.frameHeight = infoView.infoView.frame.size.height
            infoView.show()
        }
        
        return infoView
    }
    
    init(paymentModel: ZZWeiChatEvaluationModel, iapList: [ZZMeBiModel]?, coupon:ZZWxCouponModel?) {
        self.paymentModel = paymentModel
        self.iapList = iapList
        self.coupon = coupon
        super.init(frame: CGRect.zero)
        layout()
        defaultSelected()
    }
    
    deinit {
        print("ZZPaymentView is Deinit")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 内购成功之后，更新UI、直接购买操作
    func updateMebi() {
        if let userHelper = ZZUserHelper.shareInstance() {
            infoView.balanceView.balanceLabel.text = "么币余额: \(userHelper.loginer.mcoin ?? 0)"
            infoView.isRecharge = userHelper.loginer.mcoin.doubleValue < paymentModel.mcoinForItem
        
            infoView.isMebiEnough()
            infoView.remakeLayout()
            
            // 如果充值之后，么币余额大于等于购买项目的价格，则直接购买
            if !infoView.isRecharge {
                currentSelectPayment = .mebi
                proceedAction()
            }
        }
    }
    
    // 隐藏
    @objc func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bgView.alpha = 0.0
            self.infoView.mas_updateConstraints({ (make) in
                make?.bottom.equalTo()(self)?.offset()(self.frameHeight)
            })
            self.layoutIfNeeded()
        }, completion: { (isComplete) in
            self.delegate?.viewDismissed(view: self)
            self.bgView.removeFromSuperview()
            self.infoView.removeFromSuperview()
            self.removeFromSuperview()
        })
    }
    
    // 显示
    @objc func show() {
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 0.5
            self.infoView.mas_updateConstraints({ (make) in
                make?.bottom.equalTo()(self)
            })
            self.layoutIfNeeded()
        }
    }
    
    // 购买/充值
    @objc func proceedAction() {
        guard currentSelectPayment != .none else {
            return
        }

        if currentSelectPayment == .recharge {
            delegate?.recharge(view: self, selectedItem: currentChoosedMebiModel, paymentModel: paymentModel)
//            delegate?.recharge(view: self, selectedItem: currentChoosedMebiModel, paymentModel: paymentModel, selectedType: currentSelectRechargeType)
        }
        else {
            let payment: Any? = currentSelectPayment == .mebi ? (paymentModel ) : (coupon ?? nil)
            delegate?.buyWeChatOrIDPhoto(view: self, paymentType: currentSelectPayment, paymentModel: payment)
        }
    }
    
    // 选择优惠卷购买
    @objc func selectCoupon() {
        
        if infoView.couponView.checkedBtn.isSelected {
            infoView.couponView.checkedBtn.isSelected = false
            currentSelectPayment = .none
        }
        else {
            currentChoosedMebiModel = nil
            infoView.couponView.checkedBtn.isSelected = true
            infoView.balanceView.mebiEnoughBtn.isSelected = false
            currentSelectPayment = .coupon
            infoView.iapView.choosedView(index: -1)
        }
    }
    
    // 选择么币购买
    @objc func selectMebi() {
        if infoView.balanceView.mebiEnoughBtn.isSelected {
            infoView.couponView.checkedBtn.isSelected = false
            currentSelectPayment = .none
        }
        else {
            currentChoosedMebiModel = nil
            infoView.couponView.checkedBtn.isSelected = false
            infoView.balanceView.mebiEnoughBtn.isSelected = true
            currentSelectPayment = .mebi
        }
    }
    
    // 默认选择么币
    func defaultSelected() {
        if infoView.isRecharge {
            infoView.iapView.choosedView(index: 0)
        }
        else {
            selectMebi()
        }
    }
}

// MARK: ZZPaymentInfoViewDelegate
extension ZZPaymentView: ZZPaymentInfoViewDelegate {
    func choosePayType(type: Int) {
        currentSelectRechargeType = type
    }
    
    func showAgreement() {
        dismiss()
        delegate?.showAgreement(view: self)
    }
    
    func chooseIAP(iap: ZZMeBiModel?) {
        if let iap = iap {
            currentSelectPayment = .recharge
            currentChoosedMebiModel = iap
            infoView.couponView.checkedBtn.isSelected = false
            infoView.balanceView.mebiEnoughBtn.isSelected = false
        }
    }
}

// MARK: Layout
extension ZZPaymentView {
    func layout() {
        self.addSubview(self.bgView)
        self.addSubview(self.infoView)
        
        bgView.mas_makeConstraints { (make) in
            make?.edges.equalTo()(self)
        }
        
        var offsetX: CGFloat = 690.0
        if infoView.isRecharge && infoView.coupon != nil {
            offsetX = 720.0
        }
        else {
            offsetX = 470.0
        }
        infoView.mas_makeConstraints { (make) in
            make?.bottom.equalTo()(self)?.offset()(offsetX)
            make?.left.equalTo()(self)
            make?.right.equalTo()(self)
        }
    }
}

// MARK: - 购买信息页面
protocol ZZPaymentInfoViewDelegate: NSObjectProtocol {
    func showAgreement()
    func chooseIAP(iap: ZZMeBiModel?)
    func choosePayType(type: Int)
}

class ZZPaymentInfoView: UIView {
    weak var delegate: ZZPaymentInfoViewDelegate?
    var paymentModel: ZZWeiChatEvaluationModel
    var iapList: [ZZMeBiModel]? = []
    var iapListViewArray: [UIView] = []
    var coupon: ZZWxCouponModel? = nil
    
    var isRecharge: Bool = false
    var didHaveComments: Bool = false
    var currentChoosedMebiModel: ZZMeBiModel? = nil
    var currentSelectRechargeType:Int = 1
    lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "icChatEvaluatePopClosed"), for: .normal)
        return btn
    }()
    
    lazy var topCommentsView: ZZPaymentInfoTopView = {
        let view = ZZPaymentInfoTopView(goodNumber: paymentModel.user.wechat.good_comment_count, badNumber: paymentModel.user.wechat.bad_comment_count)
        return view
    }()
    
    lazy var itemNameLabel: UILabel = {
        let label = UILabel(text: paymentModel.type == .WX ? "查看微信" : "查看证件照",
                            font: UIFont.boldSystemFont(ofSize: 20.0),
                            textColor: UIColor.rgbColor(63, 58, 58))
        label.textAlignment = .left
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "\(String(format: "%0.f", paymentModel.mcoinForItem))么币"
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = UIColor.rgbColor(63, 58, 58)
        label.textAlignment = .right
        return label
    }()
    
    lazy var balanceView: ZZPaymentInfoBalanceView = {
        let view = ZZPaymentInfoBalanceView()
        view.balanceLabel.text = "么币余额: \(ZZUserHelper.shareInstance()?.loginer.mcoin ?? 0)"
        return view
    }()
    
    lazy var iapView: ZZIAPView = {
        let view = ZZIAPView(iapList: self.iapList)
        view.delegate = self
        return view
    }()
    
    lazy var wechatBtn: UIButton = {
        let btn = UIButton()
        btn.normalImage = UIImage(named: "icon_rent_pay_wx_n")
        btn.selectedImage = UIImage(named: "icon_rent_pay_wx_p")
        btn.tag = 1
        btn.addTarget(self, action: #selector(didSelectPayment), for: .touchUpInside)
        btn.isSelected = currentSelectRechargeType == 1
        return btn
    }()
    
    lazy var aliPayBtn: UIButton = {
        let btn = UIButton()
        btn.normalImage = UIImage(named: "icon_rent_pay_zfb_n")
        btn.selectedImage = UIImage(named: "icon_rent_pay_zfb_p")
        btn.tag = 2
        btn.addTarget(self, action: #selector(didSelectPayment), for: .touchUpInside)
        btn.isSelected = currentSelectRechargeType == 2
        return btn
    }()
    
    lazy var paymentLabel: UILabel = {
        let label = UILabel()
        label.font = font(12)
        label.textColor = UIColor.hexColor("#ababab")
        label.textAlignment = .center
        label.text = "还未选取支付方式";
        if currentSelectRechargeType == 1 {
            label.text = "使用微信支付";
            label.textColor = UIColor.hexColor("#72c448");
        }
        else if currentSelectRechargeType == 2 {
            label.text = "使用支付宝支付";
            label.textColor =  UIColor.hexColor("#51b6ec");
        }
        return label
    }()
    
    lazy var agreementTitleLbael: UITextView = {
        let label = UITextView()
        
        let str = "付费即代表已阅读并同意《充值协议》"
        var mutablAttributeStr = NSMutableAttributedString(string:str)
        mutablAttributeStr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.rbg(red: 173, green: 173, blue: 177)], range: NSRange(location: 0, length: str.count))
        
        mutablAttributeStr.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)], range: NSRange(location: 0, length: str.count))
        
        if let selectedRange = str.range(of: "《充值协议》") {
            mutablAttributeStr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.rbg(red: 74, green: 144, blue: 226)], range: NSRange(selectedRange, in: str))
            mutablAttributeStr.addAttributes([NSAttributedString.Key.link: "protocol://"], range: NSRange(selectedRange, in: str))
        }
        
        label.attributedText = mutablAttributeStr
        label.textAlignment = .center
        label.isEditable = false
        label.isScrollEnabled = false
        label.delegate = self
        return label
    }()
    
    lazy var buyBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.rbg(red: 243, green: 202, blue: 47)
        btn.layer.cornerRadius = 2.5
        
        var title = "购买"
        if isRecharge {
            if coupon != nil {
                title = "购买"
            }
            else {
                title = "确认充值并购买"
            }
        }
        else {
            title = "购买"
        }
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        return btn
    }()
    
    lazy var descripLabel: UITextView = {
        let label = UITextView()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = UIColor.rbg(red: 63, green: 58, blue: 58)
        label.isEditable = false
        label.isScrollEnabled = false
        label.delegate = self
        label.textAlignment = .center
        
        if paymentModel.userIphoneNumber != nil {
            let str = "充值问题，请咨询空虾官方微信公众号：zwmapp 复制"
            var mutablAttributeStr = NSMutableAttributedString(string:str)
            mutablAttributeStr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.rbg(red: 63, green: 58, blue: 58)], range: NSRange(location: 0, length: str.count))
            
            mutablAttributeStr.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)], range: NSRange(location: 0, length: str.count))
            mutablAttributeStr.addAttributes([NSAttributedString.Key.verticalGlyphForm: 0], range: NSRange(location: 0, length: str.count))
            
            if let selectedRange = str.range(of: "复制") {
                mutablAttributeStr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.rbg(red: 74, green: 144, blue: 226)], range: NSRange(selectedRange, in: str))
                mutablAttributeStr.addAttributes([NSAttributedString.Key.link: "paste://"], range: NSRange(selectedRange, in: str))
            }
            label.attributedText = mutablAttributeStr
        }
        return label
    }()
    
    lazy var couponView: ZZCouponView = {
        let view = ZZCouponView()
        return view
    }()
    
    init(paymentModel: ZZWeiChatEvaluationModel, iapList: [ZZMeBiModel]?, coupon:ZZWxCouponModel?) {
        self.paymentModel = paymentModel
        self.iapList = iapList
        self.coupon = coupon
        
        if let userHelper = ZZUserHelper.shareInstance() {
            self.isRecharge = userHelper.loginer.mcoin.doubleValue < paymentModel.mcoinForItem
        }
        
        super.init(frame: CGRect.zero)
        
        self.didHaveComments = false
        if paymentModel.type == .WX {
            var good = 0
            var bad = 0
            if self.paymentModel.user.wechat != nil {
                good = self.paymentModel.user.wechat.good_comment_count
                bad = self.paymentModel.user.wechat.bad_comment_count
            }
        
            if good > 0 || bad > 0 {
                self.didHaveComments = true
            }
        }
        
        baseLayout()
        layout()
        isMebiEnough()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isMebiEnough() {
        if isRecharge {
            balanceView.subTitleLabel.isHidden = false
            balanceView.mebiEnoughBtn.isHidden = true
        }
        else {
            balanceView.subTitleLabel.isHidden = true
            balanceView.mebiEnoughBtn.isHidden = false
        }
        
        var title = "购买"
        if isRecharge {
            if coupon != nil {
                title = "购买"
            }
            else {
                title = "确认充值并购买"
            }
        }
        else {
            title = "购买"
        }
        buyBtn.setTitle(title, for: .normal)
    }
    
    @objc func didSelectPayment(sender: UIButton) {
        currentSelectRechargeType = sender.tag;
        wechatBtn.isSelected = currentSelectRechargeType == 1
        aliPayBtn.isSelected = currentSelectRechargeType == 2
        if currentSelectRechargeType == 1 {
            paymentLabel.text = "使用微信支付";
            paymentLabel.textColor = UIColor.hexColor("#72c448");
        }
        else if currentSelectRechargeType == 2 {
            paymentLabel.text = "使用支付宝支付";
            paymentLabel.textColor =  UIColor.hexColor("#51b6ec");
        }
        
        delegate?.choosePayType(type: currentSelectRechargeType)
    }
}

extension ZZPaymentInfoView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.absoluteString == "protocol://" {
            print("show protocol")
            delegate?.showAgreement()
        }
        else if URL.absoluteString == "paste://" {
            let pasteBoard = UIPasteboard.general
            pasteBoard.string = "zwmapp"
            ZZHUD.showTastInfo(with: "复制成功，前往微信添加")
        }
        else if URL.absoluteString == "changeMobile://" {
            print("change phone number")
            
        }
        return false
    }
}

extension ZZPaymentInfoView: ZZIAPViewDelegate {
    func choosedIAP(iap: ZZMeBiModel?) {
        delegate?.chooseIAP(iap: iap)
    }
}


// MARK: Layout
extension ZZPaymentInfoView {
    func baseLayout() {
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
        self.backgroundColor = .white
    }
    
    func remakeLayout() {
        iapView.removeFromSuperview()
        agreementTitleLbael.removeFromSuperview()
    
        buyBtn.mas_updateConstraints { (make) in
            if coupon != nil {
                make?.top.equalTo()(couponView.mas_bottom)?.offset()(21)
            }
            else {
                make?.top.equalTo()(balanceView.mas_bottom)?.offset()(21)
            }
        }
    }
    
    func layout() {
        
        if didHaveComments {
            self.addSubview(self.topCommentsView)
            topCommentsView.mas_makeConstraints { (make) in
                make?.left.equalTo()(self)
                make?.top.equalTo()(self)
                make?.right.equalTo()(self)
            }
        }
        
        self.addSubview(self.itemNameLabel)
        itemNameLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(15.0)
            if didHaveComments {
                make?.top.equalTo()(topCommentsView.mas_bottom)?.offset()(31.0)
            }
            else {
                make?.top.equalTo()(self)?.offset()(50.0)
            }

        }
        
        self.addSubview(self.titleLabel)
        titleLabel.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(itemNameLabel)
            make?.right.equalTo()(self)?.offset()(-15)
        }
        
        self.addSubview(self.balanceView)
        balanceView.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(self)
            make?.top.equalTo()(itemNameLabel.mas_bottom)?.offset()(34.0)
            make?.left.equalTo()(self)?.offset()(15)
            make?.right.equalTo()(self)?.offset()(-15)
        }
        var bottomView: UIView = balanceView
        
        if isRecharge {
            self.addSubview(self.iapView)
            iapView.mas_makeConstraints { (make) in
                make?.left.equalTo()(self)?.offset()(17)
                make?.right.equalTo()(self)?.offset()(-17)
                make?.top.equalTo()(balanceView.mas_bottom)?.offset()(22.0)
            }
            
//            let btnWidth = (screenWidth - 30) / 2
//
//            self.addSubview(wechatBtn)
//            wechatBtn.mas_makeConstraints { (make) in
//                make?.left.equalTo()(self)?.offset()(17)
//                make?.top.equalTo()(iapView.mas_bottom)
//                make?.size.mas_equalTo()(CGSize(width: btnWidth, height: 50));
//            }
//
//            self.addSubview(aliPayBtn)
//            aliPayBtn.mas_makeConstraints { (make) in
//                make?.left.equalTo()(wechatBtn.mas_right);
//                make?.centerY.equalTo()(wechatBtn);
//                make?.size.mas_equalTo()(CGSize(width: btnWidth, height: 50));
//            }
//
//            self.addSubview(paymentLabel)
//            paymentLabel.mas_makeConstraints { (make) in
//                make?.left.equalTo()(self)?.offset()(17);
//                make?.right.equalTo()(self)?.offset()(-17);
//                make?.top.equalTo()(aliPayBtn.mas_bottom);
//            }
//
//            self.addSubview(self.agreementTitleLbael)
//            agreementTitleLbael.mas_makeConstraints { (make) in
//                make?.centerX.equalTo()(self)
//                make?.left.equalTo()(self)?.offset()(50)
//                make?.right.equalTo()(self)?.offset()(-50)
//                make?.top.equalTo()(paymentLabel.mas_bottom)?.offset()(10)
//            }
            bottomView = iapView
        }
        
        if coupon != nil {
            self.addSubview(couponView)
            couponView.mas_makeConstraints { (make) in
                make?.left.equalTo()(self)?.offset()(15)
                make?.right.equalTo()(self)?.offset()(-15)
                make?.top.equalTo()(bottomView.mas_bottom)?.offset()(20.0)
            }
            bottomView = couponView
        }
        
        self.addSubview(self.buyBtn)
        buyBtn.mas_makeConstraints { (make) in
            make?.top.equalTo()(bottomView.mas_bottom)?.offset()(isRecharge ? 5.5 : 21)
            make?.left.equalTo()(self)?.offset()(15)
            make?.right.equalTo()(self)?.offset()(-15)
            make?.height.equalTo()(50)
            if #available(iOS 11.0, *) {
                make?.bottom.equalTo()(self.mas_safeAreaLayoutGuideBottom)?.offset()(-22.5)
            } else {
                // Fallback on earlier versions
                make?.bottom.equalTo()(self)?.offset()(-22.5)
            }

        }
    
        self.addSubview(self.closeBtn)
        closeBtn.mas_makeConstraints { (make) in
            make?.top.equalTo()(self)
            make?.right.equalTo()(self)
            make?.size.mas_equalTo()(CGSize(width: 49.0, height: 49.0))
        }
    }
}

// MARK: - 头部评价View
class ZZPaymentInfoTopView: UIView {
    let goodNumber: Int
    let badNumber: Int
    lazy var goodView: ZZPaymentInfoTopEvaluatView = {
        let view = ZZPaymentInfoTopEvaluatView()
        view.titleLabel.text = "\(goodNumber)好评"
        return view
    }()
    
    lazy var badView: ZZPaymentInfoTopEvaluatView = {
        let view = ZZPaymentInfoTopEvaluatView()
        view.titleLabel.text = "\(badNumber)差评"
        view.iconImageView.image = UIImage(named: "icEvaluatWeixinCopy")
        return view
    }()
    
    init(goodNumber: Int, badNumber: Int) {
        self.goodNumber = goodNumber
        self.badNumber = badNumber
        super.init(frame: CGRect.zero)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Layout
extension ZZPaymentInfoTopView {
    func layout() {
        self.addSubview(goodView)
        self.addSubview(badView)
        goodView.isHidden = true
        badView.isHidden = true
        
        if badNumber != 0 && goodNumber != 0 {
            goodView.isHidden = false
            badView.isHidden = false
            goodView.mas_makeConstraints { (make) in
                make?.right.equalTo()(self.mas_centerX)?.offset()(-15)
                make?.top.equalTo()(self)?.offset()(40.0)
                make?.bottom.equalTo()(self)
            }
            badView.mas_makeConstraints { (make) in
                make?.centerY.equalTo()(goodView)
                make?.left.equalTo()(self.mas_centerX)?.offset()(15)
            }
        }
        else if badNumber == 0 && goodNumber != 0 {
            goodView.isHidden = false
            goodView.mas_makeConstraints { (make) in
                make?.centerX.equalTo()(self)
                make?.top.equalTo()(self)?.offset()(40.0)
                make?.bottom.equalTo()(self)
            }
        }
        else if badNumber != 0 && goodNumber == 0 {
            badView.isHidden = false
            badView.mas_makeConstraints { (make) in
                make?.centerX.equalTo()(self)
                make?.top.equalTo()(self)?.offset()(40.0)
                make?.bottom.equalTo()(self)
            }
        }
    }
}

// MARK: - 头部评价好评差评View
class ZZPaymentInfoTopEvaluatView: UIView {
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icEvaluatWeixin")
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(text: "1好评",
                            font: sysFont(17.0),
                            textColor: .black)
        
        return label
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Layout
extension ZZPaymentInfoTopEvaluatView {
    func layout() {
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        
        iconImageView.mas_makeConstraints { (make) in
            make?.top.equalTo()(self)
            make?.left.equalTo()(self)
            make?.bottom.equalTo()(self)
            make?.size.mas_equalTo()(CGSize(width: 46.0, height: 46.0))
        }
        
        titleLabel.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(iconImageView)
            make?.right.equalTo()(self)
            make?.left.equalTo()(iconImageView.mas_right)?.offset()(4)
        }
    }
}

// MARK: - 账户信息View
class ZZPaymentInfoBalanceView: UIView {
    lazy var iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "icMebi")
        return imageView
    }()
    
    lazy var mebiEnoughBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "oval75"), for: .normal)
        btn.setImage(UIImage(named: "iconSelected"), for: .selected)
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "么币余额：56"
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.textColor = UIColor.rbg(red: 63, green: 58, blue: 58)
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel(text: "余额不足，请充值", font: UIFont.systemFont(ofSize: 15.0), textColor: UIColor.rgbColor(173, 173, 177))
        return label
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Layout
extension ZZPaymentInfoBalanceView {
    func layout() {
        self.addSubview(self.iconImage)
        self.addSubview(self.balanceLabel)
        self.addSubview(self.subTitleLabel)
        self.addSubview(self.mebiEnoughBtn)
        
        iconImage.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)
            make?.top.equalTo()(self)
            make?.size.mas_equalTo()(CGSize(width: 25.0, height: 25.0))
            make?.bottom.equalTo()(self)
        }
        
        subTitleLabel.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(iconImage)
            make?.right.equalTo()(self)
        }
        
        balanceLabel.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(iconImage)
            make?.left.equalTo()(iconImage.mas_right)?.offset()(8.0)
        }
        
        mebiEnoughBtn.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(iconImage)
            make?.right.equalTo()(self)
            make?.size.mas_equalTo()(CGSize(width: 18.0, height: 18.0))
        }
    }
}

// MARK:- 内购选项view
protocol ZZIAPViewDelegate: NSObjectProtocol {
    func choosedIAP(iap: ZZMeBiModel?)
}

class ZZIAPView: UIView {
    var iapList: [ZZMeBiModel]? = []
    var iapListViewArray: [ZZIAPDetailView] = []
    weak var delegate: ZZIAPViewDelegate?
    
    init(iapList: [ZZMeBiModel]?) {
        self.iapList = iapList
        super.init(frame: CGRect.zero)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func choose(tap: UITapGestureRecognizer) {
        guard let index = tap.view?.tag else {
            return
        }
        choosedView(index: index)
    }
    
    func choosedView(index: Int) {
        iapListViewArray.forEach { (view) in
            view.setBorder(show: view.tag == index)
        }
        if index >= 0 {
            delegate?.choosedIAP(iap: iapList?[index])
        }
        else {
            delegate?.choosedIAP(iap: nil)
        }
    }
}

// MARK: Layout
extension ZZIAPView {
    func layout() {
        if let iapList = iapList {
            if iapList.count != 0 {
                let viewsOffsetWidth: CGFloat = 7.3
                let viewsOffsetHeight: CGFloat = 7.0
                let offset: CGFloat = 17.0
                let viewWidth: CGFloat = (screenWidth - viewsOffsetWidth * 2 - offset * 2) / 3
                let viewHeight: CGFloat = 64.5
                
                for (index, mebiModel) in iapList.enumerated() {
                    let view = ZZIAPDetailView()
                    self.addSubview(view)
                    view.mas_makeConstraints({ (make) in
                        let left = (viewWidth + viewsOffsetWidth) * CGFloat(index % 3)
                        let top = (viewHeight + viewsOffsetHeight) * CGFloat(index / 3)
                        make?.left.equalTo()(self)?.offset()(left)
                        make?.top.equalTo()(self)?.offset()(top)
                        make?.size.mas_equalTo()(CGSize(width: viewWidth, height: viewHeight))
                        
                        if index == iapList.count - 1 {
                            make?.bottom.mas_equalTo()(self)
                        }
                    })
                    iapListViewArray.append(view)
                    
                    view.titleLabel.text = "\(mebiModel.meBi ?? "0")么币"
                    view.subTitleLabel.text = "\(mebiModel.meBiPrice ?? "0")元"
                    view.tag = index
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(choose(tap:)))
                    view.addGestureRecognizer(tap)
                }
            }
        }
    }
}

// MARK: - 内购选项信息view
class ZZIAPDetailView: UIView {

    lazy var titleLabel: UILabel = {
        let label = UILabel(text: nil,
                            font: UIFont(name: "PingFang-SC-Medium", size: 17.0) ?? UIFont.systemFont(ofSize: 17.0),
                            textColor: .black)
        label.textAlignment = .center
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel(text: nil,
                            font: UIFont.systemFont(ofSize: 15.0),
                            textColor: UIColor.rgbColor(63, 58, 58))
        label.textAlignment = .center
        return label
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        layout()
        setBorder(show: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBorder(show: Bool) {
        if (show) {
            self.backgroundColor = UIColor.rgbColor(240, 203, 7)//RGBCOLOR(240, 203, 7);
            self.layer.borderColor = UIColor.rgbColor(37, 39, 43).cgColor
            self.layer.borderWidth = 0;
        }
        else{
            self.backgroundColor = .white//RGBCOLOR(240, 203, 7);
            self.layer.borderColor = UIColor.rgbColor(37, 39, 43).cgColor
            self.layer.borderWidth = 0.5;
        }
    }
}

// MARK: Layout
extension ZZIAPDetailView {
    func layout() {
        self.layer.cornerRadius = 3
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.subTitleLabel)
        
        titleLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)
            make?.right.equalTo()(self)
            make?.top.equalTo()(self)?.offset()(7.5)
        }
        
        subTitleLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)
            make?.right.equalTo()(self)
            make?.bottom.equalTo()(self)?.offset()(-6.5)
        }
    }
}

// MARK: - 抵用卷
class ZZCouponView: UIView {
    lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgbColor(237, 237, 237)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(text: "抵用券x1", font: sysFont(15.0), textColor: .zzBlack)
        
        return label
    }()
    
    lazy var checkedBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "oval75"), for: .normal)
        btn.setImage(UIImage(named: "iconSelected"), for: .selected)
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    
    init() {
        super.init(frame: CGRect.zero)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Layout
extension ZZCouponView {
    func layout() {
        self.addSubview(line)
        self.addSubview(titleLabel)
        self.addSubview(checkedBtn)
    
        line.mas_makeConstraints { (make) in
            make?.top.equalTo()(self)
            make?.left.equalTo()(self)
            make?.right.equalTo()(self)
            make?.height.equalTo()(0.5)
        }
        
        titleLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)
            make?.top.equalTo()(self)?.offset()(17.0)
            make?.bottom.equalTo()(self)?.offset()(-17.0)
        }
        
        checkedBtn.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(titleLabel)
            make?.right.equalTo()(self)
            make?.size.mas_equalTo()(CGSize(width: 18.0, height: 18.0))
        }
    }
}

