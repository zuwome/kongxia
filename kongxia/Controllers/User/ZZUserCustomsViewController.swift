//
//  ZZUserCustomsViewController.swift
//  kongxia
//
//  Created by qiming xiao on 2020/10/6.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

import Foundation

class ZZUserCustomsViewController: ZZViewController {

    var customModel: ZZUserCustomsModel? = nil
    
    lazy var customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var wechatBtn: UIButton = {
        let button = UIButton()
        button.setTitle("发送名片到微信", for: .normal)
        button.setTitleColor(UIColor.rgbColor(63, 58, 58), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setImage(UIImage(named: "Custom_wechat"), for: .normal)
        button.setImagePosition(.top, spacing: 5)
        button.addTarget(self, action: #selector(shareToWechat), for: .touchUpInside)
        return button
    }()
    
    lazy var albumBtn: UIButton = {
        let button = UIButton()
        button.setTitle("保存名片到相册", for: .normal)
        button.setTitleColor(UIColor.rgbColor(63, 58, 58), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setImage(UIImage(named: "Custom_Album"), for: .normal)
        button.setImagePosition(.top, spacing: 5)
        button.addTarget(self, action: #selector(saveToAlbum), for: .touchUpInside)
        return button
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "空虾App高级客服经理为您提供优先优质的咨询和服务，欢迎添加"
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Custom_title")
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "添加您的高级客服经理，可获得"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var title1ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Custom_1")
        return imageView
    }()
    
    lazy var title1Label: UILabel = {
        let label = UILabel()
        label.text = "使用问题优先处理"
        label.font = UIFont(name: "PingFang-SC-Medium", size: 13.0) ?? UIFont.systemFont(ofSize: 13.0)
        label.textColor = UIColor.rgbColor(102, 102, 102)
        return label
    }()
    
    lazy var title2ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Custom_2")
        return imageView
    }()
    
    lazy var title2Label: UILabel = {
        let label = UILabel()
        label.text = "专属的一对一咨询服务"
        label.font = UIFont(name: "PingFang-SC-Medium", size: 13.0) ?? UIFont.systemFont(ofSize: 13.0)
        label.textColor = UIColor.rgbColor(102, 102, 102)
        return label
    }()
    
    lazy var title3ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Custom_3")
        return imageView
    }()
    
    lazy var title3Label: UILabel = {
        let label = UILabel()
        label.text = "充值问题及优惠活动通知"
        label.font = UIFont(name: "PingFang-SC-Medium", size: 13.0) ?? UIFont.systemFont(ofSize: 13.0)
        label.textColor = UIColor.rgbColor(102, 102, 102)
        return label
    }()
    
    lazy var title4ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Custom_4")
        return imageView
    }()
    
    lazy var title4Label: UILabel = {
        let label = UILabel()
        label.text = "优质用户交流群进群资格"
        label.font = UIFont(name: "PingFang-SC-Medium", size: 13.0) ?? UIFont.systemFont(ofSize: 13.0)
        label.textColor = UIColor.rgbColor(102, 102, 102)
        return label
    }()
    
    override func viewDidLoad() {
        self.edgesForExtendedLayout = []
        layout()
        createNavigationLeftButton()
        getData()
    }
    
    @objc func shareToWechat() {
        if let image = customImageView.image {
            if WXApi.isWXAppInstalled() {
                ZZWechatShareHelper.share(image, controller: self)
            }
            else {
                ZZHUD.showError(withStatus: "分享失败，您尚未安装微信。")
            }
            
        }
    }
    
    @objc func saveToAlbum() {
        if let image = customImageView.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveAlbumComplete), nil)
        }
    }
    
    @objc func saveAlbumComplete(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        ZZHUD.showInfo(withStatus: "保存成功")
        }
    
    func getData() {
        ZZRequest.method("GET", path: "/api/customerService", params: nil) { (error, data, _) in
            guard let _ = error else {
                if let dataDic = data as? Dictionary<String, Any> {
                    if let model = ZZUserCustomsModel(JSON: dataDic) {
                        self.refreshData(customModel: model)
                        return
                    }
                }
                return
            }
            ZZHUD.showError(withStatus: error?.message)
        }
    }
    
    func refreshData(customModel: ZZUserCustomsModel) {
        if let content = customModel.content {
            contentLabel.text = content
        }
        
        if let title = customModel.serviceTitle {
            titleLabel.text = title
        }
        
        if ZZUserHelper.shareInstance()?.loginer.gender == 1 {
            if let image = customModel.maleImg {
                customImageView.sd_setImage(with: URL(string: image), completed: nil)
            }
        }
        else if ZZUserHelper.shareInstance()?.loginer.gender == 2 {
            if let image = customModel.femaleImg {
                customImageView.sd_setImage(with: URL(string: image), completed: nil)
            }
        }
        
        var content: [String]?
        if ZZUserHelper.shareInstance()?.loginer.gender == 1 {
            content = customModel.maleServiceList;
        }
        else {
            content = customModel.femaleServiceList;
        }
        
        if let contentList = content {
            for (index, content) in contentList.enumerated() {
                if index == 0 {
                    title1Label.text = content
                }
                else if index == 1 {
                    title2Label.text = content
                }
                else if index == 2 {
                    title3Label.text = content
                }
                else if index == 3 {
                    title4Label.text = content
                }
            }
        }
    }
    
    func layout() {
        self.title = "高级客服经理"
        self.view.backgroundColor = .white
        
        self.view.addSubview(customImageView)
        self.view.addSubview(wechatBtn)
        self.view.addSubview(albumBtn)
        self.view.addSubview(contentLabel)
        self.view.addSubview(titleImageView)
        self.view.addSubview(title1ImageView)
        self.view.addSubview(title2ImageView)
        self.view.addSubview(title3ImageView)
        self.view.addSubview(title4ImageView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(title1Label)
        self.view.addSubview(title2Label)
        self.view.addSubview(title3Label)
        self.view.addSubview(title4Label)
        
        customImageView.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.view)?.offset()(28.0)
            make?.left.equalTo()(self.view)?.offset()(20.0)
            make?.size.mas_equalTo()(CGSize(width: 200, height: 239.5))
        }
        
        wechatBtn.mas_makeConstraints { (make) in
            make?.top.equalTo()(customImageView)?.offset()(36)
            make?.left.equalTo()(customImageView.mas_right)?.offset()(32)
            make?.size.mas_equalTo()(CGSize(width: 80, height: 80))
        }
        
        albumBtn.mas_makeConstraints { (make) in
            make?.top.equalTo()(wechatBtn.mas_bottom)?.offset()(28)
            make?.left.equalTo()(customImageView.mas_right)?.offset()(32)
            make?.size.mas_equalTo()(CGSize(width: 80, height: 80   ))
        }
        
        contentLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.view)?.offset()(20)
            make?.right.equalTo()(self.view)?.offset()(-20)
            make?.top.equalTo()(customImageView.mas_bottom)?.offset()(12)
        }
        
        title4ImageView.mas_makeConstraints { (make) in
            make?.bottom.equalTo()(self.view)?.offset()(-39.5)
            make?.left.equalTo()(self.view)?.offset()(20)
            make?.size.mas_equalTo()(CGSize(width: 15, height: 15))
        }
        
        title3ImageView.mas_makeConstraints { (make) in
            make?.bottom.equalTo()(title4ImageView.mas_top)?.offset()(-8)
            make?.left.equalTo()(self.view)?.offset()(20)
            make?.size.mas_equalTo()(CGSize(width: 15, height: 15))
        }

        title2ImageView.mas_makeConstraints { (make) in
            make?.bottom.equalTo()(title3ImageView.mas_top)?.offset()(-8)
            make?.left.equalTo()(self.view)?.offset()(20)
            make?.size.mas_equalTo()(CGSize(width: 15, height: 15))
        }

        title1ImageView.mas_makeConstraints { (make) in
            make?.bottom.equalTo()(title2ImageView.mas_top)?.offset()(-8)
            make?.left.equalTo()(self.view)?.offset()(20)
            make?.size.mas_equalTo()(CGSize(width: 15, height: 15))
        }

        titleImageView.mas_makeConstraints { (make) in
            make?.bottom.equalTo()(title1ImageView.mas_top)?.offset()(-8)
            make?.left.equalTo()(self.view)?.offset()(20)
            make?.size.mas_equalTo()(CGSize(width: 20, height: 20))
        }
        
        title4Label.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(title4ImageView)
            make?.left.equalTo()(title4ImageView.mas_right)?.offset()(8)
        }
        
        title3Label.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(title3ImageView)
            make?.left.equalTo()(title3ImageView.mas_right)?.offset()(8)
        }

        title2Label.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(title2ImageView)
            make?.left.equalTo()(title2ImageView.mas_right)?.offset()(8)
        }

        title1Label.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(title1ImageView)
            make?.left.equalTo()(title1ImageView.mas_right)?.offset()(8)
        }

        titleLabel.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(titleImageView)
            make?.left.equalTo()(titleImageView.mas_right)?.offset()(6)
        }
    }
}
