//
//  ZZRankingTopThreeView.swift
//  zuwome
//
//  Created by qiming xiao on 2019/5/23.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

protocol ZZRankingTopThreeViewDelegate: NSObjectProtocol {
    func showUserInfo(rankModel: ZZRankModel?)
    func chat(view: ZZRankingTopThreeView, rankModel: ZZRankModel?)
}

class ZZRankingTopThreeView: UIView {

    lazy var rankingImageView: UIImageView = {
        let imageView = UIImageView()
        var crown: String = ""
        if self.place == 1 {
            crown = "rank-1"
        }
        else if self.place == 2 {
            crown = "rank-2"
        }
        else {
            crown = "rank-3"
        }
        imageView.image = UIImage(named: crown)
        return imageView
    }()
    
    lazy var userIconImageView: UIImageView = {
        let imageView = UIImageView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(showUser))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "icon_placeholder")
        return imageView
    }()
    
    lazy var ranksImageView: UIImageView = {
        let imageView = UIImageView()
        var placed: String = ""
        if self.place == 1 {
            placed = "place-1"
        }
        else if self.place == 2 {
            placed = "place-2"
        }
        else {
            placed = "place-3"
        }
        imageView.image = UIImage(named: placed)
        return imageView
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.rgbColor(63, 58, 58)
        label.text = "虚位以待"
        label.textAlignment = .center
        return label
    }()
    
    lazy var levelImageView: ZZLevelImgView = {
        let imageView = ZZLevelImgView()
        return imageView
    }()
    
    lazy var pointsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgbColor(63, 58, 58, 0.9)
        label.text = "壕力值"
        label.font = UIFont.systemFont(ofSize: 11.0)
        label.textAlignment = .center
        return label
    }()
    
    lazy var rankingStatusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var invisiableLabel: UILabel = {
        let label = UILabel()
        label.text = "隐榜潜水中"
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textColor = UIColor.rgbColor(63, 58, 58)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    lazy var chatBtn: UIButton = {
        let btn = UIButton()
        btn.normalTitle = "私信"
        btn.normalTitleColor = UIColor.rgbColor(63, 58, 58)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        btn.layer.cornerRadius = 16
        btn.layer.borderColor = UIColor.rgbColor(63, 58, 58).cgColor
        btn.layer.borderWidth = 1
        btn.addTarget(self, action: #selector(chat), for: .touchUpInside)
        return btn
    }()
    
    let place: Int
    
    var rankModel: ZZRankModel?
    
    lazy var maxNameWidth: CGFloat = {
        return NSString.findWidth(forText: "哈哈哈哈哈", havingWidth: 110, andFont: self.userNameLabel.font) + 5
    }()
    
    weak var delegate: ZZRankingTopThreeViewDelegate?
    
    init(place: Int) {
        self.place = place
        super.init(frame: CGRect.zero)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureData(rankModel: ZZRankModel?) {
        guard let rank = rankModel else {
            return
        }
        self.rankModel = rankModel
        
        // 头像
        let userIconWidth: CGFloat = self.place == 1 ? 80 : 70
        userIconImageView.sd_setImage(with: URL(string: rank.userInfo?.displayAvatar() ?? "")) { (image, error, cacheType, url) in
            let corneredImage = image?.imageAddCorner(withRadius: userIconWidth / 2, andSize: CGSize(width: userIconWidth, height: userIconWidth))
            self.userIconImageView.image = corneredImage
        }
        
        var nameLabelWidth: CGFloat = 0
        let nameWidth = NSString.findWidth(forText: rank.userInfo?.nickname, havingWidth: 110, andFont: self.userNameLabel.font)
        nameLabelWidth = nameWidth > maxNameWidth ? maxNameWidth : nameWidth
        
        userNameLabel.frame = CGRect(x: 110 * 0.5 - nameLabelWidth * 0.5 - 13, y: userIconImageView.bottom + 25.0, width: nameLabelWidth, height: userNameLabel.font.lineHeight)
        levelImageView.left = userNameLabel.right + 6;
        
        // 名字
        userNameLabel.text = rank.userInfo?.nickname
        
        // 等级
        levelImageView.setLevel(rank.userInfo?.level ?? 0)
        if let show = rank.rank_show?.intValue, show == -1 {
            levelImageView.isHidden = false
        }
        else {
            levelImageView.isHidden = true
            userNameLabel.frame = CGRect(x: 0.0, y: userIconImageView.bottom + 25.0, width: self.width, height: userNameLabel.font.lineHeight)
        }
        
        // 豪力值
        let points = NSDecimalNumber(string: rank.aggregate?.totalPrice);
        pointsLabel.text = "壕力值:\(points)"
        let width = NSString.findWidth(forText: pointsLabel.text, havingWidth: 110, andFont: pointsLabel.font)
        pointsLabel.frame = CGRect(x: 110 * 0.5 - width * 0.5, y: userNameLabel.bottom + 5, width: width, height: pointsLabel.font.lineHeight)
        
        // 私信和隐榜label
        if let show = rank.rank_show?.intValue, show == -1 {
            invisiableLabel.isHidden = true
            if rank.userInfo?.uid != ZZUserHelper.shareInstance()?.loginer.uid {
                chatBtn.isHidden = false
            }
            else {
                chatBtn.isHidden = true
            }
        }
        else {
            invisiableLabel.isHidden = false
            chatBtn.isHidden = true
        }
        
        // 排行
        rankingStatusImageView.isHidden = false
        if rank.is_up?.intValue == 1 {
            rankingStatusImageView.image = UIImage(named: "icUp")
        }
        else if rank.is_up?.intValue == -1 {
            rankingStatusImageView.image = UIImage(named: "icDown")
        }
        else if rank.is_up?.intValue == 0 {
            rankingStatusImageView.image = nil
        }
    }
}

// MARK: Respone
extension ZZRankingTopThreeView {
    @objc func showUser() {
        if let showValue: Int = rankModel?.rank_show?.intValue, showValue == -1 {
            delegate?.showUserInfo(rankModel: rankModel)
        }
    }
    
    @objc func chat() {
        delegate?.chat(view: self, rankModel: rankModel)
    }
}

// MARK: Layout
extension ZZRankingTopThreeView {
    func layout() {
        self.addSubview(userIconImageView)
        self.addSubview(rankingImageView)
        self.addSubview(ranksImageView)
        self.addSubview(userNameLabel)
        self.addSubview(levelImageView)
        self.addSubview(pointsLabel)
        self.addSubview(rankingStatusImageView)
        self.addSubview(chatBtn)
        self.addSubview(invisiableLabel)
        
        var crownSize: CGSize = CGSize(width: 0, height: 0)
        var userIconSize: CGSize = CGSize(width: 0, height: 0)
        var placeSize: CGSize = CGSize(width: 0, height: 0)
        
        if place == 1 {
            crownSize = CGSize(width: 39, height: 31)
            userIconSize = CGSize(width: 86, height: 86)
            placeSize = CGSize(width: 23, height: 23)
        }
        else {
            crownSize = CGSize(width: 36, height: 29)
            userIconSize = CGSize(width: 76, height: 76)
            placeSize = CGSize(width: 21.5, height: 21.5)
        }
        
        userIconImageView.frame = CGRect(x: 110 / 2 - userIconSize.width / 2, y: 27.0, width: userIconSize.width, height: userIconSize.height)
        
        if place == 3 {
            rankingImageView.mas_makeConstraints { (make) in
                make?.right.equalTo()(userIconImageView)?.offset()(-5.4)
                make?.bottom.equalTo()(userIconImageView.mas_top)?.offset()(9)
                make?.size.mas_equalTo()(crownSize)
            }
        }
        else {
            rankingImageView.mas_makeConstraints { (make) in
                make?.left.equalTo()(userIconImageView)?.offset()(5)
                make?.bottom.equalTo()(userIconImageView.mas_top)?.offset()(9)
                make?.size.mas_equalTo()(crownSize)
            }
        }
        
        ranksImageView.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(userIconImageView)
            make?.centerY.equalTo()(userIconImageView.mas_bottom)
            make?.size.mas_equalTo()(placeSize)
        }
        
        userIconImageView.layer.cornerRadius = userIconSize.width / 2
        var color = UIColor.rgbColor(255, 198, 66)
        if place == 1 {
            color = UIColor.rgbColor(255, 198, 66)
        }
        else if place == 2 {
            color = UIColor.rgbColor(184, 196, 255)
        }
        else if place == 3 {
            color = UIColor.rgbColor(255, 186, 146)
        }
        userIconImageView.layer.borderColor = color.cgColor
        userIconImageView.layer.borderWidth = 3
        
        userNameLabel.frame = CGRect(x: 0.0, y: userIconImageView.bottom + 25.0, width: 110, height: userNameLabel.font.lineHeight)
        
        levelImageView.frame = CGRect(x: userNameLabel.right + 6, y: userNameLabel.height * 0.5 + userNameLabel.top - 7, width: 28, height: 14)
        
        pointsLabel.frame = CGRect(x: 0.0, y: userNameLabel.bottom + 5, width: 110, height: pointsLabel.font.lineHeight)
        
        rankingStatusImageView.mas_remakeConstraints { (make) in
            make?.centerY.equalTo()(pointsLabel)
            make?.left.equalTo()(pointsLabel.mas_right)?.equalTo()(4)
        }
        
        chatBtn.frame = CGRect(x: 110 / 2 - 81 / 2, y: pointsLabel.bottom + 20, width: 81, height: 31)
        invisiableLabel.frame = CGRect(x: 0, y: pointsLabel.bottom + 20, width: 110, height: invisiableLabel.font.lineHeight)
    }
}
