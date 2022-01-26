//
//  ZZSkillThemeFooterCell.swift
//  kongxia
//
//  Created by qiming xiao on 2022/1/10.
//  Copyright © 2022 TimoreYu. All rights reserved.
//

import UIKit
import ObjectMapper

@objc protocol ZZSkillThemeFooterViewDelegate: NSObjectProtocol {
    func callCustomerService(cell: ZZSkillThemeFooterView, wechat: String)
}

class ZZSkillThemeFooterView: UIView {

    @objc weak var delegate: ZZSkillThemeFooterViewDelegate?
    
    lazy var serviceView: CustomerServiceView = {
        let view = CustomerServiceView()
        view.actionBtn.addTarget(self, action: #selector(callService), for: .touchUpInside)
        return view
    }()
    
    lazy var titleBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "themeTitlebgView")
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    @objc public var totalHeight: CGFloat = 160
    
    class CustomerServiceView: UIView {
        lazy var iconImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "icTijia")
            return imageView
        }()
        
        lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            label.text = "平台严禁私下加价"
            return label
        }()
        
        lazy var subTitleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14)
            label.text = "如需提价请联系客服申请"
            return label
        }()
        
        lazy var actionBtn: UIButton = {
            let btn = UIButton()
            btn.setTitle("申请提价", for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            btn.backgroundColor = .golden
            btn.layer.cornerRadius = 17
            return btn
        }()
        
        init() {
            super.init(frame: CGRect.zero)
            layoutUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func layoutUI() {
            backgroundColor = UIColor.rgbColor(244, 203, 7, 0.2)
            layer.borderColor = UIColor.golden.cgColor
            layer.borderWidth = 1
            
            addSubview(iconImageView)
            addSubview(titleLabel)
            addSubview(subTitleLabel)
            addSubview(actionBtn)
            
            actionBtn.mas_makeConstraints { make in
                make?.centerY.equalTo()(self)
                make?.right.equalTo()(self)?.offset()(-17)
                make?.size.mas_equalTo()(CGSize(width: 83, height: 34))
            }
            
            iconImageView.mas_makeConstraints { make in
                make?.top.equalTo()(self)?.offset()(19)
                make?.left.equalTo()(self)?.offset()(15)
                make?.size.mas_equalTo()(CGSize(width: 14, height: 17))
            }
            
            titleLabel.mas_makeConstraints { make in
                make?.centerY.equalTo()(iconImageView)
                make?.left.equalTo()(iconImageView.mas_right)?.offset()(5)
                make?.right.equalTo()(actionBtn.mas_left)?.offset()(-5)
            }
            
            subTitleLabel.mas_makeConstraints { make in
                make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(4)
                make?.left.equalTo()(iconImageView)
                make?.right.equalTo()(actionBtn.mas_left)?.offset()(-5)
            }
        }
    }
    
    class SkillView: UIView {
        lazy var iconImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "icTijia")
            return imageView
        }()
        
        var skillViews: [SkillView] = [SkillView]()
        
        lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            label.textColor = .rgbColor(153, 153, 153)
            label.numberOfLines = 2
            return label
        }()
        
        init() {
            super.init(frame: CGRect.zero)
            layoutUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func layoutUI() {
            addSubview(iconImageView)
            addSubview(titleLabel)
            
            iconImageView.mas_makeConstraints { make in
                make?.top.equalTo()(self)?.offset()(2)
                make?.left.equalTo()(self)
                make?.size.mas_equalTo()(CGSize(width: 20, height: 20))
            }
            
            titleLabel.mas_makeConstraints { make in
                make?.top.equalTo()(self)?.offset()(2)
                make?.bottom.equalTo()(self)?.offset()(-2)
                make?.left.equalTo()(iconImageView.mas_right)?.offset()(8)
                make?.right.equalTo()(self)?.offset()(-15)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        LayoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func callService() {
        delegate?.callCustomerService(cell: self, wechat: "")
    }
    
    func LayoutUI() {
        addSubview(serviceView)
        
        serviceView.mas_makeConstraints { make in
            make?.centerX.equalTo()(self)
            make?.top.equalTo()(self)?.offset()(75)
            make?.left.equalTo()(self)?.offset()(15)
            make?.right.equalTo()(self)?.offset()(-15)
            make?.height.equalTo()(74)
        }
        
        addSubview(titleBackgroundImageView)
        addSubview(titleLabel)
        titleLabel.mas_makeConstraints { make in
            make?.left.equalTo()(self)?.offset()(15)
            make?.top.equalTo()(serviceView.mas_bottom)?.offset()(20)
        }
        
        titleBackgroundImageView.mas_makeConstraints { make in
            make?.left.right().equalTo()(titleLabel)
            make?.bottom.equalTo()(titleLabel)
            make?.height.equalTo()(8)
        }
    }

    @objc func setData(customerInfo: NSDictionary) {
        if let pop = customerInfo["popup"] as? Dictionary<String, String> {
            if let title = pop["title"] {
                serviceView.titleLabel.text = title
            }
            
            if let content = pop["content"] {
                serviceView.subTitleLabel.text = content
            }
            
            if let btn = pop["btnTxt"] {
                serviceView.actionBtn.setTitle(btn, for: .normal)
            }
        }
        
        if let tips = customerInfo["tips"] as? Dictionary<String, Any> {
            if let title = tips["title"] as? String {
                titleLabel.text = title
            }
            
            totalHeight += 50
            if let list = tips["list"] as? Array<Dictionary<String, String>>, !list.isEmpty {
                var topView: UIView = titleLabel
                list.forEach { tip in
                    let skillview = SkillView()
                    
                    if let title = tip["tip"] {
                        skillview.titleLabel.text = title
                    }
                    
                    if let image = tip["icon"] {
                        skillview.iconImageView.sd_setImage(with: URL(string: image), completed: nil)
                    }
                    
                    addSubview(skillview)

                    skillview.mas_makeConstraints { make in
                        make?.left.equalTo()(self)?.offset()(15)
                        make?.right.equalTo()(self)?.offset()(-15)
                        make?.top.equalTo()(topView.mas_bottom)?.offset()(11)
                    }

                    topView = skillview
                }
                
                layoutIfNeeded()
                totalHeight = topView.bottom;
                totalHeight += 10
            }
        } 
    }
}

