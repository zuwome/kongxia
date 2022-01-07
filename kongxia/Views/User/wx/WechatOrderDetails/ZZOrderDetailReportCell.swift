//
//  ZZOrderDetailReportCell.swift
//  zuwome
//
//  Created by qiming xiao on 2019/2/28.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

class ZZOrderDetailReportCell: ZZTableViewCell {
    // 从旧的微信评价页面过来
   var didCamefromOldWechatReview: Bool = false
    
    var wx: String?
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var titleView: ReportTitleView = {
        let view = ReportTitleView()
        
        return view
    }()

    lazy var detailsLabel: UILabel = {
        let label = UILabel(text: "抱歉，没能为您提供良好的体验，感谢您的举报，我们将在1个工作日内处理。请添加客服微信，我们将有金牌客服专门为您服务", font: UIFont.systemFont(ofSize: 14.0), textColor: rgbColor(153, 153, 153))
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var customerServiceLabel: UILabel = {
        let label = UILabel(text: "专属客服微信：1234abcwuwhd",
                            font: UIFont.systemFont(ofSize: 14.0),
                            textColor: rgbColor(63, 58, 58))
        label.textAlignment = .center
        return label
    }()
    
    lazy var pasteBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("复制", for: .normal)
        btn.setTitleColor(rgbColor(74, 144, 226), for: .normal)
        btn.titleLabel?.font = sysFont(13.0)
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
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = wx ?? ""
        ZZHUD.showTastInfo(with: "复制成功")
    }
    
    func configData(isBuy: Bool, wx: String) {
        self.wx = wx
        
        if didCamefromOldWechatReview {
            detailsLabel.text = "抱歉，没能为您提供良好的体验，感谢您的反馈，我们将在1个工作日内联系您。您也可以添加下方客服微信，我们将有金牌客服专门为您服务"
            titleView.titleLabel.text = "提交成功！"
            customerServiceLabel.text = "金牌客服微信：\(wx)"
        }
        else {
            if isBuy {
                detailsLabel.text = "抱歉，没能为您提供良好的体验，感谢您的举报，我们将在1个工作日内处理。请添加客服微信，我们将有金牌客服专门为您服务"
                titleView.titleLabel.text = "举报提交成功！"
            }
            else {
                detailsLabel.text = "对方举报了您的微信号，平台正在核实处理中，如有异议，请添加客服微信，我们将有金牌客服进行跟踪处理"
                titleView.titleLabel.text = "微信号被举报"
            }
        }

        customerServiceLabel.text = "专属客服微信：\(wx)"
    }
}

// MARK: Layout
extension ZZOrderDetailReportCell {
    func layout() {
        self.contentView.addSubview(bgView)
        bgView.addSubview(titleView)
        bgView.addSubview(detailsLabel)
        bgView.addSubview(customerServiceLabel)
        bgView.addSubview(pasteBtn)
        
        bgView.mas_makeConstraints { (make) in
            make?.edges.equalTo()(self.contentView)
            make?.height.equalTo()(370.0)
        }
        
        titleView.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(bgView)
            make?.top.equalTo()(self.contentView)?.offset()(32.5)
        }
        
        detailsLabel.mas_makeConstraints { (make) in
            make?.top.equalTo()(titleView.mas_bottom)?.offset()(24.5)
            make?.left.equalTo()(self.contentView)?.offset()(46.0)
            make?.right.equalTo()(self.contentView)?.offset()(-46.0)
        }
        
        customerServiceLabel.mas_makeConstraints { (make) in
            make?.top.equalTo()(detailsLabel.mas_bottom)?.offset()(37.5)
            make?.centerX.equalTo()(self.contentView)?.offset()(-10);
        }
        
        pasteBtn.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(customerServiceLabel)
            make?.left.equalTo()(customerServiceLabel.mas_right)?.offset()(7.0)
        }
    }
}

class ReportTitleView: UIView {
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "copy")
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(text: "微信号被举报",
                            font: boldFont(18.0),
                            textColor: rgbColor(63, 58, 58))
        label.textAlignment = .center
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ReportTitleView {
    func layout() {
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        
        iconImageView.mas_makeConstraints { (make) in
            make?.left.equalTo()(self);
            make?.top.equalTo()(self);
            make?.bottom.equalTo()(self);
            make?.size.mas_equalTo()(CGSize(width: 22.0, height: 22.0))
        }
        
        titleLabel.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(iconImageView)
            make?.right.equalTo()(self);
            make?.left.equalTo()(iconImageView.mas_right)?.offset()(7.0)
        }
    }
    
    
}
