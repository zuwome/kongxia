//
//  ChangePriceSuccessView.swift
//  kongxia
//
//  Created by qiming xiao on 2022/1/16.
//  Copyright © 2022 TimoreYu. All rights reserved.
//

import UIKit

class ChangePriceSuccessView: UIView {
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.4
        return view
    }()
    
    lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "icon_memeda_endclose"), for: .normal)
        btn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return btn
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var contentbgView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "changePriceBg")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 3
        label.textColor = .white
        return label
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("知道了", for: .normal)
        btn.setBackgroundImage(UIImage(named: "changePriceButton"), for: .normal)
        btn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
        
        bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
        
        setupData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dismiss() {
        self.removeFromSuperview()
    }
}

extension ChangePriceSuccessView {
    @objc func setupData() {
        titleLabel.text = "价格变更通知"
        contentLabel.text = "您的技能价格已变更，可去您的技能信息页查看！未完成的邀约将继续按照旧的价格进行！"
    }
    
}

extension ChangePriceSuccessView {
    func layoutUI() {
        addSubview(bgView)
        addSubview(contentView)
        addSubview(cancelButton)
        contentView.addSubview(contentbgView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(confirmBtn)
        
        bgView.mas_makeConstraints { make in
            make?.edges.equalTo()(self)
        }
        
        contentView.mas_makeConstraints { make in
            make?.center.equalTo()(self)
            make?.size.mas_equalTo()(CGSize(width: 286, height: 338))
        }
        
        cancelButton.mas_makeConstraints { make in
            make?.bottom.equalTo()(contentView.mas_top)?.offset()(-15)
            make?.left.equalTo()(contentView.mas_right)
            make?.size.mas_equalTo()(CGSize(width: 22, height: 22))
        }
        
        contentbgView.mas_makeConstraints { make in
            make?.edges.equalTo()(contentView)
        }
        
        titleLabel.mas_makeConstraints { make in
            make?.left.right().equalTo()(self)
            make?.top.equalTo()(contentView)?.offset()(139)
        }
        
        contentLabel.mas_makeConstraints { make in
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(15)
            make?.left.equalTo()(contentView)?.offset()(32)
            make?.right.equalTo()(contentView)?.offset()(-32)
        }
        
        confirmBtn.mas_makeConstraints { make in
            make?.centerX.equalTo()(contentView)
            make?.top.equalTo()(contentLabel.mas_bottom)?.offset()(24)
        }
    }
}
