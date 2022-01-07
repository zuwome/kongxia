//
//  ZZOrderReportReasonCell.swift
//  zuwome
//
//  Created by qiming xiao on 2019/2/28.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

class ZZOrderReportReasonCell: ZZTableViewCell {

    lazy var titleLabel: UILabel = {
        let label = UILabel(text: "虚假微信号", font: sysFont(15.0), textColor: zzBlackColor)
        
        return label
    }()
    
    lazy var checkedBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "oval75Copy"), for: .normal)
        btn.setImage(UIImage(named: "icXzJbwx11"), for: .selected)
        return btn
    }()
    
    lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = rgbColor(230, 230, 230)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: Layout
extension ZZOrderReportReasonCell {
    func layout() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(checkedBtn)
        self.contentView.addSubview(line)
        
        titleLabel.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.contentView)?.offset()(14.5)
            make?.bottom.equalTo()(self.contentView)?.offset()(-14.5)
            make?.left.equalTo()(self.contentView)?.offset()(15.0)
        }
        
        checkedBtn.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(titleLabel)
            make?.right.equalTo()(self.contentView)?.offset()(-15.0)
            make?.size.mas_equalTo()(CGSize(width: 15.0, height: 15.0))
        }
        
        line.mas_makeConstraints { (make) in
            make?.right.equalTo()(self.contentView)?.offset()(-15)
            make?.bottom.equalTo()(self.contentView)
            make?.left.equalTo()(self.contentView)?.offset()(15)
            make?.height.equalTo()(0.5)
        }
    }
}
