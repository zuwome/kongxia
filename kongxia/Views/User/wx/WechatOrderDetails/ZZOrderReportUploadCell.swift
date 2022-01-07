//
//  ZZOrderReportUploadCell.swift
//  zuwome
//
//  Created by qiming xiao on 2019/2/28.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

protocol ZZOrderReportUploadCellDelegate: NSObjectProtocol {
    func cellSelected(cell: ZZOrderReportUploadCell, selectIndex: Int)
}

class ZZOrderReportUploadCell: ZZTableViewCell {
    weak var delegate: ZZOrderReportUploadCellDelegate?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "添加辅助证据"
        label.textColor = rgbColor(63, 58, 58)
        label.font = UIFont(name: "PingFangSC-Medium", size: 15.0) ?? UIFont.systemFont(ofSize: 15.0)
        return label
    }()
    
    lazy var photoViewLeft: ZZOrderReportUploadView = {
        let view = ZZOrderReportUploadView()
        view.tag = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(selected(recognizer:)))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var photoViewCenter: ZZOrderReportUploadView = {
        let view = ZZOrderReportUploadView()
        view.tag = 1
        let tap = UITapGestureRecognizer(target: self, action: #selector(selected(recognizer:)))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var photoViewRight: ZZOrderReportUploadView = {
        let view = ZZOrderReportUploadView()
        view.tag = 2
        let tap = UITapGestureRecognizer(target: self, action: #selector(selected(recognizer:)))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func selected(recognizer: UITapGestureRecognizer) {
        delegate?.cellSelected(cell: self, selectIndex: recognizer.view?.tag ?? -1)
    }
    
    func configData(imagesArr: [ZZPhoto]?) {
        photoViewLeft.isHidden = true
        photoViewCenter.isHidden = true
        photoViewRight.isHidden = true
        photoViewLeft.photoImageView.image = nil
        photoViewCenter.photoImageView.image = nil
        photoViewRight.photoImageView.image = nil
        
        if let imagesArr = imagesArr {
            if imagesArr.count == 1 {
                photoViewLeft.isHidden = false
                photoViewCenter.isHidden = false
                
                photoViewLeft.photoImageView.image = imagesArr.first?.image
            }
            else if imagesArr.count == 2 {
                photoViewLeft.isHidden = false
                photoViewCenter.isHidden = false
                photoViewRight.isHidden = false
                
                photoViewLeft.photoImageView.image = imagesArr.first?.image
                photoViewCenter.photoImageView.image = imagesArr[1].image
            }
            else {
                photoViewLeft.isHidden = false
                photoViewCenter.isHidden = false
                photoViewRight.isHidden = false
                
                photoViewLeft.photoImageView.image = imagesArr.first?.image
                photoViewCenter.photoImageView.image = imagesArr[1].image
                photoViewRight.photoImageView.image = imagesArr.last?.image
            }
        }
        else {
            photoViewLeft.isHidden = false
            photoViewCenter.isHidden = true
            photoViewRight.isHidden = true
        }
    }
    
}

// MARK: Layout
extension ZZOrderReportUploadCell {
    func layout() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(photoViewLeft)
        self.contentView.addSubview(photoViewCenter)
        self.contentView.addSubview(photoViewRight)
        
        titleLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.contentView)?.offset()(15.0)
            make?.top.equalTo()(self.contentView)?.offset()(25.5)
        }
        
        photoViewLeft.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.contentView)?.offset()(15.0)
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(5)
            make?.bottom.equalTo()(self.contentView)?.offset()(-16.0)
            make?.size.mas_equalTo()(CGSize(width: 90.0, height: 90.0))
        }
        
        photoViewCenter.mas_makeConstraints { (make) in
            make?.left.equalTo()(photoViewLeft.mas_right)?.offset()(7.5)
            make?.top.equalTo()(photoViewLeft)
            make?.size.mas_equalTo()(CGSize(width: 90.0, height: 90.0))
        }
        
        photoViewRight.mas_makeConstraints { (make) in
            make?.left.equalTo()(photoViewCenter.mas_right)?.offset()(7.5)
            make?.top.equalTo()(photoViewLeft)
            make?.size.mas_equalTo()(CGSize(width: 90.0, height: 90.0))
        }
    }
}

// MARK: - 
class ZZOrderReportUploadView : UIImageView {
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icTjzpJbym")
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(text: "添加照片",
                            font: sysFont(12),
                            textColor: rgbColor(128, 128, 128))
        label.textAlignment = .center
        return label
    }()
    
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Layout
extension ZZOrderReportUploadView {
    func layout() {
        self.isUserInteractionEnabled = true
        self.image = UIImage(named: "iconCheckBlack")
        
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        self.addSubview(photoImageView)
        
        iconImageView.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(self)
            make?.top.equalTo()(self)?.offset()(27.0)
            make?.size.mas_equalTo()(CGSize(width: 28.0, height: 23.0))
        }
        
        titleLabel.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(self)
            make?.top.equalTo()(iconImageView.mas_bottom)?.offset()(3.5)
        }
        
        photoImageView.mas_makeConstraints { (make) in
            make?.edges.equalTo()(self)
        }
    }
}
