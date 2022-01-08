//
//  ZZWechatOrdersViewController.swift
//  zuwome
//
//  Created by qiming xiao on 2019/2/25.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

class ZZWechatOrdersViewController: UIViewController {
    var wxOrders: [ZZWXOrderModel] = []
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = hexColor("#f6f6f6")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ZZWXOrderCell.self, forCellReuseIdentifier: ZZWXOrderCell.cellIdentifier())
        tableView.estimatedRowHeight = 40
        
        tableView.mj_header = ZZRefreshHeader.init(refreshingBlock: {
            print("refreshing")
            self.requestData()
        })
        
        
        return tableView
    }()
}

// MARK: - Life Cycle
extension ZZWechatOrdersViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutNavi()
        layout()
        requestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

// MARK: - Navigator
extension ZZWechatOrdersViewController {
    @objc func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // 跳转到我的微信界面
    @objc func goToMyWeChatView() {
        MobClick.event(Event_click_usercenter_wx)
        let myWXViewController = ZZWXViewController()
        myWXViewController.user = ZZUserHelper.shareInstance()?.loginer!
        self.navigationController?.pushViewController(myWXViewController, animated: true)
    }
    
    func jumpToOrderDetails(order: ZZWXOrderModel?) {
        if let order = order {
            let detailsVC = ZZWXOrderDetailViewController(wxOrder: order)
            detailsVC.delegate = self
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}

// MARK: - ZZWXOrderCellDelegate
extension ZZWechatOrdersViewController: ZZWXOrderCellDelegate {
    func iconSelected(_ order: ZZWXOrderModel?) {
        jumpToOrderDetails(order: order)
    }
}

// MARK: - Request
var pageKey = 0
extension ZZWechatOrdersViewController {
    var page: Int {
        set {
            objc_setAssociatedObject(self, &pageKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            if let page = objc_getAssociatedObject(self, &pageKey) as? Int {
                return page
            }
            return -1
        }
    }
    
    @objc class func fetchOrders(complete: @escaping ( _ ordersArray: NSArray) -> Void) {
        guard let uid = ZZUserHelper.shareInstance()!.loginerId else {
            return
        }
        let params: [String: Any] = [
            "userId": uid,
            "pageIndex": 0,
        ]
        MBProgressHUD().show(true)
        ZZRequest.method("GET", path: "/api/wechat/wechatSeenList", params: params) { (error, data, _) in
            MBProgressHUD().hide(true)
            guard let error = error else {
                var ordersArray = [ZZWXOrderModel]()
                if let dataArray = data as? Array<Any> {
                    if dataArray.count > 0 {
                        for data in dataArray {
                            if let dataDic = data as? Dictionary<String, Any> {
                                if let model = ZZWXOrderModel(JSON: dataDic) {
                                    ordersArray.append(model)
                                }
                            }
                        }
                        
                    }
                    
                }
                complete(ordersArray as NSArray)
                return
            }
            complete([])
            ZZHUD.showError(withStatus: error.message)
        }
    }
    
    func requestData() {
        page = 1
        request()
    }
    
    func requestMoreData() {
        page += 1
        request()
    }
    
    func request() {
        guard let uid = ZZUserHelper.shareInstance()!.loginerId else {
            return
        }
        
        let params: [String: Any] = [
            "userId": uid,
            "pageIndex": page,
        ]
        ZZRequest.method("GET", path: "/api/wechat/wechatSeenList", params: params) { (error, data, _) in
            if let mj_header = self.tableView.mj_header {
                if mj_header.isRefreshing {
                    mj_header.endRefreshing()
                }
            }
            
            if let mj_footer = self.tableView.mj_footer {
                if mj_footer.isRefreshing {
                    mj_footer.endRefreshing()
                }
            }
            
            guard let error = error else {
                if let dataArray = data as? Array<Any> {
                    if dataArray.count > 0 {
                        var ordersArray = [ZZWXOrderModel]()
                        for data in dataArray {
                            if let dataDic = data as? Dictionary<String, Any> {
                                if let model = ZZWXOrderModel(JSON: dataDic) {
                                    ordersArray.append(model)
                                }
                            }
                        }
                        if self.page == 1 {
                            self.wxOrders = ordersArray
                            if ordersArray.count >= 10 {
                                self.tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
                                    print("request more")
                                    self.requestMoreData()
                                })
                            }
                        }
                        else {
                            if ordersArray.count > 0 {
                                self.wxOrders += ordersArray
                            }
                        }
                    }
                }
                self.tableView.reloadData()
                return
            }
            ZZHUD.showError(withStatus: error.message)
        }
    }
}

// MARK: - ZZWXOrderDetailViewControllerDelegate
extension ZZWechatOrdersViewController: ZZWXOrderDetailViewControllerDelegate {
    func orderStatusChanged(viewController: UIViewController) {
        request()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ZZWechatOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wxOrders.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ZZWXOrderCell = tableView.dequeueReusableCell(withIdentifier: ZZWXOrderCell.cellIdentifier(), for: indexPath) as! ZZWXOrderCell
        let model = wxOrders[indexPath.row]
        cell.configData(model)
        cell.delegate = self;
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        jumpToOrderDetails(order: wxOrders[indexPath.row])
    }
}

// MARK: - Layout
extension ZZWechatOrdersViewController {
    func layoutNavi() {
        self.title = "微信订单";
        
        let leftBtn = UIBarButtonItem(image: UIImage.init(named: "back"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(popBack))
        
        self.navigationItem.leftBarButtonItem = leftBtn
        
        let rightBtn = UIBarButtonItem(title: "填写微信号",
                                       style: .plain,
                                       target: self,
                                       action: #selector(goToMyWeChatView))
        rightBtn.setTitleTextAttributes([NSAttributedString.Key.font: sysFont(15.0)],
                                        for: .normal)
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    func layout() {
        self.view.backgroundColor = .white;
        
        self.view.addSubview(self.tableView);
        self.tableView.mas_makeConstraints { (make) in
            make?.edges.equalTo()(self.view)
        }
    }
}
