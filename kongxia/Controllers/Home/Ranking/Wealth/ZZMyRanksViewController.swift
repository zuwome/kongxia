//
//  ZZMyRanksViewController.swift
//  zuwome
//
//  Created by qiming xiao on 2019/5/26.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

class ZZMyRanksViewController: ZZViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ZZRanksCell.self, forCellReuseIdentifier: ZZRanksCell.cellIdentifier())
        return tableView
    }()
        
    var ranksModel: ZZMyRankDetailsResponeModel?
    var didIOnTheList: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的排名"
        layout()
        fetchMyRank()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let color = hexColor("#F4CB07")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(color: color, cornerRadius: 0), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage.init(color: color, cornerRadius: 0)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func findMyRankingAndSetAnotherPosition() {
        DispatchQueue.global().async {
            guard let ranks = self.ranksModel?.result else {
                return
            }
            var myRankModel: ZZRankModel? = nil
            var myRankIndex: Int = -1
            for (index, rankModel) in ranks.enumerated() {
                if rankModel.userInfo?.uid == ZZUserHelper.shareInstance()?.loginer.uid {
                    myRankModel = rankModel
                    myRankIndex = index
                    self.didIOnTheList = true
                    break
                }
            }
            
            guard let myRank = myRankModel, let myRanking: Int = Int(myRank.ranking ?? "0"), myRanking > 0, myRankIndex != -1 else {
                return
            }
            
            for (index, rankModel) in ranks.enumerated() {
                if index < myRankIndex {
                    rankModel.ranking = String(myRanking - (myRankIndex - index))
                }
                else if index > myRankIndex {
                    rankModel.ranking = String(myRanking + (index - myRankIndex))
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func canChat(rankModel: ZZRankModel?) {
        
        guard let user = rankModel?.userInfo else {
            return
        }
        
        guard let loginer = ZZUserHelper.shareInstance()!.loginer, ZZUserHelper.shareInstance()!.isLogin else {
            goTologinView()
            return
        }
        
        guard !ZZUtils.isBan() else {
            return
        }
        
        if user.open_charge {
            self.goToChatView(rankModel: rankModel)
            return
        }
        
        if loginer.didHaveRealAvatar() || (loginer.isAvatarManualReviewing() && loginer.didHaveOldAvatar()) {
            fetchSayHi(user: user) { (data) in
                if let data = data as? [String: Any], let sayHiState = data["say_hi_status"] as? Int, sayHiState == 0 {
                    if loginer.didHaveOldAvatar() {
                        self.showOKAlert(
                            withTitle: "提示",
                            message: "打招呼需要上传本人五官正脸清晰照，您的头像还在审核中，暂不可打招呼",
                            okTitle: "知道了",
                            okBlock: nil
                        )
                    }
                    else {
                        self.goToChatView(rankModel: rankModel)
                    }
                }
                else {
                    self.goToChatView(rankModel: rankModel)
                }
            }
        }
        else {
            if loginer.isAvatarManualReviewing() {
                let alertController = UIAlertController(title: "温馨提示", message: "私信TA需要上传本人正脸五官清晰照您的头像正在人工审核中，请等待审核结果", preferredStyle: .alert)
                let action = UIAlertAction(title: "知道了", style: .cancel, handler: nil)
                alertController.addAction(action)
                if let rootVC = UIAlertController.findAppreciatedRootVC() {
                    rootVC.present(alertController, animated: true, completion: nil)
                }
            }
            else {
                UIAlertController.present(withTitle: "温馨提示", message: "您未上传本人正脸五官清晰照，暂不可私信TA", doneTitle: "去上传", cancelTitle: "取消") { (isCancelled) in
                    if (!isCancelled) {
                        self.goToUploadPicture()
                    }
                }
            }
        }
    }
}

// MARK: ZZRanksCellDelegate
extension ZZMyRanksViewController: ZZRanksCellDelegate {
    func showUserInfo(rankModel: ZZRankModel?) {
        if let uid = rankModel?.userInfo?.uid {
            goToUserInfo(uid: uid)
        }
    }
    
    func chat(rankModel: ZZRankModel?) {
        canChat(rankModel: rankModel)
    }
}

// MARK: UITableViewDelgate, UITablviewDataSource
extension ZZMyRanksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return didIOnTheList ? self.ranksModel?.result?.count ?? 0 : 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ZZRanksCell.cellIdentifier(), for: indexPath) as! ZZRanksCell
        cell.selectionStyle = .none
        if didIOnTheList {
            cell.configure(rank: self.ranksModel?.result?[indexPath.row])
            cell.delegate = self
        }
        else {
            let rankModel = ZZRankModel()
            rankModel.userInfo = ZZUserHelper.shareInstance()?.loginer
            cell.configure(rank: rankModel, isMine: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: Navigation
extension ZZMyRanksViewController {
    func goToMyRanks() {
        let vc = ZZMyRanksViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToUserInfo(uid: String) {
        let controller = ZZRentViewController()
        controller.uid = uid
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // 聊天页面
    func goToChatView(rankModel: ZZRankModel?) {
        
        guard ZZUserHelper.shareInstance()!.isLogin else {
            goTologinView()
            return
        }
        
        guard !ZZUtils.isBan() else {
            return
        }
        
        guard let rank = rankModel, let user = rank.userInfo else {
            return
        }
        
        let chatController = ZZChatViewController()
        chatController.nickName = user.nickname
        chatController.uid = user.uid
        chatController.portraitUrl = user.avatar
        self.navigationController?.pushViewController(chatController, animated: true)
    }
    
    func goTologinView() {
        LoginHelper.sharedInstance().showLoginView(in: self)
    }
    
    func goToUploadPicture() {
        let vc = ZZPerfectPictureViewController()
        vc.isFaceVC = false
        vc.faces = ZZUserHelper.shareInstance()?.loginer.faces as? [String]
        vc.user = ZZUserHelper.shareInstance()?.loginer
        vc.type = .publishTask;
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: Request
extension ZZMyRanksViewController {
    func fetchMyRank() {
        if let userId = ZZUserHelper.shareInstance()?.loginer.uid, ZZUserHelper.shareInstance().isLogin {
            ZZRequest.method("GET", path: "/api/rangking/getMyRankingDetail", params: ["uid": userId]) { (error, data, _) in
                if error == nil {
                    if let dic = data as? [AnyHashable : Any] {
                        if let responseModel: ZZMyRankDetailsResponeModel = ZZMyRankDetailsResponeModel.yy_model(with: dic) {
                            self.ranksModel = responseModel
                        }
                    }
                    self.findMyRankingAndSetAnotherPosition()
                    self.createTipsView()
                }
                else {
                    ZZHUD.showError(withStatus: error?.message)
                }
            }
        }
    }
    
    func fetchSayHi(user: ZZUser, callBack: @escaping (Any?) -> Void) {
        guard let uid = user.uid else {
            callBack(nil)
            return
        }
        ZZRequest.method("GET", path: "/api/user/\(uid)/say_hi_status", params: ["sayhi_type": "3.7.0"]) { (error, data, _) in
            if error != nil {
                ZZHUD.showError(withStatus: error?.message ?? "获取数据失败")
            }
            else {
                callBack(data)
            }
        }
    }
}

// MARK: Layout
extension ZZMyRanksViewController {
    func layout() {
        self.view.addSubview(tableView)
        tableView.frame = self.view.bounds
//        tableView.mas_makeConstraints { (make) in
//            make?.top.left()?.right()?.equalTo()(self.view)
//            make?.bottom.equalTo()(infoView.mas_top)
//            make?.edges.equalTo()(self.view)
//        }
    }
    
    func createTipsView() {
        guard let model = ranksModel, let textArr: [String] = model.text?.text_arr, textArr.count > 0 else {
            return
        }
        
        let view = ZZMyRankInfoVIew(frame: CGRect(x: 15.0, y: screenHeight - 50, width: screenWidth - 30, height: 50), textArr: textArr)
        view.height = view.viewHeight
        view.top = screenHeight - view.height - navigationBarHeight - 15
        self.view.addSubview(view)
        
    }
}
