//
//  ZZRankingViewController.swift
//  zuwome
//
//  Created by qiming xiao on 2019/5/23.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

@objc class ZZRankingViewController: ZZViewController {

    @objc var parentController: UIViewController? = nil
    
    lazy var myPlaceView: PlaceView = {
        let view = PlaceView()
        view.delegate = self
        view.backgroundColor = UIColor.rgbColor(253, 251, 245)
        let tap = UITapGestureRecognizer(target: self, action: #selector(showMySelf))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    lazy var headerView: ZZRankingTopsHeaderView = {
        let view = ZZRankingTopsHeaderView(frame:  CGRect(x: 0, y: 0, width: screenWidth, height: 400))
        view.delegate = self
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ZZRanksCell.self, forCellReuseIdentifier: ZZRanksCell.cellIdentifier())
        tableView.tableHeaderView = headerView
        
        tableView.mj_header = ZZRefreshHeader.init(refreshingBlock: { [weak self] in
             self?.refreshData()
        })
        
        return tableView
    }()
    
    var ranks: [ZZRankModel]?
    
    var myRanking: ZZRankModel?
    
    var pageIndex: Int = 1
    
    var myCurrentRanking: Int = -1
    
    var offsetToShow: CGFloat = 0
    
    @objc var isTheFirstTime: Bool = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if offsetToShow != 0 {
            let alpha = 1 - (offsetToShow - tableView.contentOffset.y) / offsetToShow
            self.navigationController?.navigationBar.shadowImage = UIImage.init(from: UIColor.rgbColor(244, 203, 7, alpha))
            self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(from: UIColor.rgbColor(244, 203, 7, alpha)), for: .default)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "全国实力排行榜"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        layout()
        
        // 先去获取自己的,再去获取列表的.
//        fetchMyRanking()
    }
    
    deinit {
        print("ZZRankingViewController deinit")
    }
    
    func resetMyShowStat(isShow: Bool, user: ZZUser?) {
        if let myRanking = myRanking {
            if let user = user {
                myRanking.userInfo = user
            }
            if let user = user {
                myRanking.userInfo = user
            }
            
            myRanking.rank_show = isShow ? NSNumber(integerLiteral: -1) : NSNumber(integerLiteral: 0)
        }
        
        if let ranks = ranks, let myRanking = myRanking {
            if let rankInt: Int = Int(myRanking.ranking ?? ""), rankInt < ranks.count, rankInt > 0 {
                let rankModel: ZZRankModel = ranks[rankInt - 1]
                if rankModel.userInfo?.uid == user?.uid {
                    let rank_show = isShow ? NSNumber(integerLiteral: -1) : NSNumber(integerLiteral: 0)
                    rankModel.rank_show = rank_show
                    if let user = user {
                        rankModel.userInfo = user
                    }
                }
            }
        }
        
        // 更新底部状态
        self.myPlaceView.configure(rank: self.myRanking, isMine: true, shouldShowTips: true)
        
        // 更新top3状态
        if let rankArr = self.ranks {
            if rankArr.count >= 3 {
                self.headerView.configureTopThree(topThree: Array(rankArr[0..<3]))
            }
            else {
                self.headerView.configureTopThree(topThree: rankArr)
            }
        }
        
        // 更新列表状态
        tableView.reloadData()
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
        
        if loginer.didHaveRealAvatar() || (loginer.isAvatarManualReviewing() && loginer.didHaveOldAvatar()) || ZZUserHelper.shareInstance().isMale() {
            fetchSayHi(user: user) { (data) in
                if let data = data as? [String: Any], let sayHiState = data["say_hi_status"] as? Int, sayHiState == 0 {
                    
                    if loginer.didHaveOldAvatar() || ZZUserHelper.shareInstance().isMale() {
                        self.goToChatView(rankModel: rankModel)
                    }
                    else
                    {
                        self.showOKAlert(
                            withTitle: "提示",
                            message: "打招呼需要上传本人五官正脸清晰照，您的头像还在审核中，暂不可打招呼",
                            okTitle: "知道了",
                            okBlock: nil
                        )
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
    
    @objc func fresh() {
        isTheFirstTime = false;
        pageIndex = 1
        fetchMyRanking()
    }
}

// MARK: Respones
extension ZZRankingViewController {
    @objc func showMySelf() {
        goToMyRanks()
    }
}

// MARK: ZZRankingTopThreeViewDelegate
extension ZZRankingViewController: ZZRankingTopsHeaderViewDelegate {
    func showRankUserInfo(rankModel: ZZRankModel?) {
        if let uid = rankModel?.userInfo?.uid {
            goToUserInfo(uid: uid)
        }
    }
    
    func chat(view: ZZRankingTopsHeaderView, rankModel: ZZRankModel?) {
        canChat(rankModel: rankModel)
    }
}

// MARK: ZZRanksCellDelegate
extension ZZRankingViewController: ZZRanksCellDelegate {
    func showUserInfo(rankModel: ZZRankModel?) {
        if let uid = rankModel?.userInfo?.uid {
            goToUserInfo(uid: uid)
        }
    }
    
    func chat(rankModel: ZZRankModel?) {
        canChat(rankModel: rankModel)
    }
}

// MARK: PlaceViewDelegate
extension ZZRankingViewController: PlaceViewDelegate {
    func chat(view: PlaceView, rank: ZZRankModel?) {
        print("chat")
    }
    
    func hideOrShow(view: PlaceView, rank: ZZRankModel?) {
        if let showValue = rank?.rank_show?.intValue {
            let isShow = showValue == -1 ? true : false
            showAction(isShow: !isShow)
        }
    }
}

// MARK: UITableViewDelgate, UITablviewDataSource
extension ZZRankingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = ranks?.count {
            return count - 3 > 0 ? count - 3 : 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ZZRanksCell.cellIdentifier(), for: indexPath) as! ZZRanksCell
        cell.selectionStyle = .none
        cell.configure(rank: ranks?[indexPath.row + 3], ranking: indexPath.row + 4)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: UIScrollView
extension ZZRankingViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        offsetToShow = navigationBarHeight
//        let alpha = 1 - (offsetToShow - scrollView.contentOffset.y) / offsetToShow
//        self.navigationController?.navigationBar.shadowImage = UIImage.init(from: rgbaColor(244, 203, 7, alpha))
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(from: rgbaColor(244, 203, 7, alpha)), for: .default)
    }
}

// MARK: Navigation
extension ZZRankingViewController {
    func goToMyRanks() {
        let vc = ZZMyRanksViewController()
        parentController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToUserInfo(uid: String) {
        let controller = ZZRentViewController()
        controller.uid = uid
        parentController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    // 聊天页面
    func goToChatView(rankModel: ZZRankModel?) {

        guard let rank = rankModel, let user = rank.userInfo else {
            return
        }
        
        
        let chatController = ZZChatViewController()
        chatController.nickName = user.nickname
        chatController.uid = user.uid
        chatController.portraitUrl = user.avatar
        
        parentController?.navigationController?.pushViewController(chatController, animated: true)
    }
    
    func goTologinView() {
        if let controller = parentController {
            LoginHelper.sharedInstance().showLoginView(in: controller)
        }
    }
    
    func goToUploadPicture() {
        let vc = ZZPerfectPictureViewController()
        vc.isFaceVC = false
        vc.faces = ZZUserHelper.shareInstance()?.loginer.faces as? [String]
        vc.user = ZZUserHelper.shareInstance()?.loginer
        vc.type = .publishTask;
        parentController?.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: Request
extension ZZRankingViewController {
    // 获取数据
    func refreshData() {
        pageIndex = 1
        loadData(page: pageIndex)
    }
    
    func loadMoreData() {
        loadData(page: pageIndex + 1)
    }
    
    func loadData(page: Int) {
        ZZRequest.method("GET", path: "/api/rangking/getRangking", params: ["uid": ZZUserHelper.shareInstance()?.loginer.uid ?? "", "pageIndex": page]) { (error, data, _) in
            
            if let mj_header = self.tableView.mj_header {
                if mj_header.isRefreshing {
                    mj_header.endRefreshing()
                }
            }
            
            
            if let footer = self.tableView.mj_footer {
                if footer.isRefreshing {
                    footer.endRefreshing()
                }
            }
            
            if error == nil {
                if let arr = data as? Array<Any> {
                    if let dataArr: [ZZRankModel] = NSArray.yy_modelArray(with: ZZRankModel.self, json: arr) as? [ZZRankModel] {
                        if page == 1 {
                            // 刷新
                            self.ranks = dataArr
                            if let rankArr = self.ranks {
                                if rankArr.count >= 3 {
                                    self.headerView.configureTopThree(topThree: Array(rankArr[0..<3]))
                                }
                                else {
                                    self.headerView.configureTopThree(topThree: rankArr)
                                }
                                if rankArr.count > 3 {
                                    if (self.tableView.mj_footer == nil) {
                                        self.tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: { [weak self] in
                                            self?.loadMoreData()
                                        })
                                    }
                                }
                                
                                if self.tableView.tableFooterView != nil {
                                    self.tableView.tableFooterView = nil
                                }
                            }
                            else {
                                self.headerView.configureTopThree(topThree: [])
                            }
                        }
                        else {
                            // 加载更多
                            if dataArr.count > 0 {
                                self.ranks?.append(contentsOf: dataArr)
                                self.pageIndex += 1
                            }
                            if self.ranks?.count ?? 0 >= 1000 {
                                self.createFooterView()
                            }
                        }
                    }
                }
                self.tableView.reloadData()
            }
            else {
                ZZHUD.showError(withStatus: error?.message)
            }
        }
    }
    
    // 我的排名
    func fetchMyRanking() {
        if let userId = ZZUserHelper.shareInstance()?.loginer.uid, ZZUserHelper.shareInstance().isLogin {
            ZZRequest.method("GET", path: "/api/rangking/getMyRanking", params: ["uid": userId]) { (error, data, _) in
                if error == nil {
                    let myRank = ZZRankModel()
                    myRank.userInfo = ZZUserHelper.shareInstance()?.loginer
                    if let data = data as? [String: Any] {
                        let aggregate = AggregateModel()
                        aggregate.totalPrice = "\(data["totalPrice"] ?? "")"
                        myRank.aggregate = aggregate

                        if let ranking = data["rank_num"] as? Int {
                            myRank.ranking = "\(ranking == 0 ? ranking + 1 : ranking)"
                        }

                        if let rank_show = data["rank_show"] as? Int {
                            myRank.rank_show = NSNumber(integerLiteral: rank_show)
                        }

                        myRank.is_up = NSNumber(integerLiteral: data["is_up"] as? Int ?? 0)
                    }
                    self.myRanking = myRank
                }
                else {
                    ZZHUD.showError(withStatus: error?.message)
                }
                self.myPlaceView.configure(rank: self.myRanking, isMine: true, shouldShowTips: true)

                // 获取列表
                self.refreshData()
            }
        }
    }
    
    // 隐身、显示
    func showAction(isShow: Bool) {
        ZZHUD.show()
        if let userId = ZZUserHelper.shareInstance()?.loginer.uid, ZZUserHelper.shareInstance().isLogin {
            ZZHUD.dismiss()
            ZZRequest.method("POST", path: "/api/rangking/settingUserShow", params: ["uid": userId, "rank_show": isShow ? -1 : 0]) { (error, data, _) in
                if error == nil {
                    ZZHUD.showTastInfo(with: !isShow ? "隐榜成功" : "取消隐榜成功")
                    let user = try? ZZUser.init(dictionary: data as? [AnyHashable : Any])
                    self.resetMyShowStat(isShow: isShow, user: user)
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
extension ZZRankingViewController {
    func layout() {
        self.view.addSubview(myPlaceView)
        self.view.addSubview(tableView)
        
        myPlaceView.mas_makeConstraints { (make) in
            make?.bottom.left()?.right()?.equalTo()(self.view)
            make?.height.equalTo()(80)
        }
        
        tableView.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.view)//?.offset()(-navigationBarHeight)
            make?.left.right().equalTo()(self.view)
            make?.bottom.equalTo()(myPlaceView.mas_top)
        }
        
        let line = UIView()
        line.backgroundColor = UIColor.hexColor("#e6e6e6")
        self.view.addSubview(line)
        
        line.mas_makeConstraints { (make) in
            make?.top.left()?.right()?.equalTo()(myPlaceView)
            make?.height.equalTo()(1)
        }
    }
    
    func createFooterView() {
        let footerLabel = UILabel()
        footerLabel.frame = CGRect(x: 0.0, y: 0, width: screenWidth, height: 40)
        footerLabel.text = "你触到我底线啦"
        footerLabel.textColor = UIColor.rgbColor(153, 153, 153)
        footerLabel.textAlignment = .center
        footerLabel.font = UIFont(name: "PingFangSC-Medium", size: 13.0) ?? UIFont.systemFont(ofSize: 17.0)
        
        tableView.tableFooterView = footerLabel
        if (tableView.mj_footer != nil) {
            tableView.mj_footer = nil
        }
    }
}
