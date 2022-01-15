//
//  inviteVideoChatView.swift
//  kongxia
//
//  Created by qiming xiao on 2022/1/14.
//  Copyright © 2022 TimoreYu. All rights reserved.
//

import UIKit

@objc protocol InviteVideoChatViewDelegate: NSObjectProtocol {
    func chat(view: InviteVideoChatView)
}

class InviteVideoChatView: UIView {
    @objc weak var delegate: InviteVideoChatViewDelegate?
    
    lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "InviteChatBgView")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "邀请视频通话"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        createUI()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(invite)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func invite() {
        delegate?.chat(view: self)
    }
}

extension InviteVideoChatView {
    @objc func showPrice() {
        titleLabel.text = "邀请视频通话"
        subtitleLabel.text = "收益X.X元/分钟"
    }
}

extension InviteVideoChatView {
    func createUI() {
        addSubview(bgImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        bgImageView.mas_makeConstraints { make in
            make?.edges.equalTo()(self)
        }
        
        titleLabel.mas_makeConstraints { make in
            make?.left.equalTo()(self)?.offset()(49)
            make?.right.equalTo()(self)?.offset()(-16)
            make?.top.equalTo()(self)?.offset()(9)
        }
        
        subtitleLabel.mas_makeConstraints { make in
            make?.left.equalTo()(titleLabel)
            make?.right.equalTo()(titleLabel)
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(3)
        }
    }
}
