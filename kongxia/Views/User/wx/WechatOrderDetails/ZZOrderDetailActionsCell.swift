//
//  ZZOrderDetailActionsCell.swift
//  zuwome
//
//  Created by qiming xiao on 2019/3/1.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

protocol ZZOrderDetailActionsCellDelegate: NSObjectProtocol {
    func chat(cell: ZZOrderDetailActionsCell)
    func confirm(cell: ZZOrderDetailActionsCell)
    func report(cell: ZZOrderDetailActionsCell)
    func review(cell: ZZOrderDetailActionsCell)
}

class ZZOrderDetailActionsCell: ZZTableViewCell {
    weak var delegate: ZZOrderDetailActionsCellDelegate?
    weak var tableView: UITableView?
    var type: Int = 0
    var status: WxOrderStatus = .none
    
    lazy var chatBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("私信", for: .normal)
        btn.setTitleColor(zzBlackColor, for: .normal)
        btn.titleLabel?.font = sysFont(15.0)
        btn.addTarget(self, action: #selector(chat), for: .touchUpInside)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 1.5
        return btn
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("确认添加成功", for: .normal)
        btn.setTitleColor(zzBlackColor, for: .normal)
        btn.titleLabel?.font = sysFont(15.0)
        btn.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        btn.backgroundColor = zzGoldenColor
        btn.layer.cornerRadius = 1.5
        return btn
    }()
    
    lazy var reportLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "微信号无法添加？立即举报", attributes: [
            .font: UIFont(name: "PingFang-SC-Regular", size: 14.0)!,
            .foregroundColor: UIColor(red: 63.0 / 255.0, green: 58.0 / 255.0, blue: 58.0 / 255.0, alpha: 1.0),
            .kern: 0.0
            ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 74.0 / 255.0, green: 144.0 / 255.0, blue: 226.0 / 255.0, alpha: 1.0), range: NSRange(location: 8, length: 4))
        label.attributedText = attributedString
        
        label.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(report));
        label.addGestureRecognizer(tap)
        return label
    }()
    
    lazy var evaluationBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("匿名评价", for: .normal)
        btn.setTitleColor(zzBlackColor, for: .normal)
        btn.titleLabel?.font = sysFont(15.0)
        btn.addTarget(self, action: #selector(evaluation), for: .touchUpInside)
        btn.backgroundColor = zzGoldenColor
        btn.layer.cornerRadius = 25
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConfigure(_ orderStatus: WxOrderStatus) {
        self.status = orderStatus
        self.backgroundColor = .white
        if status == .buyer_bought
            || status == .buyer_waitToBeEvaluated {
            self.backgroundColor = hexColor("#f6f6f6")
            chatBtn.layer.cornerRadius = 1.5
            confirmBtn.layer.cornerRadius = 1.5
        }
        else if status == .buyer_confirm
            || status == .seller_complete
            || status == .seller_autoComplete
            || status == .seller_waitToBeEvaluated
            || status == .buyer_reportSuccess
            || status == .buyer_reportFail
            || status == .seller_reportSuccess
            || status == .seller_reportFail {
            self.backgroundColor = hexColor("#f6f6f6")
            chatBtn.layer.cornerRadius = 25
            chatBtn.backgroundColor = zzGoldenColor
        }
        else if status == .buyer_commented {
            evaluationBtn.isUserInteractionEnabled = false;
            evaluationBtn.setTitle("已评价", for: .normal)
            evaluationBtn.backgroundColor = rgbColor(223, 223, 223)
        }
        createLayout()
    }
    
    func didHasComment(_ didHave: Bool) {
        evaluationBtn.setTitle(didHave ? "已评价" : "未评价", for: .normal)
    }
    
    @objc func chat() {
        delegate?.chat(cell: self)
    }
    
    @objc func confirm() {
        delegate?.confirm(cell: self)
    }
    
    @objc func report() {
        delegate?.report(cell: self)
    }
    
    @objc func evaluation() {
        delegate?.review(cell: self)
    }
    
}

// MARK: Layout
extension ZZOrderDetailActionsCell {
    func layout() {
//        self.backgroundColor = hexColor("#f6f6f6")
        self.addSubview(chatBtn)
        self.addSubview(confirmBtn)
        self.addSubview(reportLabel)
        self.addSubview(evaluationBtn)
    }
    
    func createLayout() {
        chatBtn.isHidden = true
        confirmBtn.isHidden = true
        reportLabel.isHidden = true
        evaluationBtn.isHidden = true
        
        if status == .buyer_bought
            || status == .buyer_waitToBeEvaluated {
            chatBtn.isHidden = false
            confirmBtn.isHidden = false
            reportLabel.isHidden = false
            
            let btnOffset: CGFloat = 15.0
            let btnWidth = (screenWidth - 8.0 * 2 - btnOffset) * 0.5
            chatBtn.mas_makeConstraints { (make) in
                make?.left.equalTo()(self)?.offset()(8.0)
                make?.top.equalTo()(self)?.offset()(5.0)
                make?.size.mas_equalTo()(CGSize(width: btnWidth, height: 50.0))
            }
            
            confirmBtn.mas_makeConstraints { (make) in
                make?.left.equalTo()(chatBtn.mas_right)?.offset()(btnOffset)
                make?.top.equalTo()(self)?.offset()(5.0)
                make?.size.mas_equalTo()(CGSize(width: btnWidth, height: 50.0))
            }
            
            reportLabel.mas_makeConstraints { (make) in
                make?.centerX.equalTo()(self)
                make?.top.equalTo()(chatBtn.mas_bottom)?.offset()(10.0)
                make?.bottom.equalTo()(self)?.offset()(-5.0)
            }
        }
        else if status == .seller_complete
            || status == .seller_autoComplete
            || status == .seller_waitToBeEvaluated
            || status == .buyer_reportSuccess
            || status == .buyer_reportFail
            || status == .seller_reportSuccess
            || status == .seller_reportFail {
            chatBtn.isHidden = false
            chatBtn.mas_makeConstraints { (make) in
                make?.left.equalTo()(self)?.offset()(15.0)
                make?.right.equalTo()(self)?.offset()(-15.0)
                make?.top.equalTo()(self)?.offset()(5.0)
                make?.bottom.equalTo()(self)?.offset()(-5.0)
                make?.height.equalTo()(50.0)
            }
        }
        else if status == .buyer_confirm
            || status == .buyer_commented {

            var offset: CGFloat = 5
            if let rectInTable = tableView?.rectForRow(at: IndexPath(row: 0, section: 1)) {
                if let rect = tableView?.convert(rectInTable, to: tableView?.superview) {
                    let previousCellBottom: CGFloat = rect.origin.y + rect.size.height
                    let gap: CGFloat = screenHeight - previousCellBottom - tabbarHeight - 50 - 34
                    offset = gap <= 0 ? 5 :  gap
                }
            }
            self.backgroundColor = .white
            evaluationBtn.isHidden = false
            evaluationBtn.mas_remakeConstraints { (make) in
                make?.left.equalTo()(self)?.offset()(15.0)
                make?.right.equalTo()(self)?.offset()(-15.0)
                make?.top.equalTo()(self)?.offset()(offset)
                
                if offset == 5 {
                    make?.bottom.equalTo()(self)?.offset()(-5.0)
                }
                else {
                    make?.bottom.equalTo()(self)?.offset()(-5.0 - screenSafeAreaBottomHeight)
                }

                make?.height.equalTo()(50.0)
            }
        }
    }
}
