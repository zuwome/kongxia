//
//  ZZSayHiHelper.swift
//  zuwome
//
//  Created by qiming xiao on 2019/6/10.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

/**
 * 需要显示打招呼的状态
 */
@objc
enum SayHiType: Int {
    case general     = -1 // login + changeCity + recallLogin
    case login       = 0  // 开启私信付费的达人连续登录的第二天打开App
    case rent        = 1  // 新上架(申请达人成功触发的一键打招呼弹窗)
    case changeCity  = 2  // 新的城市(地理位置变化触发的一键打招呼)
    case recallLogin = 3  // 连续登录(距离上次登录时间为30天以上的女性开启私信付费达人)
    case dailyLogin  = 4  // 每天一次的,与s其他类型没有任何关系, 只要纪录每天一次(入口是在聊天列表的H5)
}

typealias ShowSayHiBlock = (_ didHaveUsers: Bool) -> ()

@objc class ZZSayHiHelper: NSObject {
    @objc static let shared = ZZSayHiHelper()
    
    var isLoadingData: Bool = false
    
    var sayHiType: SayHiType = .login
    
    var now: String? {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return format.string(from: date)
    }
    
    /*
     当前用户打招呼信息
     */
    var currentUserSayHiInfo: [String : Any]? = nil
    
    /*
     是否可以一直展示
     */
    var canAlwaysShow: Bool = false
    
    @objc var showSayHiBlock: ShowSayHiBlock?
    
    var page: Int = 1
    
    @objc class func sharedInstance() -> ZZSayHiHelper {
        return ZZSayHiHelper.shared
    }
    
    private override init() {
        super.init()
        
        addNotifications()
        
        // 获取当前的用户
        fetchCurrentUser()
    }
    
    /**
     *  显示、加载数据
     */
    @objc func showSayHi(type: SayHiType = .login,
                         canAlwaysShow: Bool = false) {
        showSayHi(type: type, canAlwaysShow: canAlwaysShow) { (_) in
            
        }
    }
    
    @objc func showSayHi(type: SayHiType = .login,
                         canAlwaysShow: Bool = false,
                         finishBlock: @escaping ShowSayHiBlock) {
        
        // 如果正在加载直接退了
        guard isLoadingData == false else {
            return
        }
        
        guard ZZUserHelper.shareInstance()?.isLogin ?? false else {
            return
        }
        
        self.showSayHiBlock = finishBlock
        
        // 保存当前的打招呼类型
        sayHiType = type
        
        // 是否是直接显示不需要判断各种东西
        self.canAlwaysShow = canAlwaysShow
        
        // 推断当前显示的类型
        detectCurrentType(type)
        
        // 判断时候可以显示
        guard shouldShowBysayHiType(sayHiType) == true else {
            return
        }
        
        // 获取打招呼用户
        fetchData { (responseModel) in
            self.createSayHiView(responseModel: responseModel)
        }
    }

    /**
     *  创建一键打招呼的窗口
     */
    func createSayHiView(responseModel: ZZSayHiModelRespones?) {
        
        clearHideSayHi()
        
        guard let responseModel = responseModel,
            responseModel.showFirm == true,
            let users = responseModel.sayHiUsers,
            users.count > 0 else {
                if sayHiType == .dailyLogin {
                    ZZHUD.showTastInfoError(with: "小仙女太勤劳啦，附近的人都打过招呼了，明天再来体验吧")
                }
                
                showSayHiBlock?(false)
                return
        }
        
        showSayHiBlock?(true)
        
        let sayHiView = ZZSayHiView(frame: UIApplication.shared.keyWindow!.bounds, responseModel: responseModel, type: sayHiType)
        UIApplication.shared.keyWindow!.addSubview(sayHiView)
        saveShowedType()
    }
}


// MARK: - 判断是否需要显示打招呼
extension ZZSayHiHelper {
    
    /*
     用户是否符合打招呼的条件
     */
    func canSayHi(sayHiType: SayHiType) -> Bool {
        // 未登录
        guard ZZUserHelper.shareInstance()?.isLogin == true else {
            return false
        }
        
        // 必须是女性
        guard let user = ZZUserHelper.shareInstance()?.loginer, user.gender == 2 else {
            return false
        }
        
        // 必须是打开了私信收益, 并且出租状态是已上架(除了第一次申请成为达人外)
        if sayHiType != .rent {
            guard user.open_charge == true, user.rent.status == 2 else {
                return false
            }
        }
        
        return true
    }
    
    /**
     *  是否已经显示过该类型的了
     */
    @objc func didTodayShow(sayHiType: SayHiType) -> Bool {
        if shouldShowToday(sayHiType: sayHiType) {
            return false
        }
        else {
            return true
        }
    }
    
    /**
     *  判断需要显示什么打招呼
     */
    func detectCurrentType(_ type: SayHiType) {
        guard canAlwaysShow == false else {
            return
        }
        
        // daily的就不需要在判断类型了
        if sayHiType == .dailyLogin {
            return
        }
        
        if sayHiType == .rent {
            return
        }
        
        guard let user = ZZUserHelper.shareInstance()?.loginer, ZZUserHelper.shareInstance()?.isLogin == true else {
            sayHiType = .general
            return
        }
        
        // 假如配置open_sayhi_new没开一律显示为第二天登录的
        if let sysConfig = ZZUserHelper.shareInstance()?.configModel, sysConfig.open_sayhi_new == false {
            sayHiType = .login
            return
        }
        
        if let isTheSame = ZZDateHelper.shareInstance()?.isTheSameDay(user.loc_num_update_at),
            isTheSame {
            // 开启私信付费的女性达人地理位置发生变化时
            // 因为一键打招呼 可能每天多次出发,所以在目前的做法就是去判断保存的loc_num距离是不是和获取到相等,相等证明没有变化,不相等则证明有变化
            if let loc_num = ZZUserHelper.shareInstance()?.loginer.loc_num {
                if let loc_numLast = currentUserSayHiInfo?["Loc_num"] as? Double {
                    let loc_numLastDec = NSDecimalNumber(value: loc_numLast)
                    let loc_numCur = NSDecimalNumber(value: loc_num)
                    if loc_numCur.compare(loc_numLastDec) != .orderedSame {
                        sayHiType = .changeCity
                    }
                    else {
                        sayHiType = .login
                    }
                }
                else {
                    sayHiType = .changeCity
                }
            }
            else {
                sayHiType = .login
            }
        }
        else if let isTheSame = ZZDateHelper.shareInstance()?.isTheSameDay(user.last_login_day_update), isTheSame {
            // 距离上次登录时间在30天以上的, 如果last_login_day_update 的日期等于当前的时间那么就是超过了30天
            sayHiType = .recallLogin
        }
        else {
            sayHiType = .login
        }
        
        // 显示过的类型, 如果已经显示过该类型, 则一律变成login, changeCity可以多次出发
        let showedArr = currentUserSayHiInfo?["ShowedSayHiType"] as? [Int]
        if (showedArr?.count ?? 0) > 0 && sayHiType != .changeCity && sayHiType != .login  && (showedArr?.contains(sayHiType.rawValue) ?? false) {
            sayHiType = .login
            return
        }
    }
    
    /**
    *  根据打招呼的类型进行判断
    */
    func shouldShowBysayHiType(_ type: SayHiType) -> Bool {
        guard canAlwaysShow == false else {
            return true
        }
        
        guard canSayHi(sayHiType: type) else {
            return false
        }
        
        guard type != .general else {
            return false
        }
        
        // 如果是连续第二天登录的,假如点击了关闭,则七天之内不用在显示
        if type == .login,
            let lastShowedDate: String = currentUserSayHiInfo?["loginLastestShowedDate"] as? String,
            ZZDateHelper.shareInstance()?.isPassAWeek(lastShowedDate) == false {
            return false
        }
    
        // 判断今天是不是已经显示过了
        guard shouldShowToday(sayHiType: sayHiType) else {
            return false
        }
        
        return true
    }
    
    /**
     * 判断今天是否显示过了没、需不需要显示
     */
    func shouldShowToday(sayHiType: SayHiType) -> Bool {
        // 假如可以一直展示的就不需要判断今天是否显示过了
        if canAlwaysShow == true && sayHiType == .recallLogin {
            return true
        }
        
        // 保存显示的时间
        let lastestDay = currentUserSayHiInfo?["LastestSayHiDay"] as? String
        
        // 显示过的类型
        let showedArr = currentUserSayHiInfo?["ShowedSayHiType"] as? [Int]
        
        // 都没有值的话就可以显示
        if lastestDay == nil || showedArr == nil || showedArr?.count == 0 {
            return true
        }
        
        if sayHiType == .login {
            // type == login, 如果今天显示过其他的就不再显示这个
            if let showedArr = showedArr,
                (showedArr.contains(3) || showedArr.contains(2) || showedArr.contains(1) || showedArr.contains(0)) {
                return false
            }
            else {
                return true
            }
        }
        else {
            // 如果今天显示过了 就不再显示, changeCity可以多次触发
            if sayHiType != .changeCity && showedArr?.contains(sayHiType.rawValue) ?? false {
                return false
            }
            else {
                return true
            }
        }
    }
}


// MARK: 保存、获取本地数据
extension ZZSayHiHelper {
    /**
    *   获取当前的用户
    */
    @objc func fetchCurrentUser() {
        
        // 符合条件的用户,采取获取信息
        guard canSayHi(sayHiType: .general) == true else {
            currentUserSayHiInfo = nil
            return
        }
        
        // 获取用户信息
        let userDefault = UserDefaults.standard
        guard let users: Array<[String : Any]> = userDefault.object(forKey: "ShowedSayhiUsers") as? Array<[String : Any]> else {
            // 如果没有信息,直接创建
            if let userID = ZZUserHelper.shareInstance()!.loginer.uid {
                currentUserSayHiInfo = ["userID" : userID]
            }
            
            // 保存处理过的信息到本地
            saveUserInfosToLocal()
            return
        }
        
        var currentUser: [String : Any]? = nil
        for user in users {
            if let userID: String = user["userID"] as? String, userID == ZZUserHelper.shareInstance()?.loginer.uid {
                currentUser = user
                break
            }
        }
        
        // 预处理数据
        if var userInfo = currentUser {
            // 根据是不是同一天来判断是否要清空当前保存的显示列表和距离
            // 保存显示的时间
            let lastestDay = userInfo["LastestSayHiDay"] as? String

            // 如果不相同则清空
            if (ZZDateHelper.shareInstance()?.isTheSameDay(lastestDay) ?? false) == false {
                userInfo["ShowedSayHiType"] = nil
                userInfo["Loc_num"] = nil
            }
            currentUser = userInfo
        }
        else {
            if let userID = ZZUserHelper.shareInstance()!.loginer.uid {
                currentUser = ["userID" : userID]
            }
        }
        
        currentUserSayHiInfo = currentUser
        
        // 保存处理过的信息到本地
        saveUserInfosToLocal()
    }
    
    /**
     *  保存显示过的一键打招呼
     */
    func saveShowedType() {
        // 假如可以一直展示的就不需要去保存了
        if canAlwaysShow == true && sayHiType == .recallLogin {
            return
        }
        
        DispatchQueue.global().async {
            
            // 显示过的类型
            if var showedArr = self.currentUserSayHiInfo?["ShowedSayHiType"] as? [Int] {
                if showedArr.contains(self.sayHiType.rawValue) == false {
                    showedArr.append(self.sayHiType.rawValue)
                }
                self.currentUserSayHiInfo?["ShowedSayHiType"] = showedArr
            }
            else {
                var showedArr = [Int]()
                showedArr.append(self.sayHiType.rawValue)
                self.currentUserSayHiInfo?["ShowedSayHiType"] = showedArr
            }
            
            if self.sayHiType == .changeCity, let loc_num = ZZUserHelper.shareInstance()?.loginer.loc_num {
                self.currentUserSayHiInfo?["Loc_num"] = loc_num
            }
            
            if let now: String = self.now {
                self.currentUserSayHiInfo?["LastestSayHiDay"] = now
            }
            
            self.saveUserInfosToLocal()
        }
    }
    
    /**
     *  连续两天登录,点击关闭7天不用显示
     */
    func hideSayhi() {
        guard sayHiType == .login else {
            return
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone.current
        let dateStr = formatter.string(from: date)
        
        currentUserSayHiInfo?["loginLastestShowedDate"] = dateStr
        saveUserInfosToLocal()
    }
    
    /**
    *  H5点击打招呼, 清楚7天不在提醒的
    */
    func clearHideSayHi() {
        guard sayHiType == .dailyLogin else {
            return
        }
        
        currentUserSayHiInfo?["loginLastestShowedDate"] = nil
        saveUserInfosToLocal()
    }
    
    /**
     *  保存到UserDefault中去
     */
    func saveUserInfosToLocal() {
        DispatchQueue.global().async {
            let userDefault = UserDefaults.standard
            
            if let currentUser = self.currentUserSayHiInfo {
                var showedUsers: Array<[String : Any]>? = userDefault.object(forKey: "ShowedSayhiUsers") as? Array<[String : Any]>
                
                var userIndex = -1
                if var users = showedUsers  {
                    for (index, user) in users.enumerated() {
                        if user["userID"] as? String == self.currentUserSayHiInfo?["userID"] as? String {
                            userIndex = index
                            break
                        }
                    }
                    
                    if userIndex >= 0 {
                        users[userIndex] = currentUser
                    }
                    else {
                        users.append(currentUser)
                    }
                    showedUsers = users
                }
                else {
                    showedUsers = Array<[String : Any]>()
                    showedUsers?.append(currentUser)
                }
                userDefault.set(showedUsers, forKey: "ShowedSayhiUsers")
                userDefault.synchronize()
            }
        }
    }
}


// MARK: Notifications
extension ZZSayHiHelper {
    func addNotifications() {
        // 当用户更换账号的时候需要重新获取一下
        NotificationCenter.default.addObserver(self, selector: #selector(loginAcions), name: NSNotification.Name(rawValue: kMsg_UserLogin), object: nil)
    }
    
    @objc func loginAcions() {
        fetchCurrentUser()
    }
}


// MARK: - Request
extension ZZSayHiHelper {
    func fetchData(completeHandler: @escaping (_ responseModel: ZZSayHiModelRespones?) -> Void) {
        page = 1
        fetchSayHiDataWithPage(page: page, completeHandler: completeHandler)
    }
    
    func loadMore(completeHandler: @escaping (_ responseModel: ZZSayHiModelRespones?) -> Void) {
        page += 1
        fetchSayHiDataWithPage(page: page, completeHandler: completeHandler)
    }
    
    func preLoadNextData(currentData: ZZSayHiModelRespones?, completeHandler: @escaping (_ responseModel: ZZSayHiModelRespones?) -> Void) {
        if !(sayHiType == .login || sayHiType == .dailyLogin) {
            return
        }
        
        if currentData?.sayHiUsers?.count ?? 0 == 0 || currentData?.sayHiUsers?.count ?? 0 > 40 {
            return
        }
    
        loadMore { [weak self] (responseModel) in
            guard let responseModel = responseModel,
                let users = responseModel.sayHiUsers,
                users.count > 0 else {
                    return
            }
            
            completeHandler(responseModel)
            self?.preLoadNextData(currentData: responseModel, completeHandler: completeHandler)
        }
    }
    
    func fetchSayHiDataWithPage(page: Int, completeHandler: @escaping (_ responseModel: ZZSayHiModelRespones?) -> Void) {
        guard let helper = ZZUserHelper.shareInstance(), let user = helper.loginer, let userId = user.uid else {
            return
        }
        
        var location: CLLocation? = nil
        if helper.location != nil {
            location = helper.location
        }
        else if let userLoc = helper.loginer.loc as? [Double], userLoc.count == 2 {
            location = CLLocation(latitude: userLoc[1], longitude: userLoc[0])
        }
        
        guard location != nil else {
            ZZHUD.showTastInfoError(with: "打招呼需开启手机定位!")
            return
        }
        
        isLoadingData = true
        
        var type = sayHiType
        if type == .dailyLogin {
            type = .login
        }
        
        var url = "/api/sayhinew/getSayHiFirm42"
        if ZZUserHelper.shareInstance()?.configModel?.open_sayhi_new == false || sayHiType == .login || sayHiType == .dailyLogin {
            url = "/api/sayhinew/newGetSayHiFirm"
        }
        
        var info = [
            "uid": userId,
            "lat": location!.coordinate.latitude,
            "lng": location!.coordinate.longitude,
            "firmType": type.rawValue,
            ] as [String : Any]
        
        if sayHiType == .dailyLogin {
            ZZHUD.show()
            info["opensayhi"] = 1
        }
        
        if sayHiType == .dailyLogin || sayHiType == .login {
            info["page"] = page
        }
        
        ZZRequest.method("GET",
                         path: url,
                         params: info)
        { (error, data, _) in
            if self.sayHiType == .dailyLogin {
                ZZHUD.dismiss()
            }
            
            self.isLoadingData = false
            if error == nil, let dic = data as? [String: Any] {
                completeHandler(ZZSayHiModelRespones.yy_model(with: dic))

                // for test
//                let model = ZZSayHiModelRespones.yy_model(with: dic)
//                model?.users = Array(repeating: ZZUserHelper.shareInstance()!.loginer, count: Int(arc4random() % 10))
//                model?.sayHiUsers = Array(repeating: SayHiUser(user: ZZUserHelper.shareInstance()!.loginer, index: 0), count: Int(arc4random() % 10))
//                model?.showFirm = true
//                completeHandler(model)
            }
            else {
                completeHandler(nil)
            }
        }
    }
    
    /*
     发送消息
     */
    func sendLogin(exclude users: String, content: String, didChangeContent: Bool, _ completeHandler: @escaping (_ isSuccess: Bool) -> Void) {
        guard let helper = ZZUserHelper.shareInstance(), let user = helper.loginer, let userId = user.uid else {
            return
        }
        
        var editType = 0
        if sayHiType == .rent {
            editType = 1
            if ZZUserHelper.shareInstance()?.didHaveOldAvatar() == true || ZZUserHelper.shareInstance()?.didHaveRealAvatar() == true {
                editType = 0
            }
        }
        else if sayHiType == .login || sayHiType == .dailyLogin {
            editType = didChangeContent ? 1 : 0
        }
        
        var type = sayHiType
        if type == .dailyLogin {
            type = .login
        }
        
        ZZRequest.method("POST",
                         path: "/api/sayhinew/newSendSayHiToUsers",
                         params: [
                            "allNotice": 1,
                            "notNoticeArr": users,
                            "from": userId,
                            "content": content,
                            "editType": editType,
                            "firmType": type.rawValue,
                            "lat": helper.location.coordinate.latitude,
                            "lng": helper.location.coordinate.longitude,
            ])
        { (error, data, _) in
            if error == nil {
                completeHandler(true)
                return;
            }
            ZZHUD.showError(withStatus: error?.message ?? "发送失败,请重试")
            completeHandler(false)
        }
    }

    
//    func send(to users: String, content: String, didChangeContent: Bool, _ completeHandler: @escaping (_ isSuccess: Bool) -> Void) {
//        guard let helper = ZZUserHelper.shareInstance(), let user = helper.loginer, let userId = user.uid else {
//            return
//        }
//        
//        var editType = 0
//        if sayHiType == .rent {
//            editType = 1
//            if ZZUserHelper.shareInstance()?.didHaveOldAvatar() == true || ZZUserHelper.shareInstance()?.didHaveRealAvatar() == true {
//                editType = 0
//            }
//        }
//        else if sayHiType == .login {
//            editType = didChangeContent ? 1 : 0
//        }
//        
//        var type = sayHiType
//        if type == .dailyLogin {
//            type = .login
//        }
//        
//        ZZRequest.method("POST",
//                         path: "/api/sayhinew/sendSayhiToUsers",
//                         params: [
//                            "from": userId,
//                            "toUids": users,
//                            "content": content,
//                            "editType": editType,
//                            "firmType": type.rawValue])
//        { (error, data, _) in
//            if error == nil {
//                completeHandler(true)
//                return;
//            }
//            ZZHUD.showError(withStatus: error?.message ?? "发送失败,请重试")
//            completeHandler(false)
//        }
//    }
    
    @objc func send(to users: [String], content: String, didChangeContent: Bool, completeHandler: @escaping (_ isSuccess: Bool) -> Void) {
        guard let helper = ZZUserHelper.shareInstance(), let user = helper.loginer, let _ = user.uid else {
            return
        }
        
        let puhData = "收到一条新的信息"
        let pushContent = ZZUtils.dictionary(toJson: ["rc" : [
            "fId": ZZUserHelper.shareInstance().loginer.uid,
            "tId": "ss",
            "cType" : "PR"
        ]])
        
        MessageHelper.SendMessage(message: content, to: users, pushContent: pushContent ?? "", pushData: puhData) {
            completeHandler(true)
        }
        
//        var editType = 0
//        if sayHiType == .rent {
//            editType = 1
//            if ZZUserHelper.shareInstance()?.didHaveOldAvatar() == true || ZZUserHelper.shareInstance()?.didHaveRealAvatar() == true {
//                editType = 0
//            }
//        }
//        else if sayHiType == .login {
//            editType = didChangeContent ? 1 : 0
//        }
//
//        var type = sayHiType
//        if type == .dailyLogin {
//            type = .login
//        }
    }
    
    /*
     检测发送内容是否违规
     */
    func checkIfContentIsIllegal(content: String, completeHandler: @escaping (_ isPassTheDetect: Bool) -> Void) {
        ZZUserHelper.checkText(withText: content, type: 6) { (error, data, _) in
            if let error = error {
                ZZHUD.showError(withStatus: error.message)
                completeHandler(false)
            }
            else {
                completeHandler(true)
            }
        }
    }
}
