//
//  LivestreamAlertView.swift
//  kongxia
//
//  Created by qiming xiao on 2022/1/15.
//  Copyright © 2022 TimoreYu. All rights reserved.
//

import UIKit

typealias StartVideoChatBlock = () -> Void

class LiveStreamAlertView: UIView {
    @objc var startVideoClousure : StartVideoChatBlock?
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.4
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var contentbgView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.4
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
        
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    lazy var remindBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("不再提醒", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        btn.setTitleColor(.black, for: .normal)
        btn.setImage(UIImage(named: "radio"), for: .normal)
        btn.setImage(UIImage(named: "radioChecked"), for: .selected)
        btn.addTarget(self, action: #selector(remindAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var cancelBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("取消", for: .normal)
        btn.backgroundColor = UIColor.rgbColor(216, 216, 216)
        btn.layer.cornerRadius = 4
        btn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return btn
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("立即视频", for: .normal)
        btn.backgroundColor = UIColor.rgbColor(244, 203, 7)
        btn.layer.cornerRadius = 4
        btn.addTarget(self, action: #selector(startVideoChat), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
        
        bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dismiss() {
        self.removeFromSuperview()
    }
    
    @objc func startVideoChat() {
        dismiss()
        startVideoClousure?()
        setRemindStatus()
    }
    
    @objc func remindAction() {
        remindBtn.isSelected = !remindBtn.isSelected
    } 
}

extension LiveStreamAlertView {
    @objc func setupData(cards: Int, mcoinperCard: Int) {
        titleLabel.text = "发起1V1视频"
        iconImageView.image = UIImage(named: "icon_livestream_video")
        contentLabel.text = "视频通话每分钟需赠送\(cards)张咨询卡，要发起视频通话吗？"
        infoLabel.text = "1张咨询卡=\(mcoinperCard)么币"
    }
    
    func setRemindStatus() {
        guard !remindBtn.isSelected  else {
            return
        }
        let userDefault = UserDefaults.standard
        userDefault.set(true, forKey: "DonotShowInviteVideoChatAlertStat")
    }
    
}
extension LiveStreamAlertView {
    func layoutUI() {
        addSubview(bgView)
        addSubview(contentView)
        contentView.addSubview(contentbgView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(remindBtn)
        contentView.addSubview(cancelBtn)
        contentView.addSubview(confirmBtn)
        
        bgView.mas_makeConstraints { make in
            make?.edges.equalTo()(self)
        }
        
        let width = 317.0
        contentView.mas_makeConstraints { make in
            make?.center.equalTo()(self)
            make?.size.mas_equalTo()(CGSize(width: width, height: 289))
        }
        
        contentbgView.mas_makeConstraints { make in
            make?.top.left().right().equalTo()(contentView)
            make?.height.equalTo()(107)
        }
        
        titleLabel.mas_makeConstraints { make in
            make?.left.right().equalTo()(self)
            make?.top.equalTo()(contentView)?.offset()(29)
        }
        
        iconImageView.mas_makeConstraints { make in
            make?.centerX.equalTo()(contentView)
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(15)
            make?.size.mas_equalTo()(CGSize(width: 44, height: 44))
        }
        
        contentLabel.mas_makeConstraints { make in
            make?.top.equalTo()(iconImageView.mas_bottom)?.offset()(10)
            make?.left.equalTo()(contentView)?.offset()(32)
            make?.right.equalTo()(contentView)?.offset()(-32)
        }
        
        infoLabel.mas_makeConstraints { make in
            make?.top.equalTo()(contentLabel.mas_bottom)?.offset()(7)
            make?.left.equalTo()(contentView)?.offset()(32)
            make?.right.equalTo()(contentView)?.offset()(-32)
        }
        
        remindBtn.mas_makeConstraints { make in
            make?.top.equalTo()(infoLabel.mas_bottom)?.offset()(14)
            make?.centerX.equalTo()(contentView)
        }
        
        let offset = 16.0
        let btnWidth = (width - offset * 3) / 2
        cancelBtn.mas_makeConstraints { make in
            make?.left.equalTo()(contentView)?.offset()(offset)
            make?.top.equalTo()(remindBtn.mas_bottom)?.offset()(11)
            make?.size.mas_equalTo()(CGSize(width: btnWidth, height: 49))
        }
        
        confirmBtn.mas_makeConstraints { make in
            make?.left.equalTo()(cancelBtn.mas_right)?.offset()(offset)
            make?.top.equalTo()(remindBtn.mas_bottom)?.offset()(11)
            make?.size.mas_equalTo()(CGSize(width: btnWidth, height: 49))
        }
    }
}

