//
//  ZZWXOrderDetailViewController.swift
//  zuwome
//
//  Created by qiming xiao on 2019/2/25.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit
import ObjectMapper

protocol ZZWXOrderDetailViewControllerDelegate: NSObjectProtocol {
    func orderStatusChanged(viewController: UIViewController)
}

class ZZWXOrderDetailViewController: UIViewController {
    weak var delegate: ZZWXOrderDetailViewControllerDelegate?
    var orderModel: ZZWXOrderModel?
    var cellTypesArray: [[String]] = []
    
    var selectedImage: UIImage?
    var selectedImageURL: String?
    
    var valuationModel: WXOrderEvaluationModel?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = hexColor("#f6f6f6")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ZZOrderDetailStatusCell.self,
                           forCellReuseIdentifier: ZZOrderDetailStatusCell.cellIdentifier())
        
        tableView.register(ZZOrderDetailUserInfoCell.self,
                           forCellReuseIdentifier: ZZOrderDetailUserInfoCell.cellIdentifier())
        
        tableView.register(ZZOrderDetailWechatCell.self,
                           forCellReuseIdentifier: ZZOrderDetailWechatCell.cellIdentifier())
        
        tableView.register(ZZOrderDetailReportCell.self,
                           forCellReuseIdentifier: ZZOrderDetailReportCell.cellIdentifier())
        
        tableView.register(ZZOrderDetailUploadCell.self,
                           forCellReuseIdentifier: ZZOrderDetailUploadCell.cellIdentifier())
        
        tableView.register(ZZOrderDetailActionsCell.self,
                           forCellReuseIdentifier: ZZOrderDetailActionsCell.cellIdentifier())
        
        tableView.register(ZZOrderEvaluationCell.self,
                           forCellReuseIdentifier: ZZOrderEvaluationCell.cellIdentifier())
        tableView.estimatedRowHeight = 40
       
        return tableView
    }()
    
    @objc class func create(orderID: String) -> ZZWXOrderDetailViewController {
        let orderModel = ZZWXOrderModel()
        let doc = WXOrderInfoModel()
        doc._id = orderID
        orderModel._doc = doc
        let orderVC = ZZWXOrderDetailViewController(wxOrder: orderModel)
        return orderVC
    }
    
    init(wxOrder: ZZWXOrderModel) {
        self.orderModel = wxOrder
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutNavi()
        createNaviRightBtn()
        layout()
        fetchOrderDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // 根据每个订单的状态去布局不一样的cell
    func createCellArrays() {
        guard let orderModel = orderModel else {
            return
        }
        
        cellTypesArray.removeAll()
        let status = orderModel.orderStatus
        
        switch status {
        case .buyer_bought, .buyer_waitToBeEvaluated:
            // 买家_待确认
            var section0: [String] = []
            section0.append(ZZOrderDetailStatusCell.cellIdentifier())
            section0.append(ZZOrderDetailUserInfoCell.cellIdentifier())
            section0.append(ZZOrderDetailWechatCell.cellIdentifier())
            cellTypesArray.append(section0)
            
            var section1: [String] = []
            section1.append(ZZOrderDetailActionsCell.cellIdentifier())
            cellTypesArray.append(section1)

        case .buyer_confirm:
            // 买方已添加_待评价
            var section0: [String] = []
            section0.append(ZZOrderDetailStatusCell.cellIdentifier())
            section0.append(ZZOrderDetailUserInfoCell.cellIdentifier())
            section0.append(ZZOrderDetailWechatCell.cellIdentifier())
            cellTypesArray.append(section0)
            
            var section1: [String] = []
            section1.append(ZZOrderEvaluationCell.cellIdentifier())
            section1.append(ZZOrderDetailActionsCell.cellIdentifier())
            cellTypesArray.append(section1)
        case .buyer_commented:
            // 买方已添加_已评价
            var section0: [String] = []
            section0.append(ZZOrderDetailStatusCell.cellIdentifier())
            section0.append(ZZOrderDetailUserInfoCell.cellIdentifier())
            section0.append(ZZOrderDetailWechatCell.cellIdentifier())
            cellTypesArray.append(section0)
            
            var section1: [String] = []
            section1.append(ZZOrderEvaluationCell.cellIdentifier())
            section1.append(ZZOrderDetailActionsCell.cellIdentifier())
            cellTypesArray.append(section1)
        case .buyer_reporting:
            // 卖家_举报中
            var section0: [String] = []
            section0.append(ZZOrderDetailStatusCell.cellIdentifier())
            section0.append(ZZOrderDetailUserInfoCell.cellIdentifier())
            section0.append(ZZOrderDetailWechatCell.cellIdentifier())
            cellTypesArray.append(section0)
            
            var section1: [String] = []
            section1.append(ZZOrderDetailReportCell.cellIdentifier())
            cellTypesArray.append(section1)
        case .seller_bought:
            // 卖家_待确认
            var section0: [String] = []
            section0.append(ZZOrderDetailStatusCell.cellIdentifier())
            section0.append(ZZOrderDetailUserInfoCell.cellIdentifier())
            cellTypesArray.append(section0)
            
            var section1: [String] = []
            section1.append(ZZOrderDetailUploadCell.cellIdentifier())
            cellTypesArray.append(section1)
        case .seller_confirm:
            // 卖家_已确认,等待买家确认
            var section0: [String] = []
            section0.append(ZZOrderDetailStatusCell.cellIdentifier())
            section0.append(ZZOrderDetailUserInfoCell.cellIdentifier())
            cellTypesArray.append(section0)
            
            var section1: [String] = []
            section1.append(ZZOrderDetailUploadCell.cellIdentifier())
            cellTypesArray.append(section1)
        case .seller_complete, .seller_autoComplete:
            // 卖家_已确认,等待买家确认
            var section0: [String] = []
            section0.append(ZZOrderDetailStatusCell.cellIdentifier())
            section0.append(ZZOrderDetailUserInfoCell.cellIdentifier())
            cellTypesArray.append(section0)
            
            var section1: [String] = []
            section1.append(ZZOrderDetailActionsCell.cellIdentifier())
            cellTypesArray.append(section1)
        case .seller_waitToBeEvaluated:
            // 卖家_已确认,等待买家确认
            var section0: [String] = []
            section0.append(ZZOrderDetailStatusCell.cellIdentifier())
            section0.append(ZZOrderDetailUserInfoCell.cellIdentifier())
            cellTypesArray.append(section0)
            
            var section1: [String] = []
            section1.append(ZZOrderDetailActionsCell.cellIdentifier())
            cellTypesArray.append(section1)
            
        case .seller_beingReported:
            // 卖家_被举报中
            var section0: [String] = []
            section0.append(ZZOrderDetailStatusCell.cellIdentifier())
            section0.append(ZZOrderDetailUserInfoCell.cellIdentifier())
            section0.append(ZZOrderDetailWechatCell.cellIdentifier())
            cellTypesArray.append(section0)
            
            var section1: [String] = []
            section1.append(ZZOrderDetailReportCell.cellIdentifier())
            cellTypesArray.append(section1)
    
        case .buyer_reportSuccess, .buyer_reportFail:
            // 买家/卖家 举报成功失败
            var section0: [String] = []
            section0.append(ZZOrderDetailStatusCell.cellIdentifier())
            section0.append(ZZOrderDetailUserInfoCell.cellIdentifier())
            section0.append(ZZOrderDetailWechatCell.cellIdentifier())
            cellTypesArray.append(section0)
            
            var section1: [String] = []
            section1.append(ZZOrderDetailActionsCell.cellIdentifier())
            cellTypesArray.append(section1)
            
        case .seller_reportSuccess, .seller_reportFail:
            // 买家/卖家 举报成功失败
            var section0: [String] = []
            section0.append(ZZOrderDetailStatusCell.cellIdentifier())
            section0.append(ZZOrderDetailUserInfoCell.cellIdentifier())
            cellTypesArray.append(section0)
            
            var section1: [String] = []
            section1.append(ZZOrderDetailActionsCell.cellIdentifier())
            cellTypesArray.append(section1)
        default:
            var section1: [String] = []
            section1.append(ZZOrderDetailActionsCell.cellIdentifier())
            cellTypesArray.append(section1)
        }
        tableView.reloadData()
    }
    
    func showPhotoBrowser() {
        if #available(iOS 11.0, *) {
            UITableView.appearance().contentInsetAdjustmentBehavior = .always
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .always
            UICollectionView.appearance().contentInsetAdjustmentBehavior = .always
        }
        
        let browser = UIImagePickerController()
        browser.sourceType = .photoLibrary
        browser.delegate = self;
        self.present(browser, animated: true, completion: nil)
    }
    
    func addImage(_ image: UIImage?) {
        guard image != nil else {
            selectedImage = nil
            tableView.reloadData()
            return
        }
        selectedImage = image
        tableView.reloadData()
    }
    
    @objc func sellerComfirm() {
        weak var weakSelf = self
        // 第一步: 上传图片
        if let image = selectedImage {
            uploadPhotoToQniu(image: image) { (isSuccess, photo) in
                if isSuccess && photo != nil {
                    weakSelf?.selectedImageURL = photo?.url
                    weakSelf?.confirmWX()
                }
            }
        }
        else {
            confirmWX()
        }
    }
    
    @objc func configData(wxorderID: String) {
        orderModel = ZZWXOrderModel()
        orderModel?._doc?._id = wxorderID
        fetchOrderDetails()
    }
}

// MARK: - Request
extension ZZWXOrderDetailViewController {
    func fetchOrderDetails() {
        if let orderID = orderModel?._doc?._id  {
            let url = "/api/wechat/detailSeen/\(orderID)"
            MBProgressHUD().show(true)
            ZZRequest.method("GET", path: url, params: nil) { (error, data, _) in
                MBProgressHUD().hide(true)
                guard let error = error else {
                    if let dataDic = data as? Dictionary<String, Any> {
                        if let model = ZZWXOrderModel(JSON: dataDic) {
                            self.orderModel = model
                            self.createNaviRightBtn()
                            
                            if self.orderModel?.orderStatus != .buyer_commented {
                                self.tableView.backgroundColor = rgbColor(247, 247, 247)
                            }
                            else {
                                self.tableView.backgroundColor = .white
                            }
                            
                            if model.orderStatus == .buyer_reporting || model.orderStatus == .seller_beingReported {
                                self.fetchCustomerServiceWechat()
                            }
                            else {
                                self.createCellArrays()
                                self.createNaviRightBtn()
                            }
                        }
                    }
                    return
                }
                ZZHUD.showError(withStatus: error.message)
            }
        }
    }
    
    // 确认添加
    func confirmWX() {
        var params: [String: Any] = [
            "from": orderModel!._doc!.from!._id!, // 用户id
            "to": orderModel!._doc!.to!._id!,   // 达人id
            "wechatseenId": orderModel!._doc!._id!,  // 微信查看订单id
            "userId": ZZUserHelper.shareInstance()!.loginerId!,  // 登录用户id
            "confirmFlag": 1, // 是否确认添加成功  1确认
            "channel": "wallet",  // 渠道
            "fromImg": "", // 用户方上传图片地址
        ]
        
        if orderModel!.orderStatus == .seller_bought {
            params["toImg"] = selectedImageURL   // // 达人方上传图片地址
        }
        MBProgressHUD().show(true)
        ZZRequest.method("POST", path: "/api/wechat/confirmWechat", params: params) { (error, data, _) in
            MBProgressHUD().hide(true)
            if error == nil {
                ZZHUD.showTastInfo(with: "添加成功")
                self.delegate?.orderStatusChanged(viewController: self)
                
                self.fetchOrderDetails()
            }
            else {
                ZZHUD.showError(withStatus: error?.message ?? "")
            }
        }
    }
    
    // 评价微信
    func evaluateWXOrder() {
        guard let valuationModel = valuationModel else {
            ZZHUD.showError(withStatus: "请评价")
            return
        }
        
        if valuationModel.score == -1 {
            return
        }
        
        if valuationModel.score == 1 {
            if valuationModel.content == nil || valuationModel.content?.count == 0 {
                ZZHUD.showError(withStatus: "请选择差评理由")
                return
            }
        }
        
        var contentStr: String? = ""
        if let contentArray = valuationModel.content {
            if let data = try? JSONSerialization.data(withJSONObject: contentArray, options: []) {
                contentStr = String(data: data, encoding: String.Encoding.utf8)
            }
        }
        
        let params: [String: Any] = [
            "from": orderModel!._doc!.from!._id!,
            "to": orderModel!._doc!.to!._id!,
            "content": contentStr ?? "",
            "score": valuationModel.score!,
            "wechatseenId" : orderModel!._doc!._id!
        ]

        MBProgressHUD.showAdded(to: self.view, animated: true)
        ZZRequest.method("POST", path: "/api/wechat/addComment", params: params) { (error, data, _) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error == nil {
                // 评价成功
                ZZHUD.showTastInfo(with: "评价成功")
                self.delegate?.orderStatusChanged(viewController: self)
                self.fetchOrderDetails()
            }
            else {
                ZZHUD.showError(withStatus: error?.message ?? "")
            }
            
        }
    }
    
    // 获取客服微信号
    func fetchCustomerServiceWechat() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        ZZRequest.method("GET", path: "/api/user/kefu", params: nil) { (error, data, nil) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let data = data {
                if let wx = data as? String {
                    self.orderModel?.customerService = wx
                }
            }
            self.createCellArrays()
        }
    }
    
    /* 上传照片
     1.首先吧图片上传到七牛服务器
     2.拿到图片地址之后,吧地址上传到自己的服务器上
     3.如果失败上传失败日志到自己服务器
     */
    func uploadPhotoToQniu(image: UIImage, completeBlock: @escaping (Bool, ZZPhoto?) -> Void) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let data = ZZUtils.userImageRepresentationData(with: image)
        ZZUploader.put(data) { (info, key, resp) in
            if let resp = resp {
                // 上传成功
                let photo = ZZPhoto()
                photo.url = (resp["key"] as! String)
                
                // 上传自己服务器
                photo.add({ (error, data, _) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if error != nil {
                        ZZHUD.showError(withStatus: error?.message)
                        completeBlock(false, nil)
                    }
                    else {
                        let newPhoto = try? ZZPhoto(dictionary: data as? [AnyHashable : Any])
                        completeBlock(true, newPhoto)
                    }
                })
            }
            else {
                // 上传失败
                completeBlock(false, nil)
                self.uploadPhotoToQiNiuFailed(info: info)
            }
        }
    }
    
    // 上传上传七牛失败日志
    func uploadPhotoToQiNiuFailed(info: QNResponseInfo?) {
        MBProgressHUD.hide(for: self.view, animated: true)
        ZZHUD.showError(withStatus: "上传失败")
        
        if ZZUserHelper.shareInstance()!.unreadModel.open_log {
            var subParam = [
                "type": "上传用户证件照错误"
            ]
            
            if ZZUserHelper.shareInstance()!.uploadToken != nil {
                subParam["uploadToken"] = ZZUserHelper.shareInstance()!.uploadToken
            }
            
            if let info = info {
                if info.error != nil {
                    subParam["uploadToken"] = info.error.localizedDescription
                }
                subParam["uploadToken"] = "\(info.statusCode)"
            }
            
            let param: [AnyHashable : Any] = [
                "uid": ZZUserHelper.shareInstance()!.loginer.uid,
                "content": ZZUtils.dictionary(toJson: subParam)
            ]
            ZZUserHelper.uploadLog(withParam: param, next: nil)
        }
    }
    
    // 打招呼判断
    func sayHiStatus() {
        
        let orderUserInfo: WXOrderUserInfoModel = orderModel!._doc?.from!._id! == ZZUserHelper.shareInstance()!.loginerId ? orderModel!._doc!.to! : orderModel!._doc!.from!

        if let userID = orderUserInfo._id {
            ZZRequest.method("GET", path: "/api/user/\(userID)/say_hi_status", params: nil) { (error, data, _) in
                if error != nil {
                    ZZHUD.showError(withStatus: error?.message ?? "错误")
                    return
                }
                if let dataDic = data as? Dictionary<String, Any> {
                    if dataDic["say_hi_status"] as? String == "0" {
                        if ZZUserHelper.shareInstance()?.loginer.avatar_manual_status == 1 {
                            UIAlertView.show(withTitle: "提示",
                                             message: "打招呼需要上传本人五官正脸清晰照，您的头像还在审核中，暂不可打招呼",
                                             cancelButtonTitle: "知道了",
                                             otherButtonTitles: nil,
                                             tap: nil)
                        }
                    }
                    else {
                        self.goToChatView()
                    }
                }
            }
        }
    }
}

// MARK: - Navigator
extension ZZWXOrderDetailViewController {
    @objc func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func goTologinView() {
        LoginHelper.sharedInstance().showLoginView(in: self)
    }
    
    // 举报页面
    func goToReportView() {
        let reportVC = ZZWXOrderReportViewController(order: orderModel!)
        reportVC.delegate = self
        self.navigationController?.pushViewController(reportVC, animated: true)
    }
    
    // 聊天页面
    func goToChatView() {
        MobClick.event(Event_user_detail_chat)
        
        guard ZZUserHelper.shareInstance()!.isLogin else {
            goTologinView()
            return
        }
        
        guard !ZZUtils.isBan() else {
            return
        }

        let orderUserInfo: WXOrderUserInfoModel = orderModel!._doc?.from!._id! == ZZUserHelper.shareInstance()!.loginerId ? orderModel!._doc!.to! : orderModel!._doc!.from!
        
        let chatController = ZZChatViewController()
        chatController.nickName = orderUserInfo.nickname
        chatController.uid = orderUserInfo._id
        chatController.portraitUrl = orderUserInfo.avatar
        self.navigationController?.pushViewController(chatController, animated: true)
    }
    
    func gotoUploadPicture() {
        let vc = ZZPerfectPictureViewController()
        vc.isFaceVC = false
        vc.faces = ZZUserHelper.shareInstance()!.loginer.faces as? [String] ?? [String]()
        vc.user = ZZUserHelper.shareInstance()!.loginer
        
        let user = ZZUser()
        let orderUserInfo: WXOrderUserInfoModel = orderModel!._doc?.from!._id! == ZZUserHelper.shareInstance()!.loginerId ? orderModel!._doc!.to! : orderModel!._doc!.from!
        user.nickname = orderUserInfo.nickname
        user.uid = orderUserInfo._id
        
        vc.from = user
        vc.type = .chat
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 个人页
    func goToUserInfo(uid: String) {
        let controller = ZZRentViewController()
        controller.uid = uid
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - ZZOrderDetailUploadCellDelegate
extension ZZWXOrderDetailViewController: ZZOrderDetailUploadCellDelegate {
    // 全屏显示
    func fullScreenExamplePhoto(cell: ZZOrderDetailUploadCell, image: UIImage) {
        let data1 = YBImageBrowseCellData()
        data1.imageBlock = {
            return YBImage(named: "shilitupian")
        }
        let browser = YBImageBrowser()
        browser.dataSourceArray = [data1]
        browser.show()

    }
    
    // 上传
    func uploadPhoto(cell: ZZOrderDetailUploadCell) {
        if orderModel?.orderStatus == .seller_confirm {
            if let wechatImage = orderModel?._doc?.to_wechat_img {
                let data = YBImageBrowseCellData()
                data.url = URL(string: wechatImage)
                
                let browser = YBImageBrowser()
                browser.dataSourceArray = [data]
                browser.show()
            }
        }
        else {
            guard orderModel?.orderStatus == .seller_bought else {
                return
            }
            weak var weakSelf = self
            var changeTitle = "从相册选择"
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            if selectedImage != nil {
                changeTitle = "更换"
                let action1 = UIAlertAction(title: "删除", style: .default) { (action) in
                    weakSelf?.addImage(nil)
                }
                alertController.addAction(action1)
            }
            
            let action2 = UIAlertAction(title: changeTitle, style: .default) { (action) in
                weakSelf?.showPhotoBrowser()
            }
            alertController.addAction(action2)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - ZZOrderDetailActionsCellDelegate
extension ZZWXOrderDetailViewController: ZZOrderDetailActionsCellDelegate {
    // 聊天
    func chat(cell: ZZOrderDetailActionsCell) {
        sayHiStatus()
//        goToChatView()
    }
    
    // 买方确认添加成功
    func confirm(cell: ZZOrderDetailActionsCell) {
        let alertController = UIAlertController(title: "温馨提示", message: "确认添加成功后，打赏会自动转入对方账户", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "稍后", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        let action1 = UIAlertAction(title: "确定", style: .default) { (action) in
            self.confirmWX()
        }
        alertController.addAction(action1)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 举报
    func report(cell: ZZOrderDetailActionsCell) {
        goToReportView()
    }
    
    func review(cell: ZZOrderDetailActionsCell) {
        evaluateWXOrder()
    }
}

// MARK: - ZZOrderDetailWechatCellDelegate
extension ZZWXOrderDetailViewController: ZZOrderDetailWechatCellDelegate {
    // 复制微信号
    func pasteWeChat(view: ZZOrderDetailWechatCell) {
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = orderModel?._doc?.to?.wechat?.no ?? ""
        ZZHUD.showTastInfo(with: "复制成功，前往微信添加")
    }
}

// MARK: - ZZOrderDetailUserInfoCellDelegate
extension ZZWXOrderDetailViewController: ZZOrderDetailUserInfoCellDelegate {
    func showUserInfo(userID: String?) {
        if let userID = userID {
            goToUserInfo(uid: userID)
        }
    }
}

// MARK: - ZZOrderEvaluationCellDelegate
extension ZZWXOrderDetailViewController: ZZOrderEvaluationCellDelegate {
    func chooseBadReview(cell: ZZOrderEvaluationCell, review: [String]) {
        print(review)
        if valuationModel == nil {
            valuationModel = WXOrderEvaluationModel()
        }
        
        valuationModel?.score = 1
        
        valuationModel?.content = review
    }
    
    func chooseGoodOrBad(cell: ZZOrderEvaluationCell, isGood: Bool) {
        print(isGood)
        
        if valuationModel == nil {
            valuationModel = WXOrderEvaluationModel()
        }
        
        valuationModel?.score = isGood ? 5 : 1
        valuationModel?.content = nil
    }

}

// MARK: - ZZWXOrderReportViewController
extension ZZWXOrderDetailViewController: ZZWXOrderReportViewControllerDelegate {
    func reported(viewController: ZZWXOrderReportViewController) {
        fetchOrderDetails()
        delegate?.orderStatusChanged(viewController: self)
    }
}

// MARK: - UITableViewDelgate, UITablviewDataSource
extension ZZWXOrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellTypesArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypesArray[section].count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = cellTypesArray[indexPath.section][indexPath.row]
        
        if identifier == ZZOrderDetailStatusCell.cellIdentifier() {
            // 订单状态
            let cell: ZZOrderDetailStatusCell = tableView.dequeueReusableCell(withIdentifier: ZZOrderDetailStatusCell.cellIdentifier(), for: indexPath) as! ZZOrderDetailStatusCell
            if let isBuy = orderModel?.isBuy  {
                if isBuy {
                    var highLightText: String? = nil
                    if let highlightDic = orderModel?.from_msg {
                        let array = highlightDic["highlight_text"]
                        if let array = array as? Array<Any> {
                            if array.count > 0 {
                                if let highlight_text = array[0] as? String {
                                    highLightText = highlight_text
                                }
                            }
                        }
                    }
                    cell.orderStatus(status: orderModel!.orderStatus,
                                     statusTitle: orderModel?.from_msg?["title"] as? String,
                                     hightLightedStr: highLightText,
                                     statusDes: orderModel?.from_msg?["content"]  as? String)
                }
                else {
                    var highLightText: String? = nil
                    if let highlightDic = orderModel?.to_msg {
                        let array = highlightDic["highlight_text"]
                        if let array = array as? Array<Any> {
                            if array.count > 0 {
                                if let highlight_text = array[0] as? String {
                                    highLightText = highlight_text
                                }
                            }
                        }
                    }
                    cell.orderStatus(status: orderModel!.orderStatus,
                                     statusTitle: orderModel?.to_msg?["title"] as? String,
                                     hightLightedStr: highLightText,
                                     statusDes: orderModel?.to_msg?["content"]  as? String)
                }
            }
            
            cell.selectionStyle = .none
            return cell
        }
        else if identifier == ZZOrderDetailUserInfoCell.cellIdentifier() {
            // 用户信息
            let cell: ZZOrderDetailUserInfoCell = tableView.dequeueReusableCell(withIdentifier: ZZOrderDetailUserInfoCell.cellIdentifier(), for: indexPath) as! ZZOrderDetailUserInfoCell
            cell.delegate = self
            if let isBuy = orderModel?.isBuy  {
                if isBuy {
                    cell.userInfo(isBuy: isBuy, user: orderModel?._doc?.to!, createTime: orderModel?._doc?.created_at!)
                }
                else {
                    cell.userInfo(isBuy: isBuy, user: orderModel?._doc?.from!, createTime: orderModel?._doc?.created_at!)
                }
            }
            cell.selectionStyle = .none
            return cell
        }
        else if identifier == ZZOrderDetailWechatCell.cellIdentifier() {
            // 微信号
            let cell: ZZOrderDetailWechatCell = tableView.dequeueReusableCell(withIdentifier: ZZOrderDetailWechatCell.cellIdentifier(), for: indexPath) as! ZZOrderDetailWechatCell
            
            cell.wxNum(wxNum: orderModel?._doc?.to?.wechat?.no ?? "")
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else if identifier == ZZOrderDetailReportCell.cellIdentifier() {
            // 举报
            let cell: ZZOrderDetailReportCell = tableView.dequeueReusableCell(withIdentifier: ZZOrderDetailReportCell.cellIdentifier(), for: indexPath) as! ZZOrderDetailReportCell
            cell.configData(isBuy: orderModel!.isBuy, wx: orderModel?.customerService ?? "")
            cell.selectionStyle = .none
            return cell
        }
        else if identifier == ZZOrderDetailUploadCell.cellIdentifier() {
            // 上传信息
            let cell: ZZOrderDetailUploadCell = tableView.dequeueReusableCell(withIdentifier: ZZOrderDetailUploadCell.cellIdentifier(), for: indexPath) as! ZZOrderDetailUploadCell
            cell.delegate = self
            if let wechatImage = orderModel?._doc?.to_wechat_img {
                cell.screenShotImageView.photoImageView.sd_setImage(with: URL(string: wechatImage), completed: nil)
                cell.screenShotDescLabel.isHidden = true
            }
            else {
                cell.screenShotImageView.photoImageView.image = selectedImage
                cell.screenShotDescLabel.isHidden = false
            }
            
            cell.selectionStyle = .none
            return cell
        }
        else if identifier == ZZOrderDetailActionsCell.cellIdentifier() {
            // 按钮
            let cell: ZZOrderDetailActionsCell = tableView.dequeueReusableCell(withIdentifier: ZZOrderDetailActionsCell.cellIdentifier(), for: indexPath) as! ZZOrderDetailActionsCell
            cell.delegate = self
            cell.tableView = tableView
            cell.selectionStyle = .none
            cell.setConfigure(orderModel!.orderStatus)
            
            if orderModel?.orderStatus == .buyer_commented {
                var didHaveComment = true
                if let _ : ZZWxOrderCommentModel = orderModel?._doc?.wechat_comment {
                    didHaveComment = true
                }
                else {
                    didHaveComment = false
                }
                cell.didHasComment(didHaveComment)
            }
            return cell
        }
        else if identifier == ZZOrderEvaluationCell.cellIdentifier() {
            // 评价
            let cell: ZZOrderEvaluationCell = tableView.dequeueReusableCell(withIdentifier: ZZOrderEvaluationCell.cellIdentifier(), for: indexPath) as! ZZOrderEvaluationCell
            cell.delegate = self
            cell.evaluatedContent(commmentModel: orderModel!._doc!.wechat_comment, orderStatus: orderModel!.orderStatus)
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == cellTypesArray.count - 1 {
            return 0.1
        }
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = rgbColor(247, 247, 247)
        if (section == cellTypesArray.count - 1) && !(self.orderModel?.orderStatus == .buyer_bought
            || self.orderModel?.orderStatus == .buyer_waitToBeEvaluated)  {
            view.backgroundColor = .white
        }
        
        return view
    }
}

// MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate
extension ZZWXOrderDetailViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        weak var weakSelf = self
        if #available(iOS 11.0, *) {
            UITableView.appearance().contentInsetAdjustmentBehavior = .never
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
            UICollectionView.appearance().contentInsetAdjustmentBehavior = .never
        }
        
        picker.dismiss(animated: true) {
            let image = info[UIImagePickerController.InfoKey.originalImage]
            weakSelf?.addImage(image as? UIImage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if #available(iOS 11.0, *) {
            UITableView.appearance().contentInsetAdjustmentBehavior = .never
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
            UICollectionView.appearance().contentInsetAdjustmentBehavior = .never
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Layout
extension ZZWXOrderDetailViewController {
    func layoutNavi() {
        self.title = "微信号订单详情"
        let leftBtn = UIBarButtonItem(image: UIImage.init(named: "back"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(popBack))
        self.navigationItem.leftBarButtonItem = leftBtn
    }
    
    func createNaviRightBtn() {
        guard orderModel?.orderStatus == .seller_bought else {
            self.navigationItem.rightBarButtonItem = nil
            return
        }
        
        let rightBtn = UIBarButtonItem(title: "提交",
                                       style: .plain,
                                       target: self,
                                       action: #selector(sellerComfirm))
        rightBtn.setTitleTextAttributes([NSAttributedString.Key.font: sysFont(15.0)],
                                        for: .normal)
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    func layout() {
        self.view.backgroundColor = rgbColor(247, 247, 247)
        self.view.addSubview(self.tableView)
        tableView.mas_makeConstraints { (make) in
            make?.edges.equalTo()(self.view)
        }
    }
}
