//
//  ZZRealPhotoCell.swift
//  kongxia
//
//  Created by qiming xiao on 2021/4/10.
//  Copyright © 2021 TimoreYu. All rights reserved.
//

import Foundation

@objc protocol ZZRealPhotoCellDelegate: NSObjectProtocol {
    func showIDPhoto(cell: ZZRealPhotoCell)
    func realPhotoCellAction(cell: ZZRealPhotoCell)
}

class ZZRealPhotoCell: ZZTableViewCell {
    
    @objc weak var delegate: ZZRealPhotoCellDelegate?
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView;
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFang-SC-Medium", size: 15.0) ?? UIFont.systemFont(ofSize: 15.0)
        label.textColor = rgbColor(153, 153, 153)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.backgroundColor = rgbaColor(254, 66, 70, 0.13)
        button.setTitleColor(rgbColor(254, 66, 70), for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFang-SC-Medium", size: 15.0) ?? UIFont.systemFont(ofSize: 15.0)
        button.layer.cornerRadius = 2
        return button
    }()
    
    lazy var userIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showIDPhoto))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView;
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func showIDPhoto() {
        delegate?.showIDPhoto(cell: self)
    }
    
    @objc func showInfo(user: ZZUser) {
        updateFrame(user: user)
        
        titleLabel.text = "点亮真实头像徽章，解锁真实头像"
        actionButton.setTitle("去认证", for: .normal)
        iconImageView.image = UIImage(named: "icZhenshitouxiang")
        
        if ZZUserHelper.shareInstance()?.loginerId == user.uid {
            if !user.didHaveRealAvatar() {
                if user.faces.count == 0 {
                    titleLabel.text = "点亮真实头像徽章，解锁真实头像特权"
                    actionButton.setTitle("去认证", for: .normal)
                    iconImageView.image = UIImage(named: "icZhenshitouxiangMoren")
                }
                else {
                    titleLabel.text = "更换真实头像，解锁真实头像特权"
                    actionButton.setTitle("更换头像", for: .normal)
                    iconImageView.image = UIImage(named: "icZhenshitouxiangMoren")
                }
            }
            else {
                if user.rent.status != 2 {
                    titleLabel.text = "您已认证真实头像，快来解锁达人身份，赚取收益"
                    actionButton.setTitle("解锁达人", for: .normal)
                }
                else {
                    if user.id_photo.status == 2 {
                        titleLabel.text = "您已认证真实头像，证件照与头像确认为本人"
                        if let avatar = user.id_photo.pic, avatar.hasSuffix("/blur/70x70") {
                            let pic = avatar.replacingOccurrences(of: "/blur/70x70", with: "", options: .caseInsensitive, range: Range(NSRange(location: 0, length: avatar.count), in: avatar))
                            userIconImageView.sd_setImage(with: URL(string: pic), completed: nil)
                        }
                        else {
                            userIconImageView.sd_setImage(with: URL(string: user.id_photo.pic), completed: nil)
                        }
                    }
                    else {
                        titleLabel.text = "您已认证真实头像，头像确认为本人"
                    }
                }
            }
        }
        else {
            if user.isUsersAvatarReal() {
                titleLabel.text = "Ta已认证真实头像，头像确认为本人"
            }
            else {
                titleLabel.text = "Ta已认证真实头像， 证件照与头像确认为本人"
            }
            if user.id_photo?.status == 2 {
                if let avatar = user.id_photo.pic, avatar.hasSuffix("/blur/70x70") {
                    let pic = avatar.replacingOccurrences(of: "/blur/70x70", with: "", options: .caseInsensitive, range: Range(NSRange(location: 0, length: avatar.count), in: avatar))
                    userIconImageView.sd_setImage(with: URL(string: pic), completed: nil)
                }
            }
        }
        
        titleLabel.sizeToFit()
    }
}

// MARK: Respones
extension ZZRealPhotoCell {
    @objc func buttonAction(sender: UIButton) {
        delegate?.realPhotoCellAction(cell: self)
    }
}

// MARK: Layout
extension ZZRealPhotoCell {
    func layout() {
        self.contentView.addSubview(iconImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(actionButton)
        self.contentView.addSubview(userIconImageView)
    }
    
    func updateFrame(user: ZZUser) {
        userIconImageView.isHidden = true;
        actionButton.isHidden = true;
        
        iconImageView.frame = CGRect(x: 15, y: 15, width: 58, height: 24)
        
        if ZZUserHelper.shareInstance()?.loginerId == user.uid {
            if user.didHaveRealAvatar() && user.rent.status == 2 && user.faces.count != 0 {
                if user.id_photo.status == 2 {
                    userIconImageView.isHidden = false
                    userIconImageView.frame = CGRect(x: contentView.frame.width - 40 - 15, y: 16, width: 40, height: 60)
                    titleLabel.frame = CGRect(x: iconImageView.right + 8, y: 15, width: userIconImageView.left - iconImageView.right - 28, height: 40)
                }
                else {
                    titleLabel.frame = CGRect(x: iconImageView.right + 8, y: 15, width: contentView.width - 28, height: 40)
                }
            }
            else {
                actionButton.isHidden = false
                actionButton.frame = CGRect(x: contentView.frame.width - 90 - 15, y: 16, width: 90, height: 32)
                titleLabel.frame = CGRect(x: iconImageView.right + 8, y: 15, width: actionButton.left - iconImageView.right - 28, height: 40)
            }
        }
        else {
            if user.isUsersAvatarReal() , let id_photo = user.id_photo, id_photo.status == 2 {
                userIconImageView.isHidden = false;                
                userIconImageView.frame = CGRect(x: contentView.frame.width - 40 - 15, y: 16, width: 40, height: 60)
                titleLabel.frame = CGRect(x: iconImageView.right + 8, y: 15, width: userIconImageView.left - iconImageView.right - 28, height: 40)
            }
            else {
                titleLabel.frame = CGRect(x: iconImageView.right + 8, y: 16, width: contentView.width - iconImageView.right - 28, height: 40)
            }
        }
    }
}
