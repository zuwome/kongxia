//
//  ZZChatInviteVideoChatCell.swift
//  kongxia
//
//  Created by qiming xiao on 2022/1/14.
//  Copyright © 2022 TimoreYu. All rights reserved.
//

import UIKit

@objc protocol ZZChatInviteVideoChatCellDelegate: NSObjectProtocol {
    func startVideoChat(cell: ZZChatInviteVideoChatCell)
}

class ZZChatInviteVideoChatCell: ZZTableViewCell {
    @objc weak var delegate: ZZChatInviteVideoChatCellDelegate?
    
    lazy var contentBg: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 32
        view.backgroundColor = .white
        return view
    }()
    
    lazy var userIconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 32
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .center
        label.text = "她在线邀请你视频通话"
        return label
    }()
    
    lazy var videoChatButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(videoChat), for: .touchUpInside)
        btn.setImage(UIImage(named: "startvideochat"), for: .normal)
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func videoChat() {
        delegate?.startVideoChat(cell: self)
    }
}

extension ZZChatInviteVideoChatCell {
    @objc func setUp(userIcon: String) {
        userIconImage.sd_setImage(with: URL(string: userIcon), completed: nil)
    }
}

extension ZZChatInviteVideoChatCell {
    func layoutUI() {
        contentView.addSubview(contentBg)
        contentBg.addSubview(userIconImage)
        contentBg.addSubview(messageLabel)
        contentBg.addSubview(videoChatButton)
        
        contentBg.mas_makeConstraints { make in
            make?.top.equalTo()(contentView)?.offset()(10)
            make?.bottom.equalTo()(contentView)
            make?.left.equalTo()(contentView)?.offset()(16)
            make?.right.equalTo()(contentView)?.offset()(-16)
        }
        
        userIconImage.mas_makeConstraints { make in
            make?.left.equalTo()(contentBg)
            make?.top.equalTo()(contentBg)
            make?.width.equalTo()(64)
            make?.height.equalTo()(64)
        }
        
        videoChatButton.mas_makeConstraints { make in
            make?.centerY.equalTo()(contentBg)
            make?.right.equalTo()(contentBg)?.offset()(-18)
            make?.size.mas_equalTo()(CGSize(width: 76, height: 40))
        }
        
        messageLabel.mas_makeConstraints { make in
            make?.top.bottom().equalTo()(contentBg)
            make?.left.equalTo()(userIconImage.mas_right)?.offset()(5)
            make?.right.equalTo()(videoChatButton.mas_left)?.offset()(-5)
        }
    }
}
