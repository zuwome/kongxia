//
//  ZZSayHiView.swift
//  zuwome
//
//  Created by qiming xiao on 2019/6/10.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

protocol SayHiCellDelegate: NSObjectProtocol {
    func didSelecteUser(cell: UICollectionViewCell, sayHiUser: SayHiUser?)
}


// MARK: - ZZSayHiView
class ZZSayHiView: UIView {
    let maxCount: Int = 80
    let responseModel: ZZSayHiModelRespones
    let kwindow = UIApplication.shared.keyWindow!
    let sayHiType: SayHiType
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
        return view
    }()
    
    lazy var contentView: ZZSayHiContentView = {
        let view = ZZSayHiContentView(responseModel: self.responseModel)
        view.backgroundColor = .white
        view.layer.cornerRadius = 6
        view.cancelBtn.addTarget(self, action: #selector(hideView), for: .touchUpInside)
        view.confirmBtn.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        view.editBtn.addTarget(self, action: #selector(editContent), for: .touchUpInside)
        return view
    }()
    
    var editView: SayhiEditContentView?
    
    init(frame: CGRect, responseModel: ZZSayHiModelRespones, type: SayHiType) {
        self.sayHiType = type
        self.responseModel = responseModel
        super.init(frame: frame)
        layout()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("ZZSayHiView is deinit")
    }
    
    func configure() {
        var title = self.responseModel.firm_title
        if var title = title, title.count > 0 {
            if sayHiType == .changeCity {
                if let range = title.range(of: "city") {
                    title.replaceSubrange(range, with: ZZUserHelper.shareInstance()?.cityName ?? "")
                }
                else {
                    title = "向\(ZZUserHelper.shareInstance()?.cityName ?? "")的新朋友打招呼"
                }
                contentView.titleLabel.text = title
            }
            else {
                contentView.titleLabel.text = title
            }
        }
        else {
            if sayHiType == .changeCity {
                title = "向\(ZZUserHelper.shareInstance()?.cityName ?? "该城市")的新朋友打招呼"
            }
            else if sayHiType == .login || sayHiType == .dailyLogin {
                title = "一键获取私信收益"
            }
            else if sayHiType == .rent {
                title = "申请成功!"
            }
            else if sayHiType == .recallLogin {
                title = "欢迎老朋友回来"
            }
            contentView.titleLabel.text = title
        }
        
        if var content = self.responseModel.send_content, content.count > 0 {
            if sayHiType == .changeCity {
                if let range = content.range(of: "{city}") {
                    content.replaceSubrange(range, with: ZZUserHelper.shareInstance()?.cityName ?? "")
                    self.responseModel.send_content = content
                }
            }
        }
    }
    
    func hide() {
        self.endEditing(true)
        UIView.animate(withDuration: 0.3, animations: {
            self.bgView.alpha = 0
            self.contentView.top = screenHeight
        }) { (_) in
            self.bgView.removeFromSuperview()
            self.contentView.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
    
    func closeEditContentView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.editView!.top = screenHeight
        }) { (_) in
            self.contentView.alpha = 1.0;
            self.editView?.removeFromSuperview()
            self.editView = nil
        }
    }
    
}


// MARK: Respones Method
extension ZZSayHiView {
    @objc func editContent() {
        if editView != nil {
            return
        }
        editView = SayhiEditContentView(content: responseModel.send_content, frame: CGRect(x: screenWidth * 0.5 - 312 * 0.5, y: screenHeight, width: 312, height: 271))
        editView?.delegate = self
        self.addSubview(editView!)
        
        contentView.alpha = 0.0;
        UIView.animate(withDuration: 0.2) {
            self.editView!.top = screenHeight * 0.5 - 271 * 0.5
        }
    }
    
    @objc func dontShow() {
    }
    
    @objc func hideView() {
        hide()
        if sayHiType == .login {
            ZZHUD.showTastInfo(with: "关闭成功, 7天内将不再提示您打招呼")
            ZZSayHiHelper.shared.hideSayhi()
        }
    }
    
    @objc func confirm() {
        
        var usersStr: String = ""
        if sayHiType == .login || sayHiType == .dailyLogin {
            guard let selectUsers = fetchSelectedUsers(), selectUsers.count != responseModel.sayHiUsers?.count else {
                ZZHUD.showError(withStatus: "请选择需要发送的用户")
                return
            }
            
            if (sayHiType == .login || sayHiType == .dailyLogin) && responseModel.send_content?.count == 0 {
                ZZHUD.showError(withStatus: "请输入打招呼内容")
                return
            }
            
            guard let usersData = try? JSONSerialization.data(withJSONObject: selectUsers, options: []) else {
                return
            }
            
            guard let usersJson = String(data: usersData, encoding: String.Encoding.utf8) else {
                return
            }
            usersStr = usersJson
        }
        else {
            guard let selectUsers = fetchSelectedUsers(), selectUsers.count > 0 else {
                ZZHUD.showError(withStatus: "请选择需要发送的用户")
                return
            }
            
            guard let usersData = try? JSONSerialization.data(withJSONObject: selectUsers, options: []) else {
                return
            }
            
            guard let usersJson = String(data: usersData, encoding: String.Encoding.utf8) else {
                return
            }
            usersStr = usersJson
        }
        
        ZZHUD.show()
        
        if ZZSayHiHelper.shared.sayHiType == .login || ZZSayHiHelper.shared.sayHiType == .dailyLogin {
            ZZSayHiHelper.shared.sendLogin(exclude: usersStr,
                                           content: responseModel.send_content ?? "",
                                           didChangeContent: self.responseModel.isContentModified,
                                           { (isSuccess) in
                if isSuccess {
                    ZZHUD.showTastInfo(with: "发送成功")
                    self.hide()
                }
            })
        }
        else {
            ZZSayHiHelper.shared.send(to: usersStr,
                                      content: responseModel.send_content ?? "",
                                      didChangeContent: self.responseModel.isContentModified,
                                      { (isSuccess) in
                if isSuccess {
                    ZZHUD.showTastInfo(with: "发送成功")
                    self.hide()
                }
            })
        }
        
    }
    
    func fetchSelectedUsers() -> [String]? {
        if sayHiType == .login || sayHiType == .dailyLogin {
            return responseModel.sayHiUsers?.compactMap{ sayHiUser -> String? in
                if !sayHiUser.isSelected {
                    return sayHiUser.user.uid
                }
                else {
                    return nil
                }
            }
        }
        else {
            return responseModel.sayHiUsers?.compactMap{ sayHiUser -> String? in
                if sayHiUser.isSelected {
                    return sayHiUser.user.uid
                }
                else {
                    return nil
                }
            }
        }
        
    }
}


// MARK: SayhiEditContentViewDelegate
extension ZZSayHiView: SayhiEditContentViewDelegate {
    func sendSayHi(view: SayhiEditContentView, content: String) {
        
        ZZHUD.show()
        // 易盾检测
        ZZSayHiHelper.shared.checkIfContentIsIllegal(content: content) { (isPassTheDetect) in
            ZZHUD.dismiss()
            if isPassTheDetect {
                self.responseModel.send_content = content
                self.closeEditContentView()
                self.confirm()
            }
            else {
                ZZHUD.showError(withStatus: "您的介绍内容可能含有不良词汇,请重新填写")
            }
        }
    }
    
    func closeEditView(view: SayhiEditContentView, content: String) {
        closeEditContentView()
    }
}

// MARK: Layout
extension ZZSayHiView {
    func layout() {
        self.addSubview(bgView)
        self.addSubview(contentView)
        bgView.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screenHeight)
        contentView.center = kwindow.center
        contentView.bounds = CGRect(x: 0,
                                    y: 0,
                                    width: 312,
                                    height: (ZZSayHiHelper.shared.sayHiType == .login || ZZSayHiHelper.shared.sayHiType == .dailyLogin)  ? 371 : 346)
    }
}


//-------------------------------------------------------------------------
// MARK: - ZZSayHiContentView
class ZZSayHiContentView: UIView {
    let maxCount: Int = 80
    let responseModel: ZZSayHiModelRespones
    var isFetchingData: Bool = false
    
    var totalPages: Int  {
        guard let users = responseModel.sayHiUsers else {
            return 0
        }
        
        if users.count <= 4 {
            return 1
        }
        else {
            return Int(ceil(Double(users.count - 4) / 6.0) + 1)
        }
    }
    
    var lastPageOffset: CGFloat = 0
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "一键打招呼"
        label.font = boldFont(17)
        label.textAlignment = .center
        label.textColor = UIColor.rgbColor(63, 58, 58)
        return label
    }()
    
    lazy var cancelBtn: UIButton = {
        let btn = UIButton()
        btn.normalImage = UIImage(named: "icGbTc")
        return btn
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        btn.normalTitle = "一键打招呼"
        btn.backgroundColor = UIColor.rgbColor(244, 203, 7)
        btn.normalTitleColor = UIColor.rgbColor(63, 58, 58)
        btn.titleLabel?.font = UIFont(name: "PingFangSC-Medium", size: 14)
        btn.layer.cornerRadius = 22
        return btn
    }()
    
    lazy var flowlayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 312, height: 155)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        return flowLayout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowlayout)
        collectionView.register(SayHiFirstPageCell.self, forCellWithReuseIdentifier: "SayHiFirstPageCell")
        collectionView.register(SayHiCell.self, forCellWithReuseIdentifier: "SayHiCell")
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        return collectionView
    }()
    
    lazy var preBtn: UIButton = {
        let btn = UIButton()
        btn.normalTitle = "上一页"
        btn.normalTitleColor = UIColor.rgbColor(153, 153, 153) //rgbColor(63, 58, 58)
        btn.titleLabel?.font = UIFont(name: "PingFangSC-Medium", size: 11) ?? font(11)
        
        btn.tag = 0
        btn.addTarget(self, action: #selector(switchPageAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var nextBtn: UIButton = {
        let btn = UIButton()
        btn.normalTitle = "下一页"
        btn.normalTitleColor = UIColor.rgbColor(63, 58, 58) //rgbColor(153, 153, 153)
        btn.titleLabel?.font = UIFont(name: "PingFangSC-Medium", size: 11) ?? font(11)
        
        btn.tag = 1
        btn.addTarget(self, action: #selector(switchPageAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var editBtn: UIButton = {
        let btn = UIButton()
        btn.normalTitle = "编辑招呼内容"
        btn.normalTitleColor = UIColor.rgbColor(244, 203, 7)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
//        btn.addTarget(self, action: #selector(switchPageAction), for: .touchUpInside)
        return btn
    }()
   
    init(responseModel: ZZSayHiModelRespones) {
        self.responseModel = responseModel
        super.init(frame: .zero)
        layout()
        preloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     * 翻页
     */
    func switchingPage(next: Bool) {
        var page = Int(collectionView.contentOffset.x / self.width)
        if next {
            // 下一页
            guard page != totalPages - 1 else {
                return
            }
            page += 1
            let contentOffset = self.width * CGFloat(page)
            collectionView.setContentOffset(CGPoint(x: contentOffset, y: 0), animated: true)
            
            shouldFetchMoreData(currentPage: page)
        }
        else {
            // 上一页
            guard page != 0 else {
                return
            }
            page -= 1
            let contentOffset = self.width * CGFloat(page)
            collectionView.setContentOffset(CGPoint(x: contentOffset, y: 0), animated: true)
        }
        
        changeBtnStatus();
        
    }
    
    func changeBtnStatus() {
        let page = Int(collectionView.contentOffset.x / self.width)
        if page ==  0 {
            preBtn.normalTitleColor = UIColor.rgbColor(153, 153, 153)
            nextBtn.normalTitleColor = UIColor.rgbColor(63, 58, 58)
        }
        else if page == totalPages - 1 {
            preBtn.normalTitleColor = UIColor.rgbColor(63, 58, 58)
            nextBtn.normalTitleColor = UIColor.rgbColor(153, 153, 153)
        }
        else {
            preBtn.normalTitleColor = UIColor.rgbColor(63, 58, 58)
            nextBtn.normalTitleColor = UIColor.rgbColor(63, 58, 58)
        }
    }
    
    func preloadData() {
        ZZSayHiHelper.shared.preLoadNextData(currentData: responseModel) { (responseModel) in
            guard let responseModel = responseModel,
                let users = responseModel.sayHiUsers,
                users.count > 0 else {
                    return
            }
            
            if var orUsers = self.responseModel.sayHiUsers {
                orUsers += users
                self.responseModel.sayHiUsers = orUsers
            }
            else {
                self.responseModel.sayHiUsers = users
            }
            
            self.collectionView.reloadData()
        }
    }
    
    func shouldFetchMoreData(currentPage: Int) {
        guard ZZSayHiHelper.shared.sayHiType == .login || ZZSayHiHelper.shared.sayHiType == .dailyLogin else {
            return;
        }
        
        // 是否需要提前去加载数据
        guard (totalPages - 1) - currentPage == 3 else {
            return
        }
        
        guard isFetchingData == false else {
            return
        }
        
        isFetchingData = true
        
        // 获取更多数据
        ZZSayHiHelper.shared.loadMore { (responseModel) in
            self.isFetchingData = false
            
            guard let responseModel = responseModel,
                let users = responseModel.sayHiUsers,
                users.count > 0 else {
                    return
            }
            
            if var orUsers = self.responseModel.sayHiUsers {
                orUsers += users
                self.responseModel.sayHiUsers = orUsers
            }
            else {
                self.responseModel.sayHiUsers = users
            }
            
            self.collectionView.reloadData()
        }
    }
}


// MARK: method
extension ZZSayHiContentView {
    func tappedTheSayHiUser(sayHiUser: SayHiUser) {
        sayHiUser.isSelected = !sayHiUser.isSelected
        collectionView.reloadData()
    }
    
    @objc func switchPageAction(sender: UIButton) {
        switchingPage(next: sender.tag != 0)
    }
}


// MARK: SayHiCellDelegate
extension ZZSayHiContentView: SayHiCellDelegate {
    func didSelecteUser(cell: UICollectionViewCell, sayHiUser: SayHiUser?) {
        if let sayHiUser = sayHiUser {
            tappedTheSayHiUser(sayHiUser: sayHiUser)
        }
    }
}


// MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension ZZSayHiContentView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalPages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SayHiFirstPageCell", for: indexPath) as! SayHiFirstPageCell
            
            let endIndex = responseModel.sayHiUsers!.count < 4 ? responseModel.sayHiUsers!.count - 1 : 4 - 1
            cell.configure(title: responseModel.title_a, secondTitle: responseModel.title_b, users: Array(responseModel.sayHiUsers![0...endIndex]))
            cell.delegate = self
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SayHiCell", for: indexPath) as! SayHiCell
            let startIndex = 4 + (indexPath.item - 1) * 6
            let endIndex = startIndex + 5 >= responseModel.sayHiUsers!.count ? (responseModel.sayHiUsers!.count - 1) : startIndex + 5
            cell.configure(users: Array(responseModel.sayHiUsers![startIndex...endIndex]))
            cell.delegate = self
            return cell
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastPageOffset = scrollView.contentOffset.x
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > lastPageOffset {
            let page = Int(scrollView.contentOffset.x / self.width)
            shouldFetchMoreData(currentPage: page)
        }
    }
}


// MARK: Layout
extension ZZSayHiContentView {
    func layout() {
        self.addSubview(cancelBtn)
        self.addSubview(confirmBtn)
        self.addSubview(preBtn)
        self.addSubview(nextBtn)
        self.addSubview(collectionView)
        self.addSubview(titleLabel)
        
        
        cancelBtn.mas_makeConstraints { (make) in
            make?.right.equalTo()(self)?.offset()(-15)
            make?.top.equalTo()(self)?.offset()(10)
            make?.size.mas_equalTo()(CGSize(width: 22, height: 22))
        }
        
        titleLabel.mas_makeConstraints { (make) in
            make?.left.right()?.equalTo()(self)
            make?.top.equalTo()(self)?.offset()(36)
        }
        
        collectionView.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)
            make?.right.equalTo()(self)
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(8)
            make?.height.equalTo()(155)
        }
        
        preBtn.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.offset()(86)
            make?.top.equalTo()(collectionView.mas_bottom)?.offset()(16)
            make?.size.equalTo()(CGSize(width: 60, height: 20))
        }
        
        nextBtn.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(preBtn)
            make?.left.equalTo()(preBtn.mas_right)?.offset()(15.0)
            make?.size.equalTo()(CGSize(width: 60, height: 20))
        }
        
        confirmBtn.mas_makeConstraints { (make) in
            make?.top.equalTo()(preBtn.mas_bottom)?.offset()(26)
            make?.size.mas_equalTo()(CGSize(width: 200, height: 44))
            make?.centerX.equalTo()(self)
        }
        
        if ZZSayHiHelper.shared.sayHiType == .login || ZZSayHiHelper.shared.sayHiType == .dailyLogin {
            self.addSubview(editBtn)
            editBtn.mas_makeConstraints { (make) in
                make?.top.equalTo()(confirmBtn.mas_bottom)?.offset()(16)
                make?.size.mas_equalTo()(CGSize(width: 100, height: 20))
                make?.centerX.equalTo()(self)
            }
        }
    }
}


//-------------------------------------------------------------------------
// MARK: - SayHiFirstPageCell
class SayHiFirstPageCell: UICollectionViewCell {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "向附近的优质用户打招呼，你将获得高曝光、高排名、高人气、高收益"
        label.textColor = UIColor.rgbColor(102, 102, 102)
        label.font = UIFont(name: "PingFangSC-Medium", size: 14)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    var imagesArr: [SayHiPeopleView] = []
    weak var delegate: SayHiCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String?, secondTitle:String?, users: [SayHiUser]) {
        
        for (index, imageView) in imagesArr.enumerated() {
            if index >= users.count {
                imageView.isHidden = true
            }
            else {
                imageView.isHidden = false
                let sayHiUser = users[index]
                imageView.configureData(sayHiUser: sayHiUser)
            }
        }
        
        guard let title = title else {
            return
        }
        titleLabel.text = title
    }
    
    @objc func tapped(tapGesture: UITapGestureRecognizer) {
        if let view = tapGesture.view as? SayHiPeopleView {
            delegate?.didSelecteUser(cell: self, sayHiUser: view.sayHiUser)
        }
    }
}


// MARK: SayHiFirstPageCell Layout
extension SayHiFirstPageCell {
    func layout() {
        
        self.addSubview(titleLabel)
        titleLabel.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(self)
            make?.top.equalTo()(self)
            make?.width.equalTo()(236)
        }
        
        let offsetX: CGFloat = 19
        let offsetY: CGFloat = 17
        let viewWidth: CGFloat = 124
        let viewHeight: CGFloat = 32
        for i in 0..<4 {
            let view = SayHiPeopleView()
            view.tag = i
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
            view.addGestureRecognizer(tap)
            self.addSubview(view)
            let offsetLeft: CGFloat = CGFloat((viewWidth + offsetX) * CGFloat((i % 2)) + 22)
            let offsettop: CGFloat = CGFloat((viewHeight + offsetY) * CGFloat((i / 2)) + 24)
            view.mas_makeConstraints { (make) in
                make?.left.equalTo()(self)?.offset()(offsetLeft)
                make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(offsettop)
                make?.size.mas_equalTo()(CGSize(width: viewWidth, height: viewHeight))
            }
            imagesArr.append(view)
        }
    }
}


//-------------------------------------------------------------------------
// MARK: - SayHiCell
class SayHiCell: UICollectionViewCell {
    var imagesArr: [SayHiPeopleView] = []
    
    weak var delegate: SayHiCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(users: [SayHiUser]) {
        for (index, imageView) in imagesArr.enumerated() {
            if index >= users.count {
                imageView.isHidden = true
            }
            else {
                imageView.isHidden = false
                let sayHiUser = users[index]
                imageView.configureData(sayHiUser: sayHiUser)
            }
        }
    }
    
    @objc func tapped(tapGesture: UITapGestureRecognizer) {
        if let view = tapGesture.view as? SayHiPeopleView {
            delegate?.didSelecteUser(cell: self, sayHiUser: view.sayHiUser)
        }
    }
}


// MARK: SayHiCell Layout
extension SayHiCell {
    func layout() {
        let offsetX: CGFloat = 19
        let offsetY: CGFloat = 17
        let viewWidth: CGFloat = 124
        let viewHeight: CGFloat = 32
        for i in 0..<6 {
            let view = SayHiPeopleView()
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
            view.addGestureRecognizer(tap)
            self.addSubview(view)
            let offsetLeft: CGFloat = CGFloat((viewWidth + offsetX) * CGFloat((i % 2)) + 22)
            let offsetTop: CGFloat = CGFloat((viewHeight + offsetY) * CGFloat((i / 2)) + 15)
            view.mas_makeConstraints { (make) in
                make?.left.equalTo()(self)?.offset()(offsetLeft)
                make?.top.equalTo()(self)?.offset()(offsetTop)
                make?.size.mas_equalTo()(CGSize(width: viewWidth, height: viewHeight))
            }
            imagesArr.append(view)
        }
    }
}


//-------------------------------------------------------------------------
// MARK: - SayHiPeopleView
class SayHiPeopleView: UIView {
    var sayHiUser: SayHiUser?
    
    lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bgVedioProtect11")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var userIconImageView: ZZHeadImageView = {
        let imageView = ZZHeadImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Medium", size: 10)
        label.textColor = UIColor.rgbColor(63, 58, 58)
        label.text = "小小说说"
        return label
    }()
    
    lazy var levelImageView: ZZLevelImgView = {
        let imageView = ZZLevelImgView()
        imageView.setLevel(100)
        return imageView
    }()
    
    lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var statusView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureData(sayHiUser: SayHiUser) {
        self.sayHiUser = sayHiUser
        userIconImageView.setUser(sayHiUser.user, width: 23, vWidth: 12)
        titleLabel.text = sayHiUser.user.nickname
        checkImageView.image = UIImage(named: sayHiUser.isSelected ? "icXuanze" : "icWeixuanze")
        if sayHiUser.user.level >= 20 {
            statusView.isHidden = true
            levelImageView.isHidden = false
            levelImageView.setLevel(sayHiUser.user.level)
        }
        else {
            if sayHiUser.user.mark.is_new_rent {
                statusView.isHidden = false
                levelImageView.isHidden = true
                statusView.image = UIImage(named: "icNew")
            }
            else if sayHiUser.user.mark.is_flighted_user {
                statusView.isHidden = false
                levelImageView.isHidden = true
                statusView.image = UIImage(named: "icYouke")
            }
            else if sayHiUser.user.mark.is_short_distance_user {
                statusView.isHidden = false
                levelImageView.isHidden = true
                statusView.image = UIImage(named: "icon_user_car")
            }
            else {
                statusView.isHidden = true
                levelImageView.isHidden = false
                levelImageView.setLevel(sayHiUser.user.level)
            }
        }
    }
}


// MARK: Layout
extension SayHiPeopleView {
    func layout() {
        self.layer.cornerRadius = 15
        self.backgroundColor = UIColor.rgbColor(240, 240, 240 )
        
        self.addSubview(userIconImageView)
        self.addSubview(titleLabel)
        self.addSubview(levelImageView)
        self.addSubview(checkImageView)
        self.addSubview(statusView)
        
        userIconImageView.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(self)
            make?.left.equalTo()(self)?.offset()(4.5)
            make?.size.mas_equalTo()(CGSize(width: 23, height: 23))
        }
        
        titleLabel.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(self)
            make?.left.equalTo()(userIconImageView.mas_right)?.offset()(5)
            make?.width.equalTo()(40)
        }
        
        levelImageView.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(self)
            make?.left.equalTo()(titleLabel.mas_right)?.offset()(5)
            make?.size.mas_equalTo()(CGSize(width: 28, height: 12))
        }
        
        statusView.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(self)
            make?.left.equalTo()(titleLabel.mas_right)?.offset()(7)
            make?.size.mas_equalTo()(CGSize(width: 21, height: 12))
        }
        
        checkImageView.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(self.mas_bottom)
            make?.right.equalTo()(self)?.offset()(-5)
            make?.size.mas_equalTo()(CGSize(width: 14, height: 14))
        }
    }
}

//-------------------------------------------------------------------------
// MARK: - SayhiEditContentView
protocol SayhiEditContentViewDelegate: NSObjectProtocol {
    func sendSayHi(view: SayhiEditContentView, content: String)
    func closeEditView(view: SayhiEditContentView, content: String)
}


class SayhiEditContentView: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "编辑打招呼内容"
        label.font = boldFont(17)
        label.textAlignment = .center
        label.textColor = UIColor.rgbColor(63, 58, 58)
        return label
    }()
    
    lazy var cancelBtn: UIButton = {
        let btn = UIButton()
        btn.normalImage = UIImage(named: "icGbTc")
        btn.addTarget(self, action: #selector(close), for: .touchUpInside)
        return btn
    }()
    
    lazy var textBGView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgbColor(245, 245, 245)
        view.layer.cornerRadius = 5
        return view
    }()
    
    lazy var inputTextView: UITextView = {
        let view = UITextView()
        view.text = "本人不高冷逗比有话题~喜欢可邀约呦，公众场合出租，真诚交友~真诚交友真"
        view.textColor = UIColor.rgbColor(63, 58, 58)
        view.backgroundColor = .clear
        view.textContainerInset = .zero
//        view.delegate = self
        return view
    }()
    
    lazy var countsLabel: UILabel = {
        let label = UILabel()
        label.text = "0/\(maxCount)"
        label.textColor = UIColor.rgbColor(153, 153, 153)
        label.font = UIFont(name: "PingFangSC-Medium", size: 11)
        return label
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        btn.normalTitle = "发送"
        btn.backgroundColor = UIColor.rgbColor(244, 203, 7)
        btn.normalTitleColor = UIColor.rgbColor(63, 58, 58)
        btn.titleLabel?.font = UIFont(name: "PingFangSC-Medium", size: 14)
        btn.layer.cornerRadius = 22
        btn.addTarget(self, action: #selector(send), for: .touchUpInside)
        return btn
    }()
    
    var content: String?
    let maxCount: Int = 80
    let kwindow = UIApplication.shared.keyWindow!
    weak var delegate: SayhiEditContentViewDelegate?
    
    init(content: String?, frame: CGRect) {
        self.content = content
        super.init(frame: frame)
        layout()
        addNotifications()
        
        inputTextView.text = content
        didInputTextMaxOut(textView: inputTextView, oriText: inputTextView.text)
    }
    
    deinit {
        removeNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didInputTextMaxOut(textView: UITextView, oriText: String) {
        if oriText.count > maxCount {
            let rangeIndex = (oriText as NSString).rangeOfComposedCharacterSequence(at: maxCount)
            if rangeIndex.length == 1 {
                textView.text = (oriText as NSString).substring(to: maxCount)
            }
            else {
                let rangeRange = (oriText as NSString).rangeOfComposedCharacterSequences(for: NSRange(location: 0, length: maxCount))
                textView.text = (oriText as NSString).substring(with: rangeRange)
            }
            countsLabel.text = "\(maxCount)/\(maxCount)"
        }
        countsLabel.text = "\(textView.text.count)/\(maxCount)"
    }
}


// MARK: Notifications
extension SayhiEditContentView {
    func addNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
    }
    
    func removeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let info = notification.userInfo {
            let curkeyBoardRect = info["UIKeyboardBoundsUserInfoKey"] as! CGRect
            let curkeyBoardHeight = curkeyBoardRect.size.height
            
            let beginRect = info["UIKeyboardFrameBeginUserInfoKey"] as! CGRect
            let endRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
            
            let keyBoardTop = screenHeight - curkeyBoardHeight;
            if (curkeyBoardHeight > self.bottom) {
                return;
            }
            
            /*! 第三方键盘回调三次问题，监听仅执行最后一次 */
            // pragma warning iOS 11 Will Some Problems
            if beginRect.size.height > 0 && (beginRect.origin.y - endRect.origin.y > 0) {
                UIView.animate(withDuration: 0.25) {
                    self.top -= self.bottom - keyBoardTop;
                }
            }
        }
    }
    
    @objc func keyboardWillHide() {
        UIView.animate(withDuration: 0.25) {
            self.center = self.kwindow.center
        }
    }
    
    @objc func keyboardWillChangeFrame(notification: Notification) {
        if let info = notification.userInfo {
            let curkeyBoardRect = info["UIKeyboardBoundsUserInfoKey"] as! CGRect
            let curkeyBoardHeight = curkeyBoardRect.size.height
            
            let beginRect = info["UIKeyboardFrameBeginUserInfoKey"] as! CGRect
            let endRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
            
            let keyBoardTop = screenHeight - curkeyBoardHeight;
            if (curkeyBoardHeight > self.bottom) {
                return;
            }
            
            /*! 第三方键盘回调三次问题，监听仅执行最后一次 */
            // pragma warning iOS 11 Will Some Problems
            if beginRect.size.height > 0 && (beginRect.origin.y - endRect.origin.y > 0) {
                UIView.animate(withDuration: 0.25) {
                    self.top -= self.bottom - keyBoardTop;
                }
            }
        }
    }
    
    @objc func textChange(notification: Notification) {
        guard let textView = notification.object as? UITextView else {
            return
        }
        
        guard let oriText = textView.text else {
            return
        }
        
        var textPosition: UITextPosition? = nil
        if let hightLightedRange = textView.markedTextRange {
            textPosition = textView.position(from: hightLightedRange.start , offset: 0)
        }
        
        guard textPosition == nil else {
            return
        }
        
        didInputTextMaxOut(textView: textView, oriText: oriText)
    }
}


// MARK: Respone
extension SayhiEditContentView {
    @objc func send() {
        self.endEditing(true)
        
        guard inputTextView.text.count > 0 else {
            ZZHUD.showError(withStatus: "请输入打招呼内容")
            return
        }
        
        delegate?.sendSayHi(view: self, content: inputTextView.text)
    }
    
    @objc func close() {
        self.endEditing(true)
        delegate?.closeEditView(view: self, content: inputTextView.text)
    }
}


// MARK: Layout
extension SayhiEditContentView {
    func layout() {
        self.layer.cornerRadius = 6
        self.backgroundColor = .white
        
        self.addSubview(titleLabel)
        self.addSubview(cancelBtn)
        self.addSubview(textBGView)
        textBGView.addSubview(inputTextView)
        textBGView.addSubview(countsLabel)
        self.addSubview(confirmBtn)
        
        titleLabel.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(self)
            make?.top.equalTo()(28)
        }
        
        cancelBtn.mas_makeConstraints { (make) in
            make?.right.equalTo()(self)?.offset()(-15)
            make?.top.equalTo()(self)?.offset()(10)
            make?.size.mas_equalTo()(CGSize(width: 22, height: 22))
        }
        
        textBGView.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(self)
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(28)
            make?.size.mas_equalTo()(CGSize(width: 272, height: 123))
        }
        
        inputTextView.mas_makeConstraints { (make) in
            make?.top.left().equalTo()(textBGView)?.offset()(8)
            make?.right.equalTo()(textBGView)?.offset()(-8)
            make?.bottom.equalTo()(textBGView)?.offset()(-22.5)
        }
        
        countsLabel.mas_makeConstraints { (make) in
            make?.right.equalTo()(textBGView)?.offset()(-8)
            make?.bottom.equalTo()(textBGView)?.offset()(-5)
        }
        
        confirmBtn.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(self)
            make?.top.equalTo()(textBGView.mas_bottom)?.offset()(16)
            make?.size.mas_equalTo()(CGSize(width: 200, height: 44))
        }
    }
}
