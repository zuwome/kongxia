//
//  ZZWXOrderCell.swift
//  zuwome
//
//  Created by qiming xiao on 2019/2/25.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

protocol ZZWXOrderCellDelegate:NSObjectProtocol {
    func iconSelected(_ order: ZZWXOrderModel?)
}

class ZZWXOrderCell: ZZTableViewCell {
    weak var delegate: ZZWXOrderCellDelegate?
    var model: ZZWXOrderModel? = nil
    lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        self.layer.cornerRadius = 3.0
        self.layer.masksToBounds = true
        return view
    }()
    
    lazy var userInfoView: WXOrderUserInfoView = {
        let view = WXOrderUserInfoView()
        view.userIconImageView.touchHead = {
            self.delegate?.iconSelected(self.model)
        }
        return view
    }()
    
    lazy var statusView: WXOrderStatusView = {
        let view = WXOrderStatusView()
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configData(_ wxOrder: ZZWXOrderModel) {
        model = wxOrder
        if wxOrder._doc?.from?._id != nil && wxOrder._doc?.from?._id == ZZUserHelper.shareInstance()?.loginerId {
            userInfoView.userNameLabel.text = wxOrder._doc?.to?.nickname
            userInfoView.memeLabel.text = "么么号:\(wxOrder._doc?.to?.ZWMId ?? 0000000)"

            if wxOrder._doc?.to?.gender == 2 {
                userInfoView.genderImageView.image = UIImage(named: "girl")
            }
            else if wxOrder._doc?.to?.gender == 1 {
                userInfoView.genderImageView.image = UIImage(named: "boy")
            }
            else {
                userInfoView.genderImageView.image = UIImage()
            }
            
            if let level = wxOrder._doc?.to?.level {
                userInfoView.levelImageView.setLevel(level)
            }
            
            
            let time = ZZDateFormatterHelper.share.locaTime(sysTime: wxOrder._doc!.created_at!)
            userInfoView.timeLabel.text = time
            
            if (wxOrder.to_msg?["title"] as? String) != nil {
                statusView.actionLabel.text = wxOrder.from_msg!["title"] as? String
            }
            
            
            var isVerified = false
            if let weibo = wxOrder._doc?.to?.weibo {
                isVerified = weibo.verified ?? false
            }
            
            if let iconStr = wxOrder._doc?.to?.avatar {
//                if wxOrder._doc?.to?.avatar_detect_status == 2 {
//                    iconStr = iconStr + "?imageMogr2/blur/20x20"
//                }
                userInfoView.userIconImageView.userAvatar(iconStr,
                                                          verified: isVerified,
                                                          width: 50,
                                                          vWidth: 12)
            }
            else {
                userInfoView.userIconImageView.userAvatar("",
                                                          verified: isVerified,
                                                          width: 50,
                                                          vWidth: 12)
            }
            
        }
        else if wxOrder._doc?.to?._id != nil && wxOrder._doc?.to?._id == ZZUserHelper.shareInstance()?.loginerId {
            userInfoView.userNameLabel.text = wxOrder._doc?.from?.nickname
            userInfoView.memeLabel.text = "么么号:\(wxOrder._doc?.from?.ZWMId ?? 0000000)"
            userInfoView.statusLabel.text = "查看微信"
            
            if wxOrder._doc?.from?.gender == 2 {
                userInfoView.genderImageView.image = UIImage(named: "girl")
            }
            else if wxOrder._doc?.from?.gender == 1 {
                userInfoView.genderImageView.image = UIImage(named: "boy")
            }
            else {
                userInfoView.genderImageView.image = UIImage()
            }
            
            if let level = wxOrder._doc?.from?.level {
                userInfoView.levelImageView.setLevel(level)
            }
            
            
            let time = ZZDateFormatterHelper.share.locaTime(sysTime: wxOrder._doc!.created_at!)
            userInfoView.timeLabel.text = time
            
            statusView.actionLabel.text = wxOrder.from_msg!["title"] as? String
            
            var isVerified = false
            if let weibo = wxOrder._doc?.from?.weibo {
                isVerified = weibo.verified ?? false
            }
            
            if let iconStr = wxOrder._doc?.from?.avatar {
//                if wxOrder._doc?.from?.avatar_detect_status == 2 {
//                    iconStr = iconStr + "?imageMogr2/blur/20x20"
//                }
                userInfoView.userIconImageView.userAvatar(iconStr,
                                                          verified: isVerified,
                                                          width: 50,
                                                          vWidth: 12)
            }
            else {
                userInfoView.userIconImageView.userAvatar("",
                                                          verified: isVerified,
                                                          width: 50,
                                                          vWidth: 12)
            }
        }
        userInfoView.statusLabel.text = wxOrder.isBuy ? "查看微信" : "被查看微信"
    }
    
}

extension ZZWXOrderCell {
    func layout() {
        self.backgroundColor = rgbColor(245, 245, 245)
        
        self.addSubview(self.cardView)
        cardView.addSubview(self.userInfoView)
        cardView.addSubview(self.statusView)
        
        cardView.mas_makeConstraints { (make) in
            make?.top.equalTo()(self)?.offset()(7.0)
            make?.left.equalTo()(self)?.offset()(7.0)
            make?.right.equalTo()(self)?.offset()(-7.0)
            make?.bottom.equalTo()(self)
        }
        
        userInfoView.mas_makeConstraints { (make) in
            make?.top.equalTo()(cardView)
            make?.left.equalTo()(cardView)
            make?.right.equalTo()(cardView)
        }
        
        statusView.mas_makeConstraints { (make) in
            make?.top.equalTo()(userInfoView.mas_bottom)
            make?.left.equalTo()(cardView)
            make?.right.equalTo()(cardView)
            make?.bottom.equalTo()(cardView)
        }
    }
}

// MARK: - 订单用户信息简单图
class WXOrderUserInfoView: UIView {
    lazy var userIconImageView: ZZHeadImageView = {
        let imageView = ZZHeadImageView()
        return imageView
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel(text: "nil",
                            font: font(16.0),
                            textColor: .black)
        
        return label
    }()
    
    lazy var genderImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var levelImageView: ZZLevelImgView = {
        let imageView = ZZLevelImgView()
        
        return imageView
    }()
    
    lazy var statusLabel: UILabel = {
        let label = UILabel(text: "被查看微信",
                            font: font(15.0),
                            textColor: rgbColor(102, 102, 102))
        label.textAlignment = .right
        return label
    }()
    
    lazy var memeLabel: UILabel = {
        let label = UILabel(text: "么么号：7665443",
                            font: font(14.0),
                            textColor: rgbColor(153, 153, 153))
        
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel(text: "2019-01-19 11:34:28",
                            font: font(12.0),
                            textColor: rgbColor(153, 153, 153))
        label.textAlignment = .right
        return label
    }()
    
    lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = rgbColor(237, 237, 237)
        return view
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WXOrderUserInfoView {
    func layout() {
        self.addSubview(self.userIconImageView)
        self.addSubview(self.userNameLabel)
        self.addSubview(self.genderImageView)
        self.addSubview(self.levelImageView)
        self.addSubview(self.statusLabel)
        self.addSubview(self.memeLabel)
        self.addSubview(self.timeLabel)
        self.addSubview(self.line)
        
        userIconImageView.mas_makeConstraints { (make) in
            make?.top.equalTo()(self)?.offset()(20.0)
            make?.left.equalTo()(self)?.offset()(11.0)
            make?.size.mas_equalTo()(CGSize(width: 50.0, height: 50.0))
        }
        
        userNameLabel.mas_makeConstraints { (make) in
            make?.top.equalTo()(userIconImageView)
            make?.left.equalTo()(userIconImageView.mas_right)?.offset()(10.0)
        }
        
        genderImageView.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(userNameLabel)
            make?.left.equalTo()(userNameLabel.mas_right)?.offset()(3)
            make?.size.mas_equalTo()(CGSize(width: 12.5, height: 12.5))
        }
        
        levelImageView.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(userNameLabel)
            make?.left.equalTo()(genderImageView.mas_right)?.offset()(15)
            make?.size.mas_equalTo()(CGSize(width: 28, height: 14))
        }
        
        statusLabel.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(userNameLabel)
            make?.right.equalTo()(-11.0)
        }
        
        memeLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(userNameLabel)
            make?.top.equalTo()(userNameLabel.mas_bottom)?.offset()(8.5)
        }
        
        timeLabel.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(memeLabel)
            make?.right.equalTo()(-11.0)
        }
        
        line.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(11)
            make?.right.equalTo()(self)?.offset()(-11)
            make?.bottom.equalTo()(self)
            make?.top.equalTo()(memeLabel.mas_bottom)?.offset()(20.0)
            make?.height.equalTo()(0.5)
        }
        
    }
}

// MARK: - 订单状态
class WXOrderStatusView: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel(text: "订单状态",
                            font: font(15.0),
                            textColor: .black)
        
        return label
    }()
    
    lazy var actionLabel: UILabel = {
        let btn = UILabel(text: "待添加",
                          font: font(13.0),
                          textColor: rgbColor(63, 58, 58))
        btn.textAlignment = .center
        btn.layer.cornerRadius = 16.0
        btn.backgroundColor = rgbColor(244, 203, 7)
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

extension WXOrderStatusView {
    func layout() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.actionLabel)
        
        titleLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(11.0)
            make?.centerY.equalTo()(actionLabel)
        }
        
        actionLabel.mas_makeConstraints { (make) in
            make?.top.equalTo()(self)?.offset()(9.0)
            make?.bottom.equalTo()(self)?.offset()(-9.0)
            make?.right.equalTo()(self)?.offset()(-11.0)
            make?.size.mas_equalTo()(CGSize(width: 79.0, height: 32.0))
        }
        
        actionLabel.layer.cornerRadius = 16.0
        actionLabel.clipsToBounds = true
    }
}
