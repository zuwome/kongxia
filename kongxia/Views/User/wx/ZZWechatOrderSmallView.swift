//
//  ZZWechatOrderSmallView.swift
//  zuwome
//
//  Created by qiming xiao on 2019/3/6.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

@objc protocol ZZWechatOrderSmallViewDelegate: NSObjectProtocol {
    @objc func showDetails(orderID: String?)
}

class ZZWechatOrderSmallView: UIView {
    @objc weak var delegate: ZZWechatOrderSmallViewDelegate?
    var orderModel: ZZWXOrderModel?
    var frameHeight: CGFloat = 0
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var infoView: ZZWechatOrderSmallInfoView = {
        let infoView = ZZWechatOrderSmallInfoView()
        infoView.closeBtn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        infoView.pasteBtn.addTarget(self, action: #selector(pasteWX), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showDetails))
        infoView.cardView.addGestureRecognizer(tap)
        return infoView
    }()
    
    @objc class func show(data: Any) -> ZZWechatOrderSmallView {
        var orderModel: ZZWXOrderModel? = nil
        if let dataDic = data as? Dictionary<String, Any> {
            if let model = ZZWXOrderModel(JSON: dataDic) {
                orderModel = model;
            }
        }
        let infoView = ZZWechatOrderSmallView(orderModel: orderModel)
        UIApplication.shared.keyWindow?.addSubview(infoView)
        infoView.mas_makeConstraints { (make) in
            make?.edges.equalTo()(UIApplication.shared.keyWindow)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            infoView.frameHeight =  infoView.infoView.frame.size.height
            infoView.show()
        }
        
        return infoView
    }
    
    init(orderModel: ZZWXOrderModel?) {
        self.orderModel = orderModel;
        super.init(frame: .zero)
        layout()
        configureData()
    }
    
    deinit {
        print("ZZWechatOrderSmallView is Deinit")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    // 复制微信
    @objc func pasteWX() {
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = "zwmapp"
        ZZHUD.showTastInfo(with: "复制成功")
    }
    
    @objc func showDetails() {
        dismiss()
        delegate?.showDetails(orderID: orderModel?._doc?._id)
    }
    
    func configureData() {
        guard let order = orderModel else {
            return
        }
        
        if !order.isBuy {
            return
        }
        
        var highLightText: String? = nil
        if let highlightDic = order.from_msg {
            let array = highlightDic["highlight_text"]
            if let array = array as? Array<Any> {
                if array.count > 0 {
                    if let highlight_text = array[0] as? String {
                        highLightText = highlight_text
                    }
                }
            }
        }
        order.setStatus(isBuy: true)
        var iconStr = ""
        if order.orderStatus == .buyer_bought
            || order.orderStatus == .seller_bought {
            iconStr = "icDtjWxdd"
        }
        else if order.orderStatus == .buyer_confirm
            || order.orderStatus == .seller_confirm
            || order.orderStatus == .seller_waitToBeEvaluated {
            iconStr = "icDqrWxdd"
        }
        else if order.orderStatus == .buyer_reporting
            || order.orderStatus == .seller_beingReported {
            iconStr = "icJubaoWxhdd"
        }
        else if order.orderStatus == .buyer_commented
            || order.orderStatus == .seller_complete
            || order.orderStatus == .buyer_reportSuccess
            || order.orderStatus == .buyer_reportFail
            || order.orderStatus == .seller_reportSuccess
            || order.orderStatus == .seller_reportFail {
            iconStr = "icYwcWxdd"
        }
        
        let title = order.from_msg?["title"] as? String
    
        infoView.cardView.iconImageView.image = UIImage(named: iconStr)
        infoView.cardView.titleLabel.text = title
        infoView.cardView.descriptLabel.text = order.from_msg?["content"] as? String
        
        if let highLightStr = highLightText, let title = title {
            if let range = title.range(of: highLightStr) {
                let nsrange = NSRange(range, in: title)
                let attriStr = NSMutableAttributedString(string: title)
                
                attriStr.addAttributes([.font: UIFont(name: "PingFang-SC-Regular", size: 14.0)!, .foregroundColor: rgbColor(153,153,153)], range: NSRange(location: 0, length: title.count))
                
                attriStr.addAttributes([.font: UIFont(name: "PingFang-SC-Medium", size: 14.0)!, .foregroundColor: rgbColor(102, 102, 102)], range: nsrange)
                
                infoView.cardView.descriptLabel.attributedText = attriStr
            }
        }
        infoView.wxLabel.text = "Ta的微信号: \(orderModel?._doc?.wechat_no ?? "")"
    }
}

// MARK: Layout
extension ZZWechatOrderSmallView {
    func layout() {
        self.addSubview(self.bgView)
        self.addSubview(self.infoView)
        
        self.bgView.mas_makeConstraints { (make) in
            make?.edges.equalTo()(self)
        }
        
        self.infoView.mas_makeConstraints { (make) in
            make?.bottom.equalTo()(self)?.offset()(320)
            make?.left.equalTo()(self)
            make?.right.equalTo()(self)
        }
    }
}

// MARK: - ZZWechatOrderSmallInfoView
class ZZWechatOrderSmallInfoView: UIView {
    lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "icChatEvaluatePopClosed"), for: .normal)
        return btn
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(text: "微信号订单", font: sysFont(19.0), textColor: zzGoldenColor)
        label.textAlignment = .center
        return label
    }()
    
    lazy var cardView: ZZWechatOrderSmallInfoCardView = {
        let view = ZZWechatOrderSmallInfoCardView()
        
        return view
    }()
    
    lazy var wxLabel: UILabel = {
        let label = UILabel(text: "Ta的微信号：1233029ei", font: sysFont(15.0), textColor: zzBlackColor)
        
        return label
    }()
    
    lazy var pasteBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("复制", for: .normal)
        btn.setTitleColor(rgbColor(102, 102, 102), for: .normal)
        btn.titleLabel?.font = sysFont(14.0)
        btn.layer.borderColor = rgbColor(102, 102, 102).cgColor
        btn.layer.borderWidth = 1.0
        btn.layer.cornerRadius = 14
        return btn
    }()
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Layout
extension ZZWechatOrderSmallInfoView {
    func layout() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 8.0
        
        self.addSubview(closeBtn)
        self.addSubview(titleLabel)
        self.addSubview(cardView)
        self.addSubview(wxLabel)
        self.addSubview(pasteBtn)
        
        closeBtn.mas_makeConstraints { (make) in
            make?.right.equalTo()(self)
            make?.top.equalTo()(self)
            make?.size.mas_equalTo()(CGSize(width: 49.0, height: 49.0))
        }
        
        titleLabel.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(self)
            make?.top.equalTo()(self)?.offset()(35.0)
        }
        
        cardView.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(self)
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(22)
            make?.left.equalTo()(self)?.offset()(18)
            make?.right.equalTo()(self)?.offset()(-18)
        }
        
        wxLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(18.0)
            make?.top.equalTo()(cardView.mas_bottom)?.offset()(28.0)
            if #available(iOS 11.0, *) {
                make?.bottom.equalTo()(self.mas_safeAreaLayoutGuideBottom)?.offset()(-(28))
            } else {
                // Fallback on earlier versions
                make?.bottom.equalTo()(self)?.offset()(-(28))
            }
        }
        
        pasteBtn.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(wxLabel)
            make?.right.equalTo()(self)?.offset()(-18)
            make?.size.mas_equalTo()(CGSize(width: 55, height: 28))
        }
    }
}

// MARK: - ZZWechatOrderSmallInfoCardView
class ZZWechatOrderSmallInfoCardView: UIView {
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(text: "待添加", font: boldFont(17.0), textColor: zzBlackColor)
        
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel(text: "详情", font: sysFont(14.0), textColor: rgbColor(153, 153, 153))
        label.textAlignment = .right
        return label
    }()
    
    lazy var detailIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icNoticeMoreCopy5")
        return imageView
    }()
    
    lazy var descriptLabel: UILabel = {
        let label = UILabel(text: "请72小时内（02-07 11:34:30前）通过对方的微信好友申请，然后点击确认添加button，打赏将于48小时后自动到账，或对方确认后，立即到账。", font: UIFont(name: "PingFang-SC-Medium", size: 14.0)!, textColor: rgbColor(102, 102, 102))
        label.numberOfLines = 0
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Layout
extension ZZWechatOrderSmallInfoCardView {
    func layout() {
        self.backgroundColor = .white;
        self.layer.cornerRadius = 4.0
        self.layer.shadowColor = rgbaColor(93, 93, 93, 0.3).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.3
        
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        self.addSubview(detailLabel)
        self.addSubview(detailIconImageView)
        self.addSubview(descriptLabel)
        
        iconImageView.mas_makeConstraints { (make) in
            make?.top.equalTo()(self)?.offset()(15.0)
            make?.left.equalTo()(self)?.offset()(15.0)
            make?.size.mas_equalTo()(CGSize(width: 22.0, height: 22.0))
        }
        
        titleLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(iconImageView.mas_right)?.offset()(7.0)
            make?.centerY.equalTo()(iconImageView)
        }
        
        detailIconImageView.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(iconImageView)
            make?.right.equalTo()(self)?.offset()(-15)
            make?.size.mas_equalTo()(CGSize(width: 5.0, height: 10.0))
        }
        
        detailLabel.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(iconImageView)
            make?.right.equalTo()(detailIconImageView.mas_left)?.offset()(-7.0)
        }
        
        descriptLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(15.0)
            make?.bottom.equalTo()(self)?.offset()(-15.0)
            make?.right.equalTo()(self)?.offset()(-15)
            make?.top.equalTo()(iconImageView.mas_bottom)?.offset()(10)
        }
    }
}
