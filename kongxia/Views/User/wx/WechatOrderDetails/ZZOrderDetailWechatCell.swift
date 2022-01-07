//
//  ZZOrderDetailWechatCell.swift
//  zuwome
//
//  Created by qiming xiao on 2019/2/28.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

protocol ZZOrderDetailWechatCellDelegate: NSObjectProtocol {
    func pasteWeChat(view: ZZOrderDetailWechatCell)
}

class ZZOrderDetailWechatCell: ZZTableViewCell {
    weak var delegate: ZZOrderDetailWechatCellDelegate?
    lazy var weChatLabel: UILabel = {
        let label = UILabel(text: "Ta的微信号:XXXXXXX", font: UIFont.systemFont(ofSize: 15.0), textColor: .black)
        return label
    }()
    
    lazy var actionButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("复制", for: .normal)
        btn.setTitleColor(rgbColor(102, 102, 102), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        btn.layer.cornerRadius = 14.0
        btn.layer.borderColor = rgbColor(204, 204, 204).cgColor
        btn.layer.borderWidth = 1.0
        btn.addTarget(self, action: #selector(pasteWX), for: .touchUpInside)
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func pasteWX() {
        delegate?.pasteWeChat(view: self)
    }
    
    func wxNum(wxNum: String) {
        weChatLabel.text = "Ta的微信号:\(wxNum)"
    }
}

// MARK: Layout
extension ZZOrderDetailWechatCell {
    func layout() {
        self.addSubview(self.weChatLabel)
        self.addSubview(self.actionButton)
        
        weChatLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(18.0)
            make?.top.equalTo()(self)?.offset()(15.0)
            make?.bottom.equalTo()(self)?.offset()(-15.0)
        }
        
        actionButton.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(weChatLabel)
            make?.right.equalTo()(self)?.offset()(-12.5)
            make?.size.mas_equalTo()(CGSize(width: 55.0, height: 28.0))
        }
    }
}
