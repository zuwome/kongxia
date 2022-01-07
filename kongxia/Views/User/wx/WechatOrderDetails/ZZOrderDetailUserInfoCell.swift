//
//  ZZOrderDetailUserInfoCell.swift
//  zuwome
//
//  Created by qiming xiao on 2019/2/28.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

protocol ZZOrderDetailUserInfoCellDelegate: NSObjectProtocol {
    func showUserInfo(userID: String?)
}

class ZZOrderDetailUserInfoCell: ZZTableViewCell {
    weak var delegate: ZZOrderDetailUserInfoCellDelegate?
    var userInfo: WXOrderUserInfoModel? = nil
    
    lazy var userInfoView: WXOrderUserInfoView = {
        let view = WXOrderUserInfoView()
        view.userIconImageView.touchHead = {
            self.delegate?.showUserInfo(userID: self.userInfo?._id)
        }
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func userInfo(isBuy: Bool, user: WXOrderUserInfoModel!, createTime: String!) {
        userInfo = user
        userInfoView.userNameLabel.text = user.nickname
        userInfoView.memeLabel.text = "么么号\(user.ZWMId!)"
        userInfoView.statusLabel.text = isBuy ? "查看微信" : "被查看微信"
        
        let time = ZZDateFormatterHelper.share.locaTime(sysTime: createTime)
        userInfoView.timeLabel.text = time
        
        var isVerified = false
        if let weibo = user.weibo {
            isVerified = weibo.verified ?? false
        }
        
        if let iconStr = user.avatar {
//            if user.avatar_detect_status == 2 {
//                iconStr = iconStr + "?imageMogr2/blur/20x20"
//            }
            userInfoView.userIconImageView.userAvatar(iconStr,
                                                      verified: isVerified,
                                                      width: 50,
                                                      vWidth: 12)
        }
    }
    
}

// MARK: - Layout
extension ZZOrderDetailUserInfoCell {
    func layout() {
        self.addSubview(self.userInfoView)
        userInfoView.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(7.0)
            make?.right.equalTo()(self)?.offset()(-7.0)
            make?.top.equalTo()(self)
            make?.bottom.equalTo()(self)
        }
    }
}
