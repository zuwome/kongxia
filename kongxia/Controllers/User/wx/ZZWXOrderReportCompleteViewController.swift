//
//  ZZWXOrderReportCompleteViewController.swift
//  zuwome
//
//  Created by qiming xiao on 2019/2/28.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

class ZZWXOrderReportCompleteViewController: UIViewController {
    var wx: String = ""
    var isBuy: Bool = false
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ZZOrderDetailReportCell.self, forCellReuseIdentifier: ZZOrderDetailReportCell.cellIdentifier())
        tableView.estimatedRowHeight = 40
        return tableView
    }()
    
    // 从旧的微信评价页面过来
    @objc var didCamefromOldWechatReview: Bool = false
    
    @objc var isCameStraightFromReview: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .bottom;
        layoutNavi()
        layout()
        fetchCustomerServiceWechat()

    }
    
    @objc class func create() -> ZZWXOrderReportCompleteViewController {
        let orderVC = ZZWXOrderReportCompleteViewController(wx: nil, isBuy: true)
        orderVC.didCamefromOldWechatReview = true
        return orderVC
    }
    
    @objc init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(wx: String?, isBuy: Bool) {
        self.wx = wx ?? ""
        self.isBuy = isBuy
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MAKR: - Request
extension ZZWXOrderReportCompleteViewController {
    // 获取客服微信号
    func fetchCustomerServiceWechat() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ZZRequest.method("GET", path: "/api/user/kefu", params: nil) { (error, data, nil) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let data = data {
                if let wx = data as? String {
                    self.wx = wx
                }
            }
            self.tableView.reloadData()
        }
    }
}

// MARK: - Navigator
extension ZZWXOrderReportCompleteViewController {
    @objc func popBack() {
        self.dismiss(animated: true, completion: nil)
//        if let viewControllers = self.navigationController?.viewControllers {
//            
//            if isCameStraightFromReview {
//                self.navigationController?.popViewController(animated: false)
//                return
//            }
//            self.navigationController?.popViewController(animated: false)
//        }
    }
    
}

// MARK: - UITableViewDelgate, UITablviewDataSource
extension ZZWXOrderReportCompleteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 举报
        let cell: ZZOrderDetailReportCell = tableView.dequeueReusableCell(withIdentifier: ZZOrderDetailReportCell.cellIdentifier(), for: indexPath) as! ZZOrderDetailReportCell
        cell.selectionStyle = .none
        cell.didCamefromOldWechatReview = didCamefromOldWechatReview
        cell.configData(isBuy: isBuy, wx: wx)
        return cell
    }
}

// MARK: - Layout
extension ZZWXOrderReportCompleteViewController {
    func layoutNavi() {
        if didCamefromOldWechatReview {
            self.title = "无法添加微信号求助"
        }
        else {
            self.title = "举报微信号"
        }
        
        let leftBtn = UIBarButtonItem(image: UIImage.init(named: "back")?.withRenderingMode(.alwaysOriginal),
                                      style: .plain,
                                      target: self,
                                      action: #selector(popBack))
        
        self.navigationItem.leftBarButtonItem = leftBtn
    }
    
    func layout() {
        self.view.backgroundColor = UIColor.rgbColor(247, 247, 247)
        self.view.addSubview(self.tableView)
        tableView.mas_makeConstraints { (make) in
            make?.edges.equalTo()(self.view)
        }
    }
}
