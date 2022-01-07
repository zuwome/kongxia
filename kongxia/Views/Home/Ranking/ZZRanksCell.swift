//
//  ZZRanksCell.swift
//  zuwome
//
//  Created by qiming xiao on 2019/5/23.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

enum RanksType {
    case wealth
    case popularity
    case rookie
}

protocol ZZRanksCellDelegate: NSObjectProtocol {
    func showUserInfo(rankModel: ZZRankModel?)
    func chat(rankModel: ZZRankModel?)
}

class ZZRanksCell: ZZTableViewCell {
    
    lazy var placeView: PlaceView = {
        let view = PlaceView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(showUser))
        view.userIconImageView.addGestureRecognizer(tap)
        view.delegate = self
        return view
    }()
    
    lazy var seperateLine: UIView = {
        let view = UIView()
        view.backgroundColor = rgbColor(237, 237, 237)
        return view
    }()
    
    weak var delegate: ZZRanksCellDelegate?
    
    var rankModel: ZZRankModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(rank: ZZRankModel?, ranking: Int) {
        rank?.ranking = "\(ranking)"
        rankModel = rank
        placeView.configure(rank: rank, isMine: false, shouldShowTips: true)
    }
    
    func configure(rank: ZZRankModel?) {
        rankModel = rank
        placeView.configure(rank: rank, isMine: false, shouldShowTips: true)
    }
    func configure(rank: ZZRankModel?, isMine: Bool)  {
        rankModel = rank
        placeView.configure(rank: rank, isMine: isMine, shouldShowTips: false)
    }
}

// MARK: Respone
extension ZZRanksCell {
    @objc func showUser() {
        if let showValue: Int = rankModel?.rank_show?.intValue, showValue == -1 {
            delegate?.showUserInfo(rankModel: rankModel)
        }
    }
}

// MARK: PlaceViewDelegate
extension ZZRanksCell: PlaceViewDelegate {
    func chat(view: PlaceView, rank: ZZRankModel?) {
        delegate?.chat(rankModel: rank)
    }
    
    func hideOrShow(view: PlaceView, rank: ZZRankModel?) {
        
    }
}

// MARK: Layout
extension ZZRanksCell {
    func layout() {
        self.contentView.addSubview(placeView)
        self.contentView.addSubview(seperateLine)
        
        placeView.mas_makeConstraints { (make) in
            make?.edges.equalTo()(self)
        }
        
        seperateLine.mas_makeConstraints { (make) in
            make?.bottom.equalTo()(self)
            make?.left.equalTo()(self)?.offset()(15)
            make?.right.equalTo()(self)?.offset()(-15)
            make?.height.equalTo()(0.5)
        }
    }
}

protocol PlaceViewDelegate: NSObjectProtocol {
    func chat(view: PlaceView, rank: ZZRankModel?);
    func hideOrShow(view: PlaceView, rank: ZZRankModel?);
}

class PlaceView: UIView {
    lazy var ranksLabel: UILabel = {
        let label = UILabel()
        label.text = "9999"
        label.textColor = rgbColor(153, 153, 153)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    lazy var userIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_placeholder")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = rgbColor(63, 58, 58)
        label.text = "虚位以待"
        return label
    }()
    
    lazy var genderImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var verifyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_identifier")
        return imageView
    }()
    
    lazy var levelImageView: ZZLevelImgView = {
        let imageView = ZZLevelImgView()
        
        return imageView
    }()
    
    lazy var pointsLabel: UILabel = {
        let label = UILabel()
        label.textColor = rgbColor(153, 153, 153)
        label.text = "壕力值"
        label.font = UIFont.systemFont(ofSize: 13.0)
        return label
    }()
    
    lazy var actionBtn: UIButton = {
        let btn = UIButton()
        btn.normalTitle = "私信"
        btn.normalTitleColor = rgbColor(63, 58, 58)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        btn.layer.cornerRadius = 13
        btn.layer.borderColor = rgbColor(102, 102, 102).cgColor
        btn.layer.borderWidth = 1
        
        btn.addTarget(self, action: #selector(actions), for: .touchUpInside)
        return btn
    }()
    
    lazy var invisiableLabel: UILabel = {
        let label = UILabel()
        label.text = "隐榜潜水中"
        label.font = font(13.0)
        label.textAlignment = .center
        label.textColor = rgbColor(102, 102, 102)
        label.isHidden = true
        return label
    }()
    
    lazy var indicatorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "invalidName11")
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var rankingStatusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil
        return imageView
    }()
    
    var isMine: Bool = false
    
    var rank: ZZRankModel?
    
    weak var delegate: PlaceViewDelegate?
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .white
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(rank: ZZRankModel?, isMine: Bool, shouldShowTips: Bool, ranksType: RanksType = .wealth) {
        self.isMine = isMine
        self.rank = rank
        
        guard let rankModel = rank else {
            return
        }
        
        // 头像
        userIconImageView.sd_setImage(with: URL(string: rankModel.userInfo?.displayAvatar() ?? "")) { (image, error, cacheType, url) in
            let corneredImage = image?.imageAddCorner(withRadius: 50 / 2, andSize: CGSize(width: 50, height: 50))
            self.userIconImageView.image = corneredImage
        }
        
        // 名字
        userNameLabel.text = rankModel.userInfo?.nickname
        
        var maxWidth = screenWidth - userIconImageView.right - 8 - 9 - 60
        maxWidth -= isMine ? 112 : 86
        maxWidth -= 5
        
        if rankModel.nameWidth == -1 {
            rankModel.nameWidth = NSString.findWidth(forText: userNameLabel.text, havingWidth: maxWidth, andFont: userNameLabel.font)
        }
        let nameWidth: CGFloat = rankModel.nameWidth
        userNameLabel.width = nameWidth
        
        var leftView: UIView = userNameLabel
        
        // 性别
        if rankModel.userInfo?.gender == 2 || rankModel.userInfo?.gender == 1 {
            genderImageView.isHidden = false
            genderImageView.image = UIImage(named: rankModel.userInfo?.gender == 2 ? "girl" : "boy")
            genderImageView.left = leftView.right + 3
            leftView = genderImageView
        }
        else {
            genderImageView.isHidden = true
        }
        
        // 认证
        if let isCertificated = rankModel.userInfo?.isIdentifierCertified(), isCertificated {
            verifyImageView.isHidden = false
            verifyImageView.left = leftView.right + 3
            leftView = verifyImageView
        }
        else {
            verifyImageView.isHidden = true
        }
        
        // 等级
        levelImageView.setLevel(rankModel.userInfo?.level ?? 0)
        if let show = rankModel.rank_show?.intValue, show == -1 {
            levelImageView.isHidden = false
            levelImageView.left = leftView.right + 3
            leftView = levelImageView
        }
        else {
            levelImageView.isHidden = true
        }
        
        
        // 上升下降
        if rankModel.is_up?.intValue == 1 {
            rankingStatusImageView.image = UIImage(named: "icUp")
        }
        else if rankModel.is_up?.intValue == -1 {
            rankingStatusImageView.image = UIImage(named: "icDown")
        }
        else if rankModel.is_up?.intValue == 0 {
            rankingStatusImageView.image = nil
        }
        
        if ranksType == .wealth {
            layoutAndConfigForWealth(rankModel: rankModel, isMine: isMine, shouldShowTips: shouldShowTips)
        }
        
    }
}

// MARK: placeView Button Actions
extension PlaceView {
    @objc func actions() {
        if !isMine {
            if rank?.userInfo?.uid == ZZUserHelper.shareInstance()?.loginer.uid {
                // 隐榜/显示
                delegate?.hideOrShow(view: self, rank: rank)
            }
            else {
                delegate?.chat(view: self, rank: rank)
            }
        }
        else {
            delegate?.hideOrShow(view: self, rank: rank)
        }
    }
}

// MARK: Layout
extension PlaceView {
    func layout() {
        self.backgroundColor = .white
        self.addSubview(ranksLabel)
        self.addSubview(userIconImageView)
        self.addSubview(userNameLabel)
        self.addSubview(genderImageView)
        self.addSubview(verifyImageView)
        self.addSubview(levelImageView)
        self.addSubview(pointsLabel)
        self.addSubview(rankingStatusImageView)
        self.addSubview(actionBtn)
        self.addSubview(invisiableLabel)
        self.addSubview(indicatorImageView)
        
        let viewHeight = 80.0
        
        ranksLabel.frame = CGRect(x: 0.0, y: 0.0, width: 58, height: viewHeight)
        userIconImageView.frame = CGRect(x: Double(ranksLabel.right),
                                         y: Double(viewHeight / 2 - 50 / 2),
                                         width: 50.0,
                                         height: 50.0)
        
        userNameLabel.frame = CGRect(x: userIconImageView.right + 8,
                                     y: userIconImageView.top + 3.5,
                                     width: 100.0,
                                     height: userNameLabel.font.lineHeight)
        
        genderImageView.frame = CGRect(x: userNameLabel.right + 3,
                                       y: userNameLabel.height * 0.5 - 12.5 / 2 + userNameLabel.top,
                                       width: 12.5,
                                       height: 12.5)
        
        verifyImageView.frame = CGRect(x: genderImageView.right + 3,
                                       y: userNameLabel.height * 0.5 - 14 / 2 + userNameLabel.top,
                                       width: 19,
                                       height: 14)
        
        levelImageView.frame = CGRect(x: verifyImageView.right + 3,
                                      y: userNameLabel.height * 0.5 - 14 / 2 + userNameLabel.top,
                                      width: 28,
                                      height: 14)
        
        pointsLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(userIconImageView.mas_right)?.equalTo()(8)
            make?.bottom.equalTo()(userIconImageView)?.equalTo()(-1)
        }

        rankingStatusImageView.mas_remakeConstraints { (make) in
            make?.centerY.equalTo()(pointsLabel)
            make?.left.equalTo()(pointsLabel.mas_right)?.equalTo()(8)
        }

        actionBtn.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(self)
            make?.size.mas_equalTo()(CGSize(width: 71, height: 26))
            make?.right.equalTo()(self)?.offset()(-15)
        }

        invisiableLabel.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(self)
            make?.right.equalTo()(self)?.offset()(-15)
        }

        indicatorImageView.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(self)
            make?.right.equalTo()(self)?.offset()(-15)
            make?.size.mas_equalTo()(CGSize(width: 6, height: 11.5))
        }
    }
    
    func layoutAndConfigForWealth(rankModel: ZZRankModel, isMine: Bool, shouldShowTips: Bool) {
        if isMine {
            // 底部自己的排名
            actionBtn.mas_updateConstraints { (make) in
                make?.right.equalTo()(self)?.offset()(-41)
            }

            invisiableLabel.mas_updateConstraints { (make) in
                make?.right.equalTo()(self)?.offset()(-41)
            }
            
            if let aggregate = rankModel.aggregate, let ranking = rankModel.ranking  {
                ranksLabel.text = ranking
                
                let points = NSDecimalNumber(string: aggregate.totalPrice);
                pointsLabel.text = "壕力值:\(points)"
                
                if let show = rankModel.rank_show?.intValue, show == -1 {
                    actionBtn.normalTitle = "我要隐榜"
                    actionBtn.backgroundColor = rgbColor(244, 203, 7)
                    actionBtn.layer.borderWidth = 0
                }
                else {
                    actionBtn.normalTitle = "取消隐榜"
                    actionBtn.backgroundColor = rgbColor(244, 203, 7)
                    actionBtn.layer.borderWidth = 0
                }
                
                invisiableLabel.isHidden = true
                actionBtn.isHidden = false
                rankingStatusImageView.isHidden = false
            }
            else {
                ranksLabel.text = "未上榜"
                pointsLabel.text = "消费一元可上榜"
                invisiableLabel.text = "冲榜小攻略"
                invisiableLabel.textColor = rgbColor(63, 58, 58)
                invisiableLabel.font = font(12)
                
                invisiableLabel.isHidden = false
                actionBtn.isHidden = true
                rankingStatusImageView.isHidden = true
            }
            
            if shouldShowTips {
                self.layer.shadowColor = rgbColor(170, 170, 170).cgColor
                self.layer.shadowOffset = CGSize(width: 0, height: -10)
                self.layer.shadowRadius = 5
                self.layer.shadowOpacity = 0.8;
                
                indicatorImageView.isHidden = false
            }
            else {
                indicatorImageView.isHidden = true
                invisiableLabel.isHidden = true
                actionBtn.isHidden = true
            }
        }
        else {
            // 列表的排名
            actionBtn.mas_updateConstraints { (make) in
                make?.right.equalTo()(self)?.offset()(-15)
            }
            
            invisiableLabel.mas_updateConstraints { (make) in
                make?.right.equalTo()(self)?.offset()(-15)
            }
            
            indicatorImageView.isHidden = true
            
            // 排名
            let rankInt: Int = Int(rankModel.ranking ?? "0") ?? 0
            if rankInt > 0 && rankInt <= 10 {
                ranksLabel.font = UIFont(name: "Alibaba-PuHuiTi-B", size: 21)
                ranksLabel.textColor = hexColor("#A76EFA")
            }
            else {
                ranksLabel.textColor = rgbColor(153, 153, 153)
                ranksLabel.font = UIFont.boldSystemFont(ofSize: 16)
            }
            ranksLabel.text = String(format: "%02d", rankInt)
            
            // 壕力值
            let points = NSDecimalNumber(string: rankModel.aggregate?.totalPrice);
            pointsLabel.text = "壕力值:\(points)"
            
            // 私信和隐榜label
            invisiableLabel.text = "隐榜潜水中"
            if rankModel.userInfo?.uid == ZZUserHelper.shareInstance()?.loginer.uid {
                invisiableLabel.isHidden = true
                actionBtn.isHidden = true
                if let show = rankModel.rank_show?.intValue, show == -1 {
                    
                }
                else {
                    invisiableLabel.isHidden = false
                }
            }
            else {
                if let show = rankModel.rank_show?.intValue, show == -1 {
                    invisiableLabel.isHidden = true
                    actionBtn.isHidden = false
                }
                else {
                    invisiableLabel.isHidden = false
                    actionBtn.isHidden = true
                }
            }
        }
    }
}
