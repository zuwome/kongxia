//
//  ZZDeleteAccountConfirmViewController.swift
//  kongxia
//
//  Created by qiming xiao on 2022/7/29.
//  Copyright © 2022 TimoreYu. All rights reserved.
//

import Foundation
import UIKit

@objc class ZZDeleteAccountConfirmViewController: UIViewController {
    
    @objc var reason: String
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .title3).pointSize)
        label.textColor = .black
        label.text = "注销空虾App账号服务"
        return label
    }()
    
    lazy var contentsLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .gray
        label.numberOfLines = 0
        
        var titles = "如您注销空虾App账号，您在空虾App，留存的信息将被处理（删除或匿名化）且无法找回，具体包括注销空虾App账号服务\n"
        var titlesattriStr = NSMutableAttributedString(string: titles)
        
        var contents = """
        
        1 昵称、头像等个人资料
        2 已认证的身份信息等级信息，如V认证
        3 邀约订单及聊天消息
        4 账户资金信息
        5 在产品使用及留存的其他信息
        """
        var contentsattriStr = NSMutableAttributedString(string: contents)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        contentsattriStr.addAttribute(.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: contentsattriStr.length))
        contentsattriStr.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: 0, length: contentsattriStr.length))
        
        titlesattriStr.append(contentsattriStr)
        label.attributedText = titlesattriStr
        return label
    }()
    
    lazy var footnotesLabel: TYAttributedLabel = {
        let label = TYAttributedLabel(frame: CGRect.zero)
        label.textAlignment = .center
        label.delegate = self
        label.textColor = .gray;
        label.backgroundColor = .clear
        label.font = UIFont(name: "PingFang-SC-Regular", size: 13.0)
        label.text = "点击【下一步】即代表您已经同意"
        label.appendLink(withText: "《用户注销协议》", linkFont: UIFont(name: "PingFang-SC-Medium", size: 13.0)!, linkColor: UIColor(red: 87.0 / 255.0, green: 151.0 / 255.0, blue: 1.0, alpha: 1.0), underLineStyle: CTUnderlineStyle(rawValue: 0x00), linkData: "《用户注销协议》")
        return label
    }()
    
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.golden
        button.setTitle("确认注销", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "账号注销"
        
        view.backgroundColor = .zzBackground
        self.edgesForExtendedLayout = []
        
        setupUI()
    }
    
    
    @objc func deleteAccount() {
        goToDeleteAccountView()
    }
    
    private func goToDeleteAccountView() {
        let controller = ZZDeleteAccountViewController()
        controller.reason = reason;
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc init(reason: String) {
        self.reason = reason
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZZDeleteAccountConfirmViewController: TYAttributedLabelDelegate {
    func attributedLabel(_ attributedLabel: TYAttributedLabel!, textStorageClicked textStorage: TYTextStorageProtocol!, at point: CGPoint) {
        if let texts = textStorage as? TYLinkTextStorage, let linkStr: String = texts.linkData as? String {
            if linkStr == "《用户注销协议》" {
                let webController = ZZLinkWebViewController()
                webController.urlString = H5Url.DeleAccount;
                webController.navigationItem.title = "账号注销"
                webController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(webController, animated: true)
            }
        }
    }
}

extension ZZDeleteAccountConfirmViewController {
    private func setupUI() {
        let titleView = UIView()
        titleView.backgroundColor = .white
        view.addSubview(titleView)
        titleView.addSubview(titleLabel)
        
        let contentView = UIView()
        contentView.backgroundColor = .white
        view.addSubview(contentView)
        contentView.addSubview(contentsLabel)
        
        view.addSubview(footnotesLabel)
        view.addSubview(button)
        
        titleView.mas_makeConstraints { make in
            make?.left.equalTo()(view)
            make?.right.equalTo()(view)
            make?.top.equalTo()(view)
            make?.height.equalTo()(50)
        }
        
        titleLabel.mas_makeConstraints { make in
            make?.left.equalTo()(titleView)?.offset()(15)
            make?.right.equalTo()(titleView)?.offset()(-15)
            make?.top.equalTo()(titleView)?.offset()(15)
            make?.bottom.equalTo()(titleView)?.offset()(-15)
        }
        
        contentView.mas_makeConstraints { make in
            make?.left.equalTo()(view)
            make?.right.equalTo()(view)
            make?.top.equalTo()(titleView.mas_bottom)?.offset()(10)
        }
        
        contentsLabel.mas_makeConstraints { make in
            make?.left.equalTo()(contentView)?.offset()(15)
            make?.right.equalTo()(contentView)?.offset()(-15)
            make?.top.equalTo()(contentView)?.offset()(15)
            make?.bottom.equalTo()(contentView)?.offset()(-15)
        }
        
        footnotesLabel.mas_makeConstraints { make in
            make?.left.equalTo()(view)?.offset()(15)
            make?.right.equalTo()(view)?.offset()(-15)
            make?.top.equalTo()(contentView.mas_bottom)?.offset()(15)
            make?.height.equalTo()(30)
        }
        
        button.mas_makeConstraints { make in
            make?.left.equalTo()(view)?.offset()(15)
            make?.right.equalTo()(view)?.offset()(-15)
            make?.top.equalTo()(footnotesLabel.mas_bottom)?.offset()(5)
            make?.height.equalTo()(50)
        }
    }
}
