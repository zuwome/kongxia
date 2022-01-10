//
//  ZZRankingTopsView.swift
//  zuwome
//
//  Created by qiming xiao on 2019/5/23.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

protocol ZZRankingTopsHeaderViewDelegate: NSObjectProtocol {
    func showRankUserInfo(rankModel: ZZRankModel?)
    func chat(view: ZZRankingTopsHeaderView, rankModel: ZZRankModel?)
}

class ZZRankingTopsHeaderView: UIView {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "壕力值是您近期30天的消费行为所获得的分值，快来展示您强大的实力吧!"
        label.textAlignment = .center
        label.font = UIFont(name: "PingFangSC-Medium", size: 15)
        label.textColor = UIColor.rgbColor(63, 58, 58)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var firstPlace: ZZRankingTopThreeView = {
        let view = ZZRankingTopThreeView(place: 1)
        view.delegate = self
        return view
    }()
    
    lazy var secondPlace: ZZRankingTopThreeView = {
        let view = ZZRankingTopThreeView(place: 2)
        view.delegate = self
        return view
    }()
    
    lazy var thirdPlace: ZZRankingTopThreeView = {
        let view = ZZRankingTopThreeView(place: 3)
        view.delegate = self
        return view
    }()
    
    lazy var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    weak var delegate: ZZRankingTopsHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTopThree(topThree: [ZZRankModel]?) {
        guard let topThree = topThree else {
            return
        }
        
        for (index, rankModel) in topThree.enumerated() {
            if index == 0 {
                firstPlace.configureData(rankModel: rankModel)
            }
            else if index == 1 {
                secondPlace.configureData(rankModel: rankModel)
            }
            else if index == 2 {
                thirdPlace.configureData(rankModel: rankModel)
            }
        }
    }
}

// MARK: ZZRankingTopThreeViewDelegate
extension ZZRankingTopsHeaderView: ZZRankingTopThreeViewDelegate {
    func showUserInfo(rankModel: ZZRankModel?) {
        delegate?.showRankUserInfo(rankModel: rankModel)
    }
    
    func chat(view: ZZRankingTopThreeView, rankModel: ZZRankModel?) {
        delegate?.chat(view: self, rankModel: rankModel)
    }
}

// MARK: Layout
extension ZZRankingTopsHeaderView {
    func layout() {
        self.clipsToBounds = true
        self.addSubview(titleLabel)
        self.addSubview(firstPlace)
        self.addSubview(secondPlace)
        self.addSubview(thirdPlace)
        self.addSubview(coverView)
        
        titleLabel.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(self)
            make?.top.equalTo()(self)?.offset()(33)
            make?.left.equalTo()(self)?.offset()(30)
            make?.right.equalTo()(self)?.offset()(-30)
            make?.height.equalTo()(titleLabel.font.lineHeight * 2 + 2)
        }

        firstPlace.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(self)
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(45.5)
            make?.size.equalTo()(CGSize(width: 110, height: 230))
        }
        
        secondPlace.mas_makeConstraints { (make) in
            make?.right.equalTo()(firstPlace.mas_left)?.offset()(-15)
            make?.top.equalTo()(firstPlace)?.offset()(41)
            make?.size.equalTo()(CGSize(width: 110, height: 230))
        }
        
        thirdPlace.mas_makeConstraints { (make) in
            make?.left.equalTo()(firstPlace.mas_right)?.offset()(15)
            make?.top.equalTo()(firstPlace)?.offset()(41)
            make?.size.equalTo()(CGSize(width: 110, height: 230))
        }
        
        coverView.frame = CGRect(x: 0.0, y: self.height - 16, width: screenWidth, height: 32)
        coverView.layer.cornerRadius = 16
        
    }
}
