//
//  ZZOrderEvaluationCell.swift
//  zuwome
//
//  Created by qiming xiao on 2019/3/7.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

protocol ZZOrderEvaluationCellDelegate: NSObjectProtocol {
    func chooseGoodOrBad(cell:ZZOrderEvaluationCell,  isGood: Bool)
    
    func chooseBadReview(cell:ZZOrderEvaluationCell,  review: [String])
}

class ZZOrderEvaluationCell: ZZTableViewCell {
    weak var delegate: ZZOrderEvaluationCellDelegate?
    var badReviewBtns: [UIButton] = []
    var badReviewArray: [String] = ["不回消息", "资料不符", "微商", "诈骗"]
    var orderStatus: WxOrderStatus = .buyer_confirm;
    var selectBadReviews: [String] = [String]()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(text: "微信评价",
                            font: UIFont(name: "PingFang-SC-Medium", size: 17.0) ?? UIFont.systemFont(ofSize: 17.0),
                            textColor: .zzBlack)
        label.textAlignment = .center
        return label
    }()
    
    lazy var goodBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "icHp"), for: .normal)
        btn.setImage(UIImage(named: "icXzhp"), for: .selected)
        btn.addTarget(self, action: #selector(selectGood(btn:)), for: .touchUpInside)
//        btn.backgroundColor = randomColor()
        return btn
    }()
    
    lazy var badBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "icCp"), for: .normal)
        btn.setImage(UIImage(named: "icXzcp"), for: .selected)
        btn.addTarget(self, action: #selector(selectBad(btn:)), for: .touchUpInside)
//        btn.backgroundColor = randomColor()
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        createBadReviewViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    @objc func selectGood(btn: UIButton) {
        if self.orderStatus != .buyer_confirm {
            return
        }
        if btn.isSelected {
            return
        }
        btn.isSelected = !btn.isSelected
        badBtn.isSelected = false
        
        for btn in badReviewBtns {
            btn.isHidden = true
        }
        delegate?.chooseGoodOrBad(cell: self, isGood: true)
    }
    
    @objc func selectBad(btn: UIButton) {
        if self.orderStatus != .buyer_confirm {
            return
        }
        
        if btn.isSelected {
            return
        }
        btn.isSelected = !btn.isSelected
        goodBtn.isSelected = false
        
        for btn in badReviewBtns {
            btn.isHidden = false
        }
        
        delegate?.chooseGoodOrBad(cell: self, isGood: false)
    }
    
    @objc func selectReview(btn: UIButton) {
        if self.orderStatus != .buyer_confirm {
            return
        }
        
        let selected = badReviewArray[btn.tag]
        
        if selectBadReviews.contains(selected) {
            if let index = selectBadReviews.firstIndex(of: selected) {
                selectBadReviews.remove(at: index)
            }
        }
        else {
            selectBadReviews.append(selected)
        }
        
        delegate?.chooseBadReview(cell: self, review: selectBadReviews)
        
        for button in badReviewBtns {
            let string = button.title(for: .normal)
            button.isSelected = selectBadReviews.contains(string ?? "")
            if button.isSelected {
                button.layer.borderColor = UIColor.rgbColor(254, 66, 70).cgColor
            }
            else {
                button.layer.borderColor = UIColor.rgbColor(216, 216, 216).cgColor
            }
        }
    }
    
    func evaluatedContent(commmentModel: ZZWxOrderCommentModel?, orderStatus: WxOrderStatus) {
        self.orderStatus = orderStatus
        
        guard let commmentModel = commmentModel  else {
            return
        }
        if commmentModel.score == 1 {
            badBtn.isSelected = true
            goodBtn.isSelected = false
            
            var commentArray = [String]()
            if let commentStr = commmentModel.content?[0] as? String {
                commentArray = try! JSONSerialization.jsonObject(with: commentStr.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, options: .allowFragments) as! [String]
            }
            
            for btn in badReviewBtns {
                btn.isHidden = false
                
                if commentArray.contains(btn.title(for: .normal) ?? "") {
                    btn.isSelected = true
                    btn.layer.borderColor = UIColor.rgbColor(254, 66, 70).cgColor
                }
                else {
                    btn.isSelected = false
                    btn.layer.borderColor = UIColor.rgbColor(216, 216, 216).cgColor
                }
                
            }
        }
        else {
            goodBtn.isSelected = true
            badBtn.isSelected = false
            
            for btn in badReviewBtns {
                btn.isHidden = true
            }
            delegate?.chooseGoodOrBad(cell: self, isGood: true)
        }
    }
}

// MARK: Layout
extension ZZOrderEvaluationCell {
    func layout() {
        self.addSubview(titleLabel)
        self.addSubview(goodBtn)
        self.addSubview(badBtn)
        
        titleLabel.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(self)
            make?.top.equalTo()(self)?.offset()(34.0)
        }
        
        goodBtn.mas_makeConstraints { (make) in
            make?.right.equalTo()(titleLabel.mas_left)
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(27)
            make?.size.mas_equalTo()(CGSize(width: 42, height: 65.5))
        }
        
        badBtn.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(goodBtn)
            make?.left.equalTo()(titleLabel.mas_right)
            make?.size.mas_equalTo()(CGSize(width: 42, height: 65.5))
        }
    }
    
    func createBadReviewViews() {
        for (index, badReview) in badReviewArray.enumerated() {
            let button = UIButton()
            button.setTitle(badReview, for: .normal)
            button.setTitleColor(.zzBlack, for: .normal)
            button.setTitleColor(UIColor.rgbColor(254, 66, 70), for: .selected)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
            button.tag = index
            button.addTarget(self, action: #selector(selectReview(btn:)), for: .touchUpInside)
            button.isHidden = true
            button.layer.borderWidth = 1.0
            button.layer.cornerRadius = 3.0
            button.layer.borderColor = UIColor.rgbColor(216, 216, 216).cgColor
            
            self.addSubview(button)
            
            let width: Int = 90
            let height: Int = 30
            let offsetY: Int = 16
            let offsetButtonY: Int = 18
            
            let toTop: CGFloat = CGFloat(offsetY + (height + offsetButtonY) * (index / 2))
            button.mas_makeConstraints { (make) in
                
                let view = index % 2 == 0 ? goodBtn : badBtn
                make?.size.mas_equalTo()(CGSize(width: width, height: height))
                make?.centerX.equalTo()(view)
                make?.top.equalTo()(goodBtn.mas_bottom)?.offset()(toTop)
                
                if index == badReviewArray.count - 1 {
                    make?.bottom.equalTo()(self)?.offset()(-42.0)
                }
            }
            
            badReviewBtns.append(button)
        }
    }
}
