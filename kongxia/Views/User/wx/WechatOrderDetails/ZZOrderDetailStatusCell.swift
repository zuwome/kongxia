//
//  ZZOrderDetailStatusCell.swift
//  zuwome
//
//  Created by qiming xiao on 2019/2/28.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

class ZZOrderDetailStatusCell: ZZTableViewCell {
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(text: "微信订单名称",
                            font: boldFont(17.0),
                            textColor: .black)
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel(text: "微信订单详细信息微信订单详细信息微信订单详细信息微信订单详细信息微信订单详细信息微信订单详细信息微信订单详细信息微信订单详细信息微信订单详细信息",
                            font: UIFont.systemFont(ofSize: 14),
                            textColor: UIColor.rgbColor(153, 153, 153))
        label.numberOfLines = 0
        return label
    }()
    
    lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgbColor(237, 237, 237)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func orderStatus(status: WxOrderStatus, statusTitle: String?, hightLightedStr:String?, statusDes: String?) {
        var iconStr = ""
        if status == .buyer_bought
            || status == .seller_bought
            || status == .buyer_waitToBeEvaluated {
            iconStr = "icDtjWxdd"
        }
        else if status == .buyer_confirm
            || status == .seller_confirm
            || status == .seller_waitToBeEvaluated {
            iconStr = "icDqrWxdd"
        }
        else if status == .buyer_reporting
            || status == .seller_beingReported {
            iconStr = "icJubaoWxhdd"
        }
        else if status == .buyer_commented
            || status == .seller_complete
            || status == .seller_autoComplete
            || status == .buyer_reportSuccess
            || status == .buyer_reportFail
            || status == .seller_reportSuccess
            || status == .seller_reportFail {
            iconStr = "icYwcWxdd"
        }
        
        iconImageView.image = UIImage(named: iconStr)
        titleLabel.text = statusTitle
        subTitleLabel.text = statusDes
        
        if let highLightStr = hightLightedStr {
            if let range = statusDes?.range(of: highLightStr) {
                let nsrange = NSRange(range, in: statusDes!)
                let attriStr = NSMutableAttributedString(string: statusDes!)
                
                attriStr.addAttributes([.font: UIFont(name: "PingFang-SC-Regular", size: 14.0)!, .foregroundColor: UIColor.rgbColor(153,153,153)], range: NSRange(location: 0, length: statusDes!.count))
                
                attriStr.addAttributes([.font: UIFont(name: "PingFang-SC-Medium", size: 14.0)!, .foregroundColor: UIColor.rgbColor(102, 102, 102)], range: nsrange)
                
                subTitleLabel.attributedText = attriStr
            }
            
        }
    }
}

// MARK: Layout
extension ZZOrderDetailStatusCell {
    func layout() {
        self.addSubview(self.iconImageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.subTitleLabel)
        self.addSubview(self.line)
        
        iconImageView.mas_makeConstraints { (make) in
            make?.top.equalTo()(self)?.offset()(19.0)
            make?.left.equalTo()(self)?.offset()(18.0)
            make?.size.mas_equalTo()(CGSize(width: 22.0, height: 22.0))
        }
        
        titleLabel.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(iconImageView)
            make?.left.equalTo()(iconImageView.mas_right)?.offset()(7.0)
            make?.right.equalTo()(self)?.equalTo()(-18.0)
        }
        
        subTitleLabel.mas_makeConstraints { (make) in
            make?.top.equalTo()(iconImageView.mas_bottom)?.offset()(9.0)
            make?.left.equalTo()(iconImageView)
            make?.right.equalTo()(self)?.equalTo()(-18.0)
            make?.bottom.equalTo()(self)?.equalTo()(-10.0)
        }
        
        line.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(18.0)
            make?.right.equalTo()(self)?.offset()(-18.0)
            make?.bottom.equalTo()(self)
            make?.height.equalTo()(0.5)
        }
    }
}
