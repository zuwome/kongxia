//
//  ZZWXOrderReportViewController.swift
//  zuwome
//
//  Created by qiming xiao on 2019/2/28.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

protocol ZZWXOrderReportViewControllerDelegate: NSObjectProtocol {
    func reported(viewController: ZZWXOrderReportViewController)
}

class ZZWXOrderReportViewController: UIViewController {
    weak var delegate: ZZWXOrderReportViewControllerDelegate?
    var wxOrder: ZZWXOrderModel = ZZWXOrderModel()
    var reportReasons: [ZZWXOrderReportModel] = []
    var currentSelectReason: ZZWXOrderReportModel = ZZWXOrderReportModel()
    var cellTypesArray: [[String]] = []
    
    // 从旧的微信评价页面过来
    @objc var didCamefromOldWechatReview: Bool = false
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = zzBackgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ZZOrderReportReasonCell.self, forCellReuseIdentifier: ZZOrderReportReasonCell.cellIdentifier())
        
        tableView.register(ZZOrderReportUploadCell.self, forCellReuseIdentifier: ZZOrderReportUploadCell.cellIdentifier())
        
        tableView.register(ZZOrderReportOtherReasonCell.self, forCellReuseIdentifier: ZZOrderReportOtherReasonCell.cellIdentifier())
        
        tableView.register(ZZWechatOrderReportInputCell.self, forCellReuseIdentifier: ZZWechatOrderReportInputCell.cellIdentifier())
        tableView.estimatedRowHeight = 40
        return tableView
    }()
    
    lazy var confirmView: UIView = {
        let view = UIView()
        view.backgroundColor = zzGoldenColor
        return view
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = zzGoldenColor
        btn.setTitle("提交", for: .normal)
        btn.setTitleColor(zzBlackColor, for: .normal)
        btn.titleLabel?.font = sysFont(15.0)
        btn.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        return btn
    }()
    
    @objc class func create(toUser: ZZUser) -> ZZWXOrderReportViewController {
        let orderModel = ZZWXOrderModel()
        let doc = WXOrderInfoModel()
        
        let from = WXOrderUserInfoModel()
        from._id = ZZUserHelper.shareInstance()?.loginer.uid
        
        let to = WXOrderUserInfoModel()
        to._id = toUser.uid
        
        doc.from = from
        doc.to = to
        
        orderModel._doc = doc
        
        let orderVC = ZZWXOrderReportViewController(order: orderModel)
        orderVC.didCamefromOldWechatReview = true
        return orderVC
    }
    
    var currentSelectPhotoIndex : Int = -1
    
    init(order: ZZWXOrderModel) {
        super.init(nibName: nil, bundle: nil)
        wxOrder = order
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .bottom;
        layoutNavi()
        layout()
        createReasons()
        createCells()
    }
    
    // 确认举报
    @objc func confirm() {
        self.view.endEditing(true)
        
        guard canCommit() else {
            ZZHUD.showError(withStatus: "请选择举报原因")
            return
        }
        
//        guard let _ = wxOrder.cellOrWechat else {
//            ZZHUD.showError(withStatus: "请留下您的联系方式")
//            return
//        }
//
//        guard isWechatOrCell() == true else {
//            ZZHUD.showError(withStatus: "请留下正确的手机或者微信")
//            return
//        }
        
        weak var weakSelf = self
        // 第一步: 上传图片
        ZZHUD.show()
        if let imagesArr = currentSelectReason.images, imagesArr.count > 0 {
            ZZUploader.uploadPhotos(imagesArr, progress: { (value) in
                
            }, success: { (urlArray) in
                ZZHUD.dismiss()
                weakSelf?.report()
            }) {
                ZZHUD.dismiss()
                ZZHUD.showError(withStatus: "上传失败,请重试")
            }
        }
        else {
            report()
        }
        
        
//    - (void)publishPhotos {
//        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//        [ZZUploader uploadPhotos:_photosArray progress:^(CGFloat progress) {
//
//        } success:^(NSArray *urlArray) {
//            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
//            [self publishTask];
//        } failure:^{
//            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
//            [ZZHUD showErrorWithStatus:@"上传失败,请重试"];
//        }];
//    }
//
//        if let image = currentSelectReason.image {
//            uploadPhotoToQniu(image: image) { (isSuccess, photo) in
//                if isSuccess && photo != nil {
//                    weakSelf?.currentSelectReason.imageStr = photo?.url
//                    weakSelf?.report()
//                }
//            }
//        }
//        else {
//            report()
//        }
    }
    
    /**
     判断是否可以提交
     -* 主原因为必选项，如果是其他则必须填写详细原因，图片为非必须项
     -* returns: Bool
     */
    func canCommit() -> Bool {

        guard currentSelectReason.reason != nil else {
            return false
        }
        
        if currentSelectReason.reason == "其他" {
            if  currentSelectReason.detailReason == nil || currentSelectReason.detailReason?.count == 0 {
                return false
            }
        }
        
        return true
    }
    
    // temp
    func createReasons() {
        let model1 = ZZWXOrderReportModel(reason: "虚假微信号", detailReason: nil, image: nil, imageStr: nil, images: nil)
        reportReasons.append(model1)
        
        let model2 = ZZWXOrderReportModel(reason: "无法添加", detailReason: nil, image: nil, imageStr: nil, images: nil)
        reportReasons.append(model2)
        
        let model3 = ZZWXOrderReportModel(reason: "其他", detailReason: nil, image: nil, imageStr: nil, images: nil)
        reportReasons.append(model3)
        
        currentSelectReason = reportReasons.first!
    }
    
    // 创建显示的Cell
    func createCells() {
        cellTypesArray.removeAll()
        
        var sec0: [String] = []
        sec0.append(ZZOrderReportReasonCell.cellIdentifier())
        sec0.append(ZZOrderReportReasonCell.cellIdentifier())
        sec0.append(ZZOrderReportReasonCell.cellIdentifier())
        cellTypesArray.append(sec0)
        
        if currentSelectReason.reason == "其他" {
            var sec1: [String] = []
            sec1.append(ZZOrderReportOtherReasonCell.cellIdentifier())
            cellTypesArray.append(sec1)
        }
        
        if didCamefromOldWechatReview {
            var sec2: [String] = []
            sec2.append(ZZWechatOrderReportInputCell.cellIdentifier())
            cellTypesArray.append(sec2)
        }
        var sec2: [String] = []
        sec2.append(ZZOrderReportUploadCell.cellIdentifier())
        cellTypesArray.append(sec2)
    }
    
    // 显示相册
    func showPhotoBrowser() {
        if #available(iOS 11.0, *) {
            UITableView.appearance().contentInsetAdjustmentBehavior = .always
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .always
            UICollectionView.appearance().contentInsetAdjustmentBehavior = .always
        }
        
        let browser = UIImagePickerController()
        browser.sourceType = .photoLibrary
        browser.delegate = self
        self.present(browser, animated: true, completion: nil)
    }
    
    // 添加图片
    func addImage(_ image: UIImage?) {
        guard let image = image else {
            currentSelectReason.images?.remove(at: currentSelectPhotoIndex)
            currentSelectPhotoIndex = -1
            tableView.reloadData()
            return
        }
        
        guard currentSelectPhotoIndex != -1 else {
            return
        }
        
        let photoModel = ZZPhoto()
        photoModel.image = image
        
        if let imagesArr: [ZZPhoto] = currentSelectReason.images {
            if currentSelectPhotoIndex < imagesArr.count && imagesArr.count > 0 {
                currentSelectReason.images?[currentSelectPhotoIndex] = photoModel
            }
            else {
                currentSelectReason.images?.append(photoModel)
            }
        }
        else {
            currentSelectReason.images = [photoModel]
        }

        currentSelectPhotoIndex = -1
        tableView.reloadData()
    }
    
    // 是否是电话或者微信号
    func isWechatOrCell() -> Bool {
        let regex = "^[A-Za-z0-9_-]+$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        if pred.evaluate(with: wxOrder.cellOrWechat) {
            return true
        }
        else {
            return false
        }
    }
    
    func showPhotoSelections(index: Int) {
        weak var weakSelf = self
        
        var canDelete: Bool = false
        if let images: [ZZPhoto] = currentSelectReason.images {
            if images.count == 0 {
                canDelete = false
            }
            else {
                switch index {
                    case 0:
                        canDelete = images.count >= 1;
                    case 1:
                        canDelete = images.count >= 2;
                    case 2:
                        canDelete = images.count == 3;
                    default:
                        canDelete = false
                }
            }
        }
        
        var changeTitle = "从相册选择";
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if canDelete {
            changeTitle = "更换"
            let deleteAction = UIAlertAction(title: "删除", style: .default) { (action) in
                weakSelf?.addImage(nil)
            }
            alertController.addAction(deleteAction)
        }
        
        let okAction = UIAlertAction(title: changeTitle, style: .default) { (action) in
            weakSelf?.showPhotoBrowser()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

// MARK: - ZZOrderReportUploadCellDelegate
extension ZZWXOrderReportViewController: ZZOrderReportUploadCellDelegate {
//    func
    func cellSelected(cell: ZZOrderReportUploadCell, selectIndex: Int) {
        if selectIndex == -1 {
            return
        }
        currentSelectPhotoIndex = selectIndex
        showPhotoSelections(index: selectIndex)
    }
}

// MARK: - ZZOrderReportOtherReasonCellDelegate
extension ZZWXOrderReportViewController: ZZOrderReportOtherReasonCellDelegate {
    func reasonDidInput(view: ZZOrderReportOtherReasonCell, reason: String?) {
        currentSelectReason.detailReason = reason
    }
}

// MARK: - ZZWechatOrderReportInputCellDelegate
extension ZZWXOrderReportViewController: ZZWechatOrderReportInputCellDelegate {
    func cellOrWechatDidInput(view: ZZWechatOrderReportInputCell, cellOrWeChat: String?) {
        wxOrder.cellOrWechat = cellOrWeChat
    }
}

// MARK: - UITableViewDelgate, UITablviewDataSource
extension ZZWXOrderReportViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellTypesArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypesArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = cellTypesArray[indexPath.section][indexPath.row]
        if cellIdentifier == ZZOrderReportReasonCell.cellIdentifier() {
            let cell: ZZOrderReportReasonCell = tableView.dequeueReusableCell(withIdentifier: ZZOrderReportReasonCell.cellIdentifier(), for: indexPath) as! ZZOrderReportReasonCell
            let model = reportReasons[indexPath.row]
            cell.titleLabel.text = model.reason
            cell.checkedBtn.isSelected = (model.reason == currentSelectReason.reason)
            cell.selectionStyle = .none
            return cell
        }
        else if cellIdentifier == ZZOrderReportOtherReasonCell.cellIdentifier() {
            let cell = tableView.dequeueReusableCell(withIdentifier: ZZOrderReportOtherReasonCell.cellIdentifier(), for: indexPath) as! ZZOrderReportOtherReasonCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        }
        else if cellIdentifier == ZZWechatOrderReportInputCell.cellIdentifier() {
            let cell = tableView.dequeueReusableCell(withIdentifier: ZZWechatOrderReportInputCell.cellIdentifier(), for: indexPath) as! ZZWechatOrderReportInputCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        }
        else {
            let cell: ZZOrderReportUploadCell = tableView.dequeueReusableCell(withIdentifier: ZZOrderReportUploadCell.cellIdentifier(), for: indexPath) as! ZZOrderReportUploadCell
            cell.delegate = self
            cell.configData(imagesArr: currentSelectReason.images)
//            cell.photoView.photoImageView.image = currentSelectReason.image
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellIdentifier = cellTypesArray[indexPath.section][indexPath.row]
        if cellIdentifier == ZZOrderReportReasonCell.cellIdentifier() {
            let selectedReason = reportReasons[indexPath.row]
            currentSelectReason.reason = selectedReason.reason
            createCells()
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let cellIdentifier = cellTypesArray[section].first, cellIdentifier == ZZWechatOrderReportInputCell.cellIdentifier(), didCamefromOldWechatReview == true {
            return 44.0
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let cellIdentifier = cellTypesArray[section].first, cellIdentifier == ZZWechatOrderReportInputCell.cellIdentifier(), didCamefromOldWechatReview == true {
            
            let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
            view.backgroundColor = .white
            
            let line = UIView()
            line.backgroundColor = rgbColor(237, 237, 237)
            view.addSubview(line)

            line.mas_makeConstraints { (make) in
                make?.left.top().right()?.equalTo()(view)
                make?.height.equalTo()(0.5)
            }
            
            let titleLabel = UILabel(text: "您的联系方式有助于我们及时的与您沟通，工作人员将在一个工作日内联系您", font: sysFont(13.0), textColor: rgbColor(63, 58, 58))
            titleLabel.numberOfLines = 2
            view.addSubview(titleLabel)

            titleLabel.mas_makeConstraints { (make) in
                make?.centerY.equalTo()(view)
                make?.left.equalTo()(view)?.offset()(15.0)
                make?.right.equalTo()(view)?.offset()(-15.0)
            }
            return view
        }
        return UIView(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 10.0))
    }
}

// MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate
extension ZZWXOrderReportViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func `imagePickerController`(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
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

// MARK: - Request
extension ZZWXOrderReportViewController {
    // 举报 微信
    func report() {
        var params: [String : Any] = [
            "from": wxOrder._doc!.from!._id!,
            "to": wxOrder._doc!.to!._id!,
            "reportContent": currentSelectReason.reason != "其他" ? currentSelectReason.reason! : currentSelectReason.detailReason!
            ]
//        if let imageStr = currentSelectReason.imageStr {
//            params["reportImg"] = imageStr
//        }
        
        if let imagesArr = currentSelectReason.images {
            var urlArr = [String]()
            for (_, photo) in imagesArr.enumerated() {
                urlArr.append(photo.url)
            }
            params["imgs"] = urlArr
        }
        
        if didCamefromOldWechatReview == false {
            params["wechatseenId"] = wxOrder._doc!._id!
        }
        
        if let cellOrWechat = wxOrder.cellOrWechat, didCamefromOldWechatReview == true {
            params["phone"] = cellOrWechat
        }
        
        MBProgressHUD().show(true)
        ZZRequest.method("POST", path: "/api/wechat/reportWechat", params: params) { (error, data, _) in
            MBProgressHUD().hide(true)
            if error != nil {
                ZZHUD.showError(withStatus: error?.message)
            }
            else {
                if self.didCamefromOldWechatReview {
                    ZZHUD.showTastInfo(with: "提交成功")
                }
                else {
                    ZZHUD.showTastInfo(with: "举报成功")
                }
                
                self.goToReposrtCompleteView()
                self.delegate?.reported(viewController: self)
            }
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
                "uid": ZZUserHelper.shareInstance()!.loginer.uid!,
                "content": ZZUtils.dictionary(toJson: subParam)!
            ]
            ZZUserHelper.uploadLog(withParam: param, next: nil)
        }
    }
}

// MARK: - Navigator
extension ZZWXOrderReportViewController {
    @objc func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func goToReposrtCompleteView() {
        let vc = ZZWXOrderReportCompleteViewController(wx: wxOrder.customerService, isBuy: wxOrder.isBuy)
        vc.wx = wxOrder.customerService
        vc.didCamefromOldWechatReview = didCamefromOldWechatReview
        vc.isBuy = wxOrder.isBuy
        
        let nav = ZZNavigationController(rootViewController: vc);
        self.present(nav, animated: true, completion: nil)
//        var vcs = self.navigationController?.viewControllers;
//        vcs?.removeLast()
//        vcs?.append(vc)
//        self.navigationController?.setViewControllers(vcs ?? [], animated: false)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: - Layout
extension ZZWXOrderReportViewController {
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
        
        let rightBtn = UIBarButtonItem(title: "提交",
                                       style: .plain,
                                       target: self,
                                       action: #selector(confirm))
        rightBtn.setTitleTextAttributes([NSAttributedString.Key.font: sysFont(15.0)],
                                        for: .normal)
        rightBtn.tintColor = .black
        self.navigationItem.rightBarButtonItem = rightBtn
        
    }
    
    func layout() {
        self.view.backgroundColor = rgbColor(247, 247, 247)
        self.view.addSubview(confirmView)
        confirmView.addSubview(self.confirmBtn)
        self.view.addSubview(self.tableView)
        
        confirmView.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.view)
            make?.bottom.equalTo()(self.view)
            make?.right.equalTo()(self.view)
            make?.height.equalTo()(50 + screenSafeAreaBottomHeight)
        }
        
        confirmBtn.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 50.0);
        
        tableView.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.view)
            make?.bottom.equalTo()(confirmView.mas_top)
            make?.right.equalTo()(self.view)
            make?.top.equalTo()(self.view)
        }
    }
}

