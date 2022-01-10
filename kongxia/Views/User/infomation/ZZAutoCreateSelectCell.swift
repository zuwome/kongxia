//
//  ZZAutoCreateSelectCell.swift
//  zuwome
//
//  Created by qiming xiao on 2019/5/9.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

class ZZAutoCreateSelectCell: ZZTableViewCell {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textColor = UIColor.rgbColor(102, 102, 102)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textColor = UIColor.rgbColor(102, 102, 102)
        label.numberOfLines = 2
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureData(model: ZZAutoCreateDimensionModel, skills: [ZZSkillTag]?) {
        titleLabel.text = model.name
        subTitleLabel.text = "请选择你的\(model.name ?? "")"
        subTitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        subTitleLabel.textColor = UIColor.rgbColor(199, 199, 205)
        
        if let skillArray = skills {
            var skillDes = ""
            for (index, skill) in skillArray.enumerated() {
                skillDes += "\(String(describing: skill.name!))"
                if index < skillArray.count - 1 {
                    skillDes += ", "
                }
            }
            if skillDes.count > 0 {
                subTitleLabel.text = skillDes
                subTitleLabel.font = UIFont.boldSystemFont(ofSize: 14)
                subTitleLabel.textColor = UIColor.rgbColor(63, 58, 58)
            }
        }
    }
}

// MARK: Layout
extension ZZAutoCreateSelectCell {
    func layout() {
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        
        titleLabel.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(self)
            make?.left.equalTo()(self)?.offset()(15)
            make?.width.equalTo()(100)
        }
        
        subTitleLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(titleLabel.mas_right)
            make?.right.equalTo()(self)?.offset()(-15)
            make?.top.equalTo()(self)
            make?.bottom.equalTo()(self)
        }
    }
}
