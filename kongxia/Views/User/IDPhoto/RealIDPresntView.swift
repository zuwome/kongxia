//
//  RealIDPresntView.swift
//  kongxia
//
//  Created by qiming xiao on 2021/4/11.
//  Copyright © 2021 TimoreYu. All rights reserved.
//

import Foundation

@objc protocol RealIDPresentViewDelegate: NSObjectProtocol {
    func showProtocl(view: RealIDPresentView)
    func goVerifyFace(view: RealIDPresentView)
    func changePhoto(view: RealIDPresentView)
    func goDate(view: RealIDPresentView)
    func signUpRent(view: RealIDPresentView)
    func editProfile(view: RealIDPresentView)
}

@objc class RealIDPresentView: UIView {
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .black;
        view.alpha = 0.0;
        return view;
    }()
    
    lazy var presentView: RealPhotoPresentView = {
        let view = RealPhotoPresentView()
        view.closeButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        view.actionButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(showProtocol))
        view.subTitleLabel.addGestureRecognizer(tap)
        
        view.layer.cornerRadius = 15
        return view;
    }()
    
    @objc static func show(user: ZZUser, isFromSignUpRent: Bool) -> RealIDPresentView {
        let presentView = RealIDPresentView(user: user, isFromSignUpRent: isFromSignUpRent, frame: CGRect(x: 0.0, y: 0.0, width: UIApplication.shared.keyWindow?.bounds.width ?? 0, height: UIApplication.shared.keyWindow?.bounds.height ?? 0))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            presentView.show()
        }
        
        return presentView
    }
    
    var user: ZZUser?
    
    var isFromSignUpRent: Bool = false
    
    @objc weak var delegate: RealIDPresentViewDelegate?
    
    init(user: ZZUser, isFromSignUpRent: Bool,frame: CGRect) {
        super.init(frame: frame)
        self.user = user
        self.isFromSignUpRent = isFromSignUpRent
        layout()
        presentView.setUpUser(user: user, isFromSignUpRent: isFromSignUpRent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonAction() {
        dismiss()
        
        if ZZUserHelper.shareInstance().loginer.uid != user?.uid {
            if ZZUserHelper.shareInstance().loginer.faces?.count == 0  {
                delegate?.goVerifyFace(view: self)
            }
            else {
                if (ZZUserHelper.shareInstance().didHaveRealAvatar()) {
                    delegate?.goDate(view: self)
                }
                else {
                    delegate?.changePhoto(view: self)
                }
            }
        }
        else {
            if ZZUserHelper.shareInstance().loginer.faces?.count == 0  {
                delegate?.goVerifyFace(view: self)
            }
            else {
                if (!ZZUserHelper.shareInstance().didHaveRealAvatar()) {
                    if ZZUserHelper.shareInstance().loginer.isAvatarManualReviewing() {
                        delegate?.signUpRent(view: self)
                    }
                    else {
                        delegate?.changePhoto(view: self)
                    }
                }
                else {
                    if (ZZUserHelper.shareInstance().loginer.rent.status != 2) {
                        delegate?.signUpRent(view: self)
                    }
                    else {
                        delegate?.editProfile(view: self)
                    }
                }
            }
        }
    }
    
    @objc func showProtocol() {
        dismiss()
        delegate?.showProtocl(view: self)
    }
    
    // 隐藏
    @objc func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bgView.alpha = 0.0
            self.presentView.top = self.bounds.height + 33
        }, completion: { (isComplete) in
            self.bgView.removeFromSuperview()
            self.presentView.removeFromSuperview()
            self.removeFromSuperview()
        })
    }
    
    // 显示
    @objc func show() {
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 0.5
            self.presentView.top = self.bounds.height - self.presentView.height
        }
    }
    
    func layout() {
        self.addSubview(bgView)
        self.addSubview(presentView)
        bgView.frame = self.bounds
        presentView.frame = CGRect(x: 0.0, y: self.bounds.height + 33, width: self.bounds.width, height: 309)
    }
}

class RealPhotoPresentView: UIView {
    lazy var userAvatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 33
        imageView.clipsToBounds = true
        return imageView;
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView;
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icClose_privChat"), for: .normal)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "空虾的推荐达人都是头像真实的认证用户，请先完成真实头像认证";
        label.font = UIFont(name: "PingFang-SC-Medium", size: 15.0) ?? UIFont.systemFont(ofSize: 15.0)
        label.textColor = UIColor.rgbColor(63, 58, 58)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    lazy var icon1ImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView;
    }()
    
    lazy var icon2ImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView;
    }()
    
    lazy var icon3ImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView;
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .rgbColor(244, 203, 7)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 25
        return button
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFang-SC-Medium", size: 13.0) ?? UIFont.systemFont(ofSize: 13.0)
        label.textColor = UIColor.rgbColor(102, 102, 102)
        label.numberOfLines = 2
        label.textAlignment = .center
        let attributedString = NSMutableAttributedString(string: "进行认证即视为同意真实头像认证条款", attributes: [
          .font: UIFont(name: "PingFang-SC-Medium", size: 13.0)!,
          .foregroundColor: UIColor.rgbColor(102, 102, 102),
          .kern: 0.0
        ])
        attributedString.addAttributes([
          .font: UIFont(name: "PingFangSC-Medium", size: 13.0)!,
          .foregroundColor: UIColor.rgbColor(74, 144, 226)
        ], range: NSRange(location: 9, length: 8))
        
        label.attributedText = attributedString
        
        label.isUserInteractionEnabled = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUser(user: ZZUser, isFromSignUpRent: Bool) {
        userAvatarImageView.sd_setImage(with: URL(string: user.displayAvatar()), placeholderImage: UIImage(named: "icon_placeholder"))
        
        if !user.isUsersAvatarReal() {
            iconImageView.image = UIImage(named: "icZhenshitouxiangMoren")
        }
        else {
            iconImageView.image = UIImage(named: "icZhenshitouxiang")
        }
        
        guard let confimodel = ZZUserHelper.shareInstance().configModel,  let userInfomationModel = confimodel.user_infomation else {
            return
        }
        
        var title: String, icon1: String?, icon2: String?, icon3: String?;
        
        if ZZUserHelper.shareInstance().loginer.uid != user.uid {
            title = userInfomationModel.yrz.content ?? "通过真实头像认证，才能被首页推荐，赚取收益,他已通过认证，头像为本人，已开启真实头像特权"
            icon1 = userInfomationModel.yrz.icons[0] as? String
            icon2 = userInfomationModel.yrz.icons[1] as? String
            icon3 = userInfomationModel.yrz.icons[2] as? String

        }
        else {
            if user.faces?.count == 0 {
                title = userInfomationModel.wsbwcj.content ?? "认证真实头像，才能被首页推荐，赚取收益；人脸识别，上传真实头像，即可获得认证特权"
                icon1 = userInfomationModel.wsbwcj.icons[0] as? String
                icon2 = userInfomationModel.wsbwcj.icons[1] as? String
                icon3 = userInfomationModel.wsbwcj.icons[2] as? String
            }
            else {
                if !user.didHaveRealAvatar() {
                    if (user.isAvatarManualReviewing()) {
                        title = userInfomationModel.sh.content ?? "您已提交真实头像认证审核，请等待审核结果，预先解锁达人身份，聊天赚钱，时间变现，赚取收益"
                        icon1 = userInfomationModel.sh.icons[0] as? String
                        icon2 = userInfomationModel.sh.icons[1] as? String
                        icon3 = userInfomationModel.sh.icons[2] as? String
                    }
                    else {
                        title = userInfomationModel.wsbwcj.content ?? "更换本人正脸照片，即可通过真实头像认证，使用认证特权"
                        icon1 = userInfomationModel.wsbwcj.icons[0] as? String
                        icon2 = userInfomationModel.wsbwcj.icons[1] as? String
                        icon3 = userInfomationModel.wsbwcj.icons[2] as? String
                    }
                }
                else {
                    if user.rent.status == 2 {
                        title = userInfomationModel.rzcg.content ?? "您认证真实头像，已申请达人，去完善资料，主动发起私信聊天，会接到更多邀约哦"
                        icon1 = userInfomationModel.rzcg.icons[0] as? String
                        icon2 = userInfomationModel.rzcg.icons[1] as? String
                        icon3 = userInfomationModel.rzcg.icons[2] as? String
                    }
                    else {
                        title = userInfomationModel.shdr.content ?? "您已认证真实头像，快去解锁达人身份，聊天赚钱，时间变现，赚取收益"
                        icon1 = userInfomationModel.shdr.icons[0] as? String
                        icon2 = userInfomationModel.shdr.icons[1] as? String
                        icon3 = userInfomationModel.shdr.icons[2] as? String
                    }
                }
            }
        }
        
        titleLabel.text = title;
        icon1ImageView.sd_setImage(with: URL(string: icon1 ?? ""), placeholderImage: UIImage(named: "bgTosixindashangDianliang"), options: .retryFailed, progress: nil, completed: nil)
        icon2ImageView.sd_setImage(with: URL(string: icon2 ?? ""), placeholderImage: UIImage(named: "bgShijianbianxianDianliang"), options: .retryFailed, progress: nil, completed: nil)
        icon3ImageView.sd_setImage(with: URL(string: icon3 ?? ""), placeholderImage: UIImage(named: "bgYaoyuezhuanqianDianliang"), options: .retryFailed, progress: nil, completed: nil)
 
        subTitleLabel.isHidden = false
        if ZZUserHelper.shareInstance().loginer.uid != user.uid {
            if ZZUserHelper.shareInstance().loginer.faces?.count == 0  {
                actionButton.setTitle("我要认证", for: .normal)
            }
            else {
                if (ZZUserHelper.shareInstance().loginer.didHaveRealAvatar()) {
                    subTitleLabel.isHidden = false
                    actionButton.setTitle("马上约TA", for: .normal)
                }
                else {
                    actionButton.setTitle("更换真实头像", for: .normal)
                }
            }
        }
        else {
            if isFromSignUpRent {
                if ZZUserHelper.shareInstance().loginer.faces?.count == 0  {
                    actionButton.setTitle("认证真实头像", for: .normal)
                }
                else {
                    if (!ZZUserHelper.shareInstance().loginer.didHaveRealAvatar() && !ZZUserHelper.shareInstance().loginer.isAvatarManualReviewing() ) {
                        actionButton.setTitle("更换真实头像", for: .normal)
                    }
                    else {
                        actionButton.setTitle("去申请达人", for: .normal)
                    }
                }
            }
            else {
                if ZZUserHelper.shareInstance().loginer.faces?.count == 0  {
                    actionButton.setTitle("我要认证", for: .normal)
                }
                else {
                    if (!ZZUserHelper.shareInstance().loginer.didHaveRealAvatar()) {
                        if ZZUserHelper.shareInstance().loginer.isAvatarManualReviewing() {
                            subTitleLabel.isHidden = true
                            actionButton.setTitle("去申请达人", for: .normal)
                        }
                        else {
                            actionButton.setTitle("更换真实头像", for: .normal)
                        }
                    }
                    else {
                        subTitleLabel.isHidden = true
                        if (ZZUserHelper.shareInstance().loginer.rent.status != 2) {
                            actionButton.setTitle("去申请达人", for: .normal)
                        }
                        else {
                            actionButton.setTitle("去完善资料", for: .normal)
                        }
                    }
                }
            }
        }
    }
    
    func layout() {
        self.backgroundColor = .white
        
        addSubview(userAvatarImageView)
        addSubview(iconImageView)
        addSubview(closeButton)
        addSubview(titleLabel)
        addSubview(icon1ImageView)
        addSubview(icon2ImageView)
        addSubview(icon3ImageView)
        addSubview(actionButton)
        addSubview(subTitleLabel)
        
        userAvatarImageView.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(self.mas_top)
            make?.centerX.equalTo()(self.mas_centerX)
            make?.size.mas_equalTo()(CGSize(width: 66, height: 66))
        }
        
        iconImageView.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(userAvatarImageView.mas_bottom)
            make?.centerX.equalTo()(self.mas_centerX)
            make?.size.mas_equalTo()(CGSize(width: 51, height: 20))
        }
        
        closeButton.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(18)
            make?.top.equalTo()(self)?.offset()(16)
            make?.size.mas_equalTo()(CGSize(width: 24, height: 24))
        }
        
        titleLabel.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(self.mas_centerX)
            make?.top.equalTo()(userAvatarImageView.mas_bottom)?.offset()(27.5)
            make?.left.equalTo()(self)?.offset()(22.5)
            make?.right.equalTo()(self)?.offset()(-22.5)
        }
        
        icon2ImageView.mas_makeConstraints { (make) in
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(16)
            make?.centerX.equalTo()(self.mas_centerX)
            make?.size.mas_equalTo()(CGSize(width: 93, height: 63.5))
        }
        
        icon1ImageView.mas_makeConstraints { (make) in
            make?.right.equalTo()(icon2ImageView.mas_left)?.offset()(-16)
            make?.centerY.equalTo()(icon2ImageView)
            make?.size.mas_equalTo()(CGSize(width: 93, height: 63.5))
        }
        
        icon3ImageView.mas_makeConstraints { (make) in
            make?.left.equalTo()(icon2ImageView.mas_right)?.offset()(16)
            make?.centerY.equalTo()(icon2ImageView)
            make?.size.mas_equalTo()(CGSize(width: 93, height: 63.5))
        }
        
        actionButton.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(self.mas_centerX)
            make?.top.equalTo()(icon2ImageView.mas_bottom)?.offset()(28)
            make?.size.mas_equalTo()(CGSize(width: 269, height: 44))
        }
        
        subTitleLabel.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(self.mas_centerX)
            make?.top.equalTo()(actionButton.mas_bottom)?.offset()(15)
            make?.left.equalTo()(self)?.offset()(22.5)
            make?.right.equalTo()(self)?.offset()(-22.5)
        }
    }
}
