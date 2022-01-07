//
//  ZZPayView.swift
//  kongxia
//
//  Created by qiming xiao on 2019/11/27.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import Foundation

protocol ZZIAPPayViewDelegate: NSObjectProtocol {
    
    // 使用内购充值
    func recharge(view: ZZIAPPayView, selectedItem: ZZMeBiModel?, paymentModel: ZZWeiChatEvaluationModel)
    
    
    func viewDismissed(view: ZZIAPPayView)
}

class ZZIAPPayView: UIView {
    weak var delegate: ZZIAPPayViewDelegate?
    
    var paymentModel: ZZWeiChatEvaluationModel
    
    var iapList: [ZZMeBiModel]? = []
    
    var choosedIAP: ZZMeBiModel?
    
    var frameHeight: CGFloat = 0
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var infoView: ZZIAPPayInfoView = {
        let view = ZZIAPPayInfoView()
        view.delegate = self
        view.layout(paymentModel: self.paymentModel, iapList: iapList)
        
        view.confirmBtn.addTarget(self, action: #selector(proceedAction), for: .touchUpInside)
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func show(paymentModel: ZZWeiChatEvaluationModel,
                     iapList: [ZZMeBiModel]?) -> ZZIAPPayView {
        let infoView = ZZIAPPayView(paymentModel: paymentModel, iapList: iapList)
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
    
    init(paymentModel: ZZWeiChatEvaluationModel, iapList: [ZZMeBiModel]?) {
        self.paymentModel = paymentModel
        self.iapList = iapList
        super.init(frame: CGRect.zero)
        layout()
        configData()
    }
}


// MARK: ZZIAPPayView Private Method
extension ZZIAPPayView {
    func configData() {
        guard paymentModel.type == .gift || paymentModel.type == .ktvGift else {
            infoView.choosedView(index: 0)
            return
        }

        infoView.titleLable.text = "么币余额不足"
        
        
        if paymentModel.type == .gift {
            let userTotalMcoins = ZZUserHelper.shareInstance()?.loginer.mcoin.intValue ?? 0
            let currentCostMcoins = ZZUserHelper.shareInstance()?.consumptionMebi ?? 0
            let leftMcoins =  userTotalMcoins - currentCostMcoins
            infoView.balanceLabel.text = "么币余额: \(leftMcoins)"
        }
        else if paymentModel.type == .ktvGift {
            infoView.balanceLabel.text = "么币余额: \(ZZUserHelper.shareInstance()?.loginer.mcoin.intValue ?? 0)"
        }
        
        if paymentModel.mcoinForItem == -99999 {
            infoView.statusLabel.isHidden = true
            infoView.choosedView(index: 0)
            infoView.titleLable.text = "么币充值"
        }
        else {
            infoView.statusLabel.isHidden = false
            if let userHelper = ZZUserHelper.shareInstance() {
                
                var stillNeedToPay: Double = 0.0
                if paymentModel.type == .gift {
                    let currentCostMebi: Double = Double(userHelper.consumptionMebi)
                    let totalToBeCost = currentCostMebi + paymentModel.mcoinForItem
                    stillNeedToPay = totalToBeCost - userHelper.loginer.mcoin.doubleValue
                }
                else if paymentModel.type == .ktvGift {
                    stillNeedToPay = paymentModel.mcoinForItem - userHelper.loginer.mcoin.doubleValue
                }
                
                infoView.statusLabel.text = "还需\(Int(stillNeedToPay))么币"
                
                if let iapList = iapList {
                    var selectIndex = 0
                    for (index, mebiModel) in iapList.enumerated() {
                        if let price = Double(mebiModel.meBi), price >= stillNeedToPay {
                            selectIndex = index
                            break
                        }
                        else {
                            if index == iapList.count - 1 {
                                selectIndex = index
                            }
                        }
                    }
                    
                    infoView.choosedView(index: selectIndex)
                }
            }
        }
    }
    
    // 内购成功之后，更新UI、直接购买操作
    func updateMebi() {
        configData()
    }
}


// MARK: ZZIAPPayView Respone method
extension ZZIAPPayView {
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
        delegate?.recharge(view: self, selectedItem: choosedIAP, paymentModel: paymentModel)
    }
}


// MARK: ZZIAPPayInfoViewDelegate
extension ZZIAPPayView: ZZIAPPayInfoViewDelegate {
    func choosedIAP(index: Int) {
        if index < iapList?.count ?? 0 {
            choosedIAP = iapList?[index]
        }
    }
}


// MARK: Layout
extension ZZIAPPayView {
    func layout() {
        self.addSubview(self.bgView)
        self.addSubview(self.infoView)
        
        bgView.mas_makeConstraints { (make) in
            make?.edges.equalTo()(self)
        }
        
        infoView.mas_makeConstraints { (make) in
            make?.bottom.equalTo()(self)?.offset()(690.0)
            make?.left.equalTo()(self)
            make?.right.equalTo()(self)
        }
    }
}

// MARK:- ZZIAPPayInfoView Protocol
protocol ZZIAPPayInfoViewDelegate: NSObjectProtocol {
    func choosedIAP(index: Int)
}

// MARK: ZZIAPPayInfoView
class ZZIAPPayInfoView: UIView {
    
    weak var delegate: ZZIAPPayInfoViewDelegate?
    
    var iapListView: [ZZIAPItemView] = []
    
    lazy var titleLable:  UILabel = {
        let label = UILabel(text: nil,
                            font: UIFont(name: "PingFangSC-Medium", size: 15) ?? sysFont(15),
                            textColor: rgbColor(63, 58, 58))
        label.textAlignment = .center
        return label
    }()
    
    lazy var iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "icMebi")
        return imageView
    }()
    
    lazy var balanceLabel: UILabel = {
        let label = UILabel(text: nil,
                            font: UIFont(name: "PingFangSC-Medium", size: 17) ?? sysFont(17),
                            textColor: rgbColor(63, 58, 58))
        
        return label
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel(text: nil,
                            font: UIFont(name: "PingFangSC-Medium", size: 15) ?? sysFont(15),
                            textColor: rgbColor(173, 173, 177))
        
        return label
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.rbg(red: 243, green: 202, blue: 47)
        btn.layer.cornerRadius = 25
        btn.setTitle("确认支付", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        return btn
    }()
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func choosedView(index: Int) {
        iapListView.forEach { (view) in
            view.setBorder(show: view.tag == index)
        }
        delegate?.choosedIAP(index: index)
    }
}

// MARK: ZZIAPPayInfoView Respone method
extension ZZIAPPayInfoView {
    @objc func choose(tap: UITapGestureRecognizer) {
        guard let index = tap.view?.tag else {
            return
        }
        choosedView(index: index)
    }
}

// MARK: ZZIAPPayInfoView Layout
extension ZZIAPPayInfoView {
    func layout(paymentModel: ZZWeiChatEvaluationModel, iapList: [ZZMeBiModel]?) {
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
        self.backgroundColor = .white
        
        self.addSubview(titleLable)
        self.addSubview(iconImage)
        self.addSubview(balanceLabel)
        self.addSubview(statusLabel)
        self.addSubview(confirmBtn)
        
        titleLable.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)
            make?.top.equalTo()(self)
            make?.right.equalTo()(self)
            make?.height.equalTo()(40)
        }
        
        iconImage.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(20.0)
            make?.top.equalTo()(titleLable.mas_bottom)?.offset()(11.5)
            make?.size.mas_equalTo()(CGSize(width: 25.0, height: 25.0))
        }
        
        balanceLabel.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(iconImage)
            make?.left.equalTo()(iconImage.mas_right)?.offset()(8.0)
        }
        
        statusLabel.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(iconImage)
            make?.right.equalTo()(self)?.offset()(-20.0)
        }
        
        let toTop = 16.0
        let toLeft = 20.0
        let viewsOffsetWidth: CGFloat = 19
        let viewsOffsetHeight: CGFloat = 24
        let offset: CGFloat = 20.0
        let viewWidth: CGFloat = (screenWidth - viewsOffsetWidth * 2 - offset * 2) / 3
        let viewHeight: CGFloat = 64
        
        var lastView: UIView = statusLabel
        for (index, iap) in iapList?.enumerated() ?? [].enumerated() {
            let view = ZZIAPItemView()
            self.addSubview(view)
            
            let left = (viewWidth + viewsOffsetWidth) * CGFloat(index % 3) + CGFloat(toLeft)
            let top = (viewHeight + viewsOffsetHeight) * CGFloat(index / 3) + CGFloat(toTop)
            view.mas_makeConstraints({ (make) in
                make?.left.equalTo()(self)?.offset()(left)
                make?.top.equalTo()(iconImage.mas_bottom)?.offset()(top)
                make?.size.mas_equalTo()(CGSize(width: viewWidth, height: viewHeight))
            })

            iapListView.append(view)
            
            view.titleLabel.text = "\(iap.meBi ?? "0")么币"
            view.subTitleLabel.text = "\(iap.meBiPrice ?? "0")元"
            if iap.give == 0 {
                view.giveBtn.isHidden = true
            }
            else {
                view.giveBtn.isHidden = false
                view.giveBtn.normalTitle = "赠送\(iap.give)么币"
            }
            
            view.tag = index
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(choose(tap:)))
            view.addGestureRecognizer(tap)
            
            if index == (iapList?.count ?? 0) - 1 {
                lastView = view
            }
        }
        
        confirmBtn.mas_makeConstraints { (make) in
            make?.top.equalTo()(lastView.mas_bottom)?.offset()(31)
            make?.left.equalTo()(self)?.offset()(15)
            make?.right.equalTo()(self)?.offset()(-15)
            make?.height.equalTo()(50)
            if #available(iOS 11.0, *) {
                make?.bottom.equalTo()(self.mas_safeAreaLayoutGuideBottom)?.offset()(-22.5)
            }
            else {
                make?.bottom.equalTo()(self)?.offset()(-22.5)
            }
        }
        
        
        let seperateLine = UIView()
        seperateLine.backgroundColor = rgbColor(216, 216, 216)
        self.addSubview(seperateLine)
        seperateLine.mas_makeConstraints { (make) in
            make?.left.right()?.bottom()?.equalTo()(titleLable)
            make?.height.equalTo()(0.5)
        }
    }
}


// MARK: - 内购选项信息view
class ZZIAPItemView: UIView {

    lazy var titleLabel: UILabel = {
        let label = UILabel(text: nil,
                            font: UIFont(name: "PingFang-SC-Medium", size: 17.0) ?? UIFont.systemFont(ofSize: 17.0),
                            textColor: Color.black)
        label.textAlignment = .center
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel(text: nil,
                            font: UIFont.systemFont(ofSize: 15.0),
                            textColor: rgbColor(63, 58, 58))
        label.textAlignment = .center
        return label
    }()
    
    lazy var giveBtn: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "recharge_give"), for: .normal)
        btn.isUserInteractionEnabled = false
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11.0)
//        btn.backgroundColor = .black
        return btn
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
            self.backgroundColor = rgbColor(240, 203, 7)
            self.layer.borderColor = rgbColor(37, 39, 43).cgColor
            self.layer.borderWidth = 0;
        }
        else{
            self.backgroundColor = .white//RGBCOLOR(240, 203, 7);
            self.layer.borderColor = rgbColor(37, 39, 43).cgColor
            self.layer.borderWidth = 0.5;
        }
    }
}


// MARK: Layout
extension ZZIAPItemView {
    func layout() {
        self.layer.cornerRadius = 3
        self.addSubview(self.titleLabel)
        self.addSubview(self.subTitleLabel)
        self.addSubview(self.giveBtn)
        
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
        
        giveBtn.mas_makeConstraints { (make) in
            make?.right.equalTo()(self);
            make?.centerY.equalTo()(self.mas_top);
            make?.size.mas_equalTo()(CGSize(width: 75, height: 20));
        }
    }
}
