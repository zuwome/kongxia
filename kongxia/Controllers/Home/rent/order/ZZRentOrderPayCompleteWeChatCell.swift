//
//  ZZRentOrderPayCompleteWeChatCell.swift
//  kongxia
//
//  Created by qiming xiao on 2021/1/16.
//  Copyright © 2021 TimoreYu. All rights reserved.
//

import Foundation

@objc protocol ZZRentOrderPayCompleteWeChatCellDelegate: NSObjectProtocol {
    func sumbitWechat(cell: ZZRentOrderPayCompleteWeChatCell, wechat: String)
}

@objc class ZZRentOrderPayCompleteWeChatCell: ZZTableViewCell {
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ZZRentOrderPayCompleteWeChatCellBG")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private lazy var wechatTextField: UITextField = {
        let textField = UITextField();
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.textColor = rgbColor(63, 58, 58)
        textField.placeholder = "或留下您的微信等待客服添加您"
        return textField;
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(submit), for: .touchUpInside)
        
        button.setTitle("保存", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.setTitle("已提交", for: .selected)
        button.setTitleColor(rgbColor(122, 122, 122), for: .selected)
        
        button.titleLabel?.font = UIFont(name: "PingFangSC-Medium", size: 13) ?? kongxia.font(13)
        
        button.backgroundColor = rgbColor(250, 115, 78)
        button.layer.cornerRadius = 5
        return button
    }()
    
    @objc weak var delegate: ZZRentOrderPayCompleteWeChatCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func submit() {
        guard !submitButton.isSelected else {
            return
        }
        
        guard let wechat = wechatTextField.text, wechat.count > 0 else {
            ZZHUD.showInfo(withStatus: "请输入您的微信号")
            return
        }
        delegate?.sumbitWechat(cell: self, wechat: wechat)
    }
    
    private func switchButtonStyle(isSubmin: Bool) {
        submitButton.isSelected = isSubmin
        submitButton.backgroundColor = isSubmin ? .clear : rgbColor(250, 115, 78)
    }
    
    @objc public func buttonState(isSubmin: Bool) {
        switchButtonStyle(isSubmin: isSubmin)
    }
    
    func layout() {
        backgroundColor = .clear
        let infoView = UIView()
        infoView.backgroundColor = .white
        infoView.layer.cornerRadius = 6
        
        contentView.addSubview(infoView)
        infoView.addSubview(wechatTextField)
        infoView.addSubview(submitButton)
        
        infoView.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(contentView)
            make?.top.equalTo()(contentView)
            make?.size.mas_equalTo()(CGSize(width: 315, height: 57))
        }
        
        submitButton.mas_makeConstraints { (make) in
            make?.right.equalTo()(infoView)?.offset()(-20)
            make?.centerY.equalTo()(infoView)
            make?.size.mas_equalTo()(CGSize(width: 47, height: 25))
        }
        
        wechatTextField.mas_makeConstraints { (make) in
            make?.top.equalTo()(infoView)
            make?.bottom.equalTo()(infoView)
            make?.left.equalTo()(infoView)?.offset()(20)
            make?.right.equalTo()(submitButton.mas_left)?.offset()(-10)
        }
    }
}
