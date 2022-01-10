//
//  ZZOrderDetailUploadCell.swift
//  zuwome
//
//  Created by qiming xiao on 2019/2/28.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

protocol ZZOrderDetailUploadCellDelegate: NSObjectProtocol {
    func uploadPhoto(cell: ZZOrderDetailUploadCell)
    func fullScreenExamplePhoto(cell: ZZOrderDetailUploadCell, image: UIImage)
}

class ZZOrderDetailUploadCell: ZZTableViewCell {
    weak var delegate: ZZOrderDetailUploadCellDelegate?
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(text: "请上传对方微信个人资料页截图",
                            font: UIFont.systemFont(ofSize: 14.0),
                            textColor: UIColor.rgbColor(63, 58, 58))
        return label
    }()
    
    lazy var exampleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "shilitupian")
        let tap = UITapGestureRecognizer(target: self, action: #selector(exampleImgTapped(recognizer:)))
        imageView.addGestureRecognizer(tap)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var exampleDescLabel: UILabel = {
        let label = UILabel(text: "示例截图",
                            font: sysFont(13.0),
                            textColor: UIColor.rgbColor(153, 153, 153))
        
        return label
    }()
    
    lazy var screenShotImageView: ZZOrderDetailUploadView = {
        let imageView = ZZOrderDetailUploadView()
        let tap = UITapGestureRecognizer(target: self, action: #selector((tapped)))
        imageView.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapped))
        imageView.photoImageView.addGestureRecognizer(tap1)
        return imageView
    }()
    
    lazy var screenShotDescLabel: UILabel = {
        let label = UILabel(text: "请添加截图",
                            font: sysFont(13.0),
                            textColor: UIColor.rgbColor(153, 153, 153))
        
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString(string: "*  上传虚假截图，将会面临不再推荐，封禁账号等处罚\n* 确认添加，上传截图后48小时，打赏将自动到账。或对方评价后，打赏将会立即到账", attributes: [
            .font: UIFont(name: "PingFang-SC-Regular", size: 13.0)!,
            .foregroundColor: UIColor(white: 153.0 / 255.0, alpha: 1.0),
            .kern: 0.0
            ])
        attributedString.addAttributes([
            .font: UIFont(name: "PingFang-SC-Medium", size: 13.0)!,
            .foregroundColor: UIColor.golden.cgColor
            ], range: NSRange(location: 0, length: 1))
        attributedString.addAttributes([
            .font: UIFont(name: "PingFangSC-Regular", size: 13.0)!,
            .foregroundColor: UIColor.golden.cgColor
            ], range: NSRange(location: 27, length: 1))
        label.attributedText = attributedString
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func tapped() {
        delegate?.uploadPhoto(cell: self)
    }
    
    @objc func exampleImgTapped(recognizer: UITapGestureRecognizer) {
        let imageView = recognizer.view as! UIImageView
        delegate?.fullScreenExamplePhoto(cell: self, image: imageView.image!)
    }
}

// MARK: Layout
extension ZZOrderDetailUploadCell {
    func layout() {
        self.addSubview(bgView)
        bgView.addSubview(titleLabel)
        bgView.addSubview(exampleImageView)
        bgView.addSubview(exampleDescLabel)
        bgView.addSubview(screenShotImageView)
        bgView.addSubview(screenShotDescLabel)
        bgView.addSubview(descriptionLabel)
        
        bgView.mas_makeConstraints { (make) in
            make?.edges.equalTo()(self)
            make?.height.equalTo()(380)
        }
        
        titleLabel.mas_makeConstraints { (make) in
            make?.top.equalTo()(bgView)?.offset()(18.0)
            make?.left.equalTo()(bgView)?.offset()(18.0)
        }
        
        exampleImageView.mas_makeConstraints { (make) in
            make?.left.equalTo()(titleLabel)
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(15.0)
            make?.size.mas_equalTo()(CGSize(width: 110, height: 110))
        }
        
        exampleDescLabel.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(exampleImageView)
            make?.top.equalTo()(exampleImageView.mas_bottom)?.offset()(8.5)
        }
        
        screenShotImageView.mas_makeConstraints { (make) in
            make?.left.equalTo()(exampleImageView.mas_right)?.offset()(10.5)
            make?.centerY.equalTo()(exampleImageView)
            make?.size.mas_equalTo()(CGSize(width: 110, height: 110))
        }
        
        screenShotDescLabel.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(screenShotImageView)
            make?.centerY.equalTo()(exampleDescLabel)
        }
        
        descriptionLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(bgView)?.offset()(15)
            make?.right.equalTo()(bgView)?.offset()(-15)
            make?.bottom.equalTo()(bgView)?.offset()(-28)
        }
    }
}

// MARK: - ZZOrderDetailUploadView
class ZZOrderDetailUploadView : UIView {
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "icTjtp")
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(text: "添加照片",
                            font: sysFont(12),
                            textColor: UIColor.rgbColor(153, 153, 153))
        label.textAlignment = .center
        return label
    }()
    
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.layer.masksToBounds = true
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
extension ZZOrderDetailUploadView {
    func layout() {
        self.backgroundColor = UIColor.rgbColor(236, 236, 236)
        
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        self.addSubview(photoImageView)
        
        iconImageView.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(self)
            make?.top.equalTo()(self)?.offset()(35.0)
        }
        
        titleLabel.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(self)
            make?.top.equalTo()(iconImageView.mas_bottom)?.offset()(8.5)
        }
        
        photoImageView.mas_makeConstraints { (make) in
            make?.edges.equalTo()(self)
        }
    }
}
