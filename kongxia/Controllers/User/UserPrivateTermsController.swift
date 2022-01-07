//
//  UserPrivateTerms.swift
//  kongxia
//
//  Created by qiming xiao on 2020/10/5.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

import UIKit

protocol UserPrivateTermsControllerDelegate: NSObjectProtocol {
    func agreedAction(viewController: UIViewController)
    func disagreedAction(viewController: UIViewController)
    
    func showUserProtocol(viewController: UIViewController)
    func showPrivacyTerms(viewController: UIViewController)
}

class UserPrivateTermsController: UIViewController {
    
    weak var delegate: UserPrivateTermsControllerDelegate?
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.6
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = rgbColor(27, 27, 27);
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "欢迎使用空虾APP"
        return label
    }()
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tanchuangTop")
        return imageView
    }()
    
    lazy var contentLabel: TYAttributedLabel = {
        let label = TYAttributedLabel(frame: CGRect.zero)
        label.textColor = rgbColor(38, 38, 38);
        label.font = UIFont(name: "PingFang-SC-Regular", size: 15.0)
        label.numberOfLines = 0
        label.delegate = self
        label.text = "在您使用空虾App前，请您认真阅读并了解"
        label.appendLink(withText: "《空虾用户协议》", linkFont: UIFont(name: "PingFang-SC-Medium", size: 15.0)!, linkColor: UIColor(red: 87.0 / 255.0, green: 151.0 / 255.0, blue: 1.0, alpha: 1.0), underLineStyle: CTUnderlineStyle(rawValue: 0x00), linkData: "《空虾用户协议》")
        label.appendText("和")
        label.appendLink(withText: "《空虾隐私权政策》", linkFont: UIFont(name: "PingFang-SC-Medium", size: 15.0)!, linkColor: UIColor(red: 87.0 / 255.0, green: 151.0 / 255.0, blue: 1.0, alpha: 1.0), underLineStyle: CTUnderlineStyle(rawValue: 0x00), linkData: "《空虾隐私权政策》")
        label.appendText("，点击同意即表示你已阅读并同意全部条款")
        return label
    }()
    
    lazy var agreeButton: UIButton = {
        let button = UIButton();
        button.backgroundColor = zzGoldenColor;
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(AgreeAction), for: .touchUpInside)
        button.setTitleColor(rgbColor(27, 27, 27), for: .normal)
        button.setTitle("同意", for: .normal)
        button.layer.cornerRadius = 22
        return button
    }()
    
    lazy var disagreeButton: UIButton = {
        let button = UIButton();
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(rgbColor(151, 151, 151), for: .normal)
        button.setTitle("不同意并退出", for: .normal)
        button.addTarget(self, action: #selector(DisagreeAction), for: .touchUpInside)
        return button
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 9
        
        view.addSubview(iconImageView)
        view.addSubview(titleLabel)
        view.addSubview(contentLabel)
        view.addSubview(agreeButton)
        view.addSubview(disagreeButton)
        
        iconImageView.mas_makeConstraints { (make) in
            make?.top.left().right()?.equalTo()(view)
            make?.height.equalTo()(125)
        }
        
        titleLabel.mas_makeConstraints { (make) in
            make?.top.equalTo()(iconImageView.mas_bottom)?.offset()(17)
            make?.left.right()?.equalTo()(view)
        }
        
        contentLabel.mas_makeConstraints { (make) in
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(15)
            make?.left.equalTo()(view)?.offset()(26)
            make?.right.equalTo()(view)?.offset()(-26)
            make?.height.equalTo()(130)
        }
        
        agreeButton.mas_makeConstraints { (make) in
            make?.top.equalTo()(contentLabel.mas_bottom)?.offset()(15)
            make?.centerX.equalTo()(view)
            make?.size.mas_equalTo()(CGSize(width: 156, height: 44))
        }
        
        disagreeButton.mas_makeConstraints { (make) in
            make?.top.equalTo()(agreeButton.mas_bottom)?.offset()(15)
            make?.centerX.equalTo()(view)
            make?.height.equalTo()(22.5)
        }
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Layout()
    }
    
    @objc func AgreeAction() {
        delegate?.agreedAction(viewController: self)
    }
    
    @objc func DisagreeAction() {
        delegate?.disagreedAction(viewController: self)
    }
    
    func Layout() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = .clear
        self.view.addSubview(backgroundView)
        self.view.addSubview(contentView)
        
        backgroundView.mas_makeConstraints { (make) in
            make?.edges.equalTo()(self.view);
        }
        
        contentView.mas_makeConstraints { (make) in
            make?.center.equalTo()(self.view)
            make?.size.equalTo()(CGSize(width: 302, height: 416))
        }
    }
}

extension UserPrivateTermsController: TYAttributedLabelDelegate {
    func attributedLabel(_ attributedLabel: TYAttributedLabel!, textStorageClicked textStorage: TYTextStorageProtocol!, at point: CGPoint) {
        if let texts = textStorage as? TYLinkTextStorage, let linkStr: String = texts.linkData as? String {
            if linkStr == "《空虾用户协议》" {
                delegate?.showUserProtocol(viewController: self)
            }
            else if linkStr == "《空虾隐私权政策》" {
                delegate?.showPrivacyTerms(viewController: self)
            }
        }
    }
}
