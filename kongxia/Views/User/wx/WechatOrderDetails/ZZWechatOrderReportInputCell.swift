//
//  ZZWechatOrderReportInput.swift
//  kongxia
//
//  Created by qiming xiao on 2019/10/28.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

protocol ZZWechatOrderReportInputCellDelegate: NSObjectProtocol {
    func cellOrWechatDidInput(view: ZZWechatOrderReportInputCell, cellOrWeChat: String?)
}

class ZZWechatOrderReportInputCell: ZZTableViewCell {
    weak var delegate: ZZWechatOrderReportInputCellDelegate?
    
    lazy var inputTextField: UITextField = {
        let textfield = UITextField()
        textfield.font = sysFont(16.0)
        textfield.textColor = rgbColor(171, 171, 171)
        textfield.placeholder = "您的电话或微信号"
        textfield.delegate = self
        return textfield
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icDianhua")
        return imageView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZZWechatOrderReportInputCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.cellOrWechatDidInput(view: self, cellOrWeChat: textField.text)
    }
}

// MARK: Layout
extension ZZWechatOrderReportInputCell {
    func layout() {
        self.contentView.addSubview(iconImageView)
        self.contentView.addSubview(inputTextField)
        
        iconImageView.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(self.contentView)
            make?.left.equalTo()(self.contentView)?.offset()(15.0)
            make?.size.mas_equalTo()(CGSize(width: 22, height: 22))
        }
        
        inputTextField.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(self.contentView)
            make?.left.equalTo()(iconImageView.mas_right)?.offset()(8.0)
            make?.right.equalTo()(self.contentView)?.offset()(-15.0)
        }
    }
}

