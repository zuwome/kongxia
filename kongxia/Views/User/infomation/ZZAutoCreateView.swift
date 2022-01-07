//
//  ZZAutoCreateView.swift
//  zuwome
//
//  Created by qiming xiao on 2019/5/8.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit
import Foundation

@objc protocol ZZAutoCreateViewDelegate: NSObjectProtocol {
    func showSkillsView(skills: [ZZSkillTag]?)
    
    func confirmSelection(createContents: [String], skills: [ZZSkillTag]?)
    
    func dismissed()
}

@objc class ZZAutoCreateView: UIView {
    lazy var bgView: UIView = {
        let bgview = UIView()
        bgview.backgroundColor = .black
        bgview.alpha = 0.0
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        bgview.addGestureRecognizer(tap)
        return bgview
    }()
   
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        return contentView
    }()
    
    lazy var cancleBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        btn.normalImage = UIImage(named: "icCloseCopy14")
        return btn
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17.0)
        label.textColor = rgbColor(55, 55, 55);
        label.text = "请填写以下信息为您生成技能介绍"
        return label
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = rgbColor(244, 203, 7)
        btn.normalTitle = "确认生成";
        btn.normalTitleColor = rgbColor(63, 58, 58)
        btn.titleLabel?.font = font(15)
        btn.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        return btn
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = Color.white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableviewcell")
        tableView.register(ZZAutoCreateInputCell.self, forCellReuseIdentifier: ZZAutoCreateInputCell.cellIdentifier())
        tableView.register(ZZAutoCreateSelectCell.self, forCellReuseIdentifier: ZZAutoCreateSelectCell.cellIdentifier())
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    @objc weak var delegate: ZZAutoCreateViewDelegate?
    
    var infoDic: ZZAutoCreateDesModel
    
    @objc var skillsArray: [ZZSkillTag]? = nil {
        didSet {
            tableView.reloadData()
        }
    }
    
    @objc static func show(in vc: UIViewController, info: ZZAutoCreateDesModel, skillsArray: [ZZSkillTag]?) -> ZZAutoCreateView {
        let view = ZZAutoCreateView(parentVC: vc, infoDic: info)
        view.skillsArray = skillsArray
        let keyWindow = UIApplication.shared.keyWindow!
        view.frame = keyWindow.bounds
        keyWindow.addSubview(view)
        view.show()
        return view
    }
    
    init(parentVC: UIViewController, infoDic: ZZAutoCreateDesModel) {
        self.infoDic = infoDic
        super.init(frame: UIApplication.shared.keyWindow!.bounds)
        self.layout()
//        self.addNotifications()
    }
    
    deinit {
        print("---------im deinit----------")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func show() {
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 0.5
            self.contentView.top -= self.contentView.height
            self.isHidden = false
        }
    }
    
    @objc func hide() {
        removeNotifications()
        self.endEditing(true)
        UIView.animate(withDuration: 0.3, animations: {
            self.bgView.alpha = 0.0
            self.isHidden = true
            self.contentView.top = screenHeight
        }) { (isComplete) in
        }
    }
    
    @objc func dismiss() {
        removeNotifications()
        self.endEditing(true)
        UIView.animate(withDuration: 0.3, animations: {
            self.bgView.alpha = 0.0
            self.contentView.top = screenHeight
        }) { (isComplete) in
            self.bgView.removeFromSuperview()
            self.contentView.removeFromSuperview()
            self.removeFromSuperview()
            self.delegate?.dismissed()
        }
    }
    
    func changeText(content: inout String, placeContent: String, placedContent: String) {
        if let range = content.range(of: placeContent) {
            content.replaceSubrange(range, with: placedContent)
            changeText(content: &content, placeContent: placeContent, placedContent: placedContent)
        }
    }
    
    @objc func confirm() {
        let didHaveSkill: Bool = infoDic.didHaveSkills()
        if didHaveSkill && skillsArray == nil {
            ZZHUD.showError(withStatus: "请选择技能标签")
            return
        }
        
        if didHaveSkill, let skillArray = skillsArray {
            if skillArray.count == 0 {
                ZZHUD.showError(withStatus: "请选择技能标签")
                return
            }
        }
        
        var text = ""
        var isEmpty = false
        for (_, model) in infoDic.dimension.enumerated() {
            if model.type != 3 {
                if let content = model.inputContent, content.count != 0 {
                    
                }
                else {
                    text = "\(model.name ?? "")不可为空"
                    isEmpty = true
                    break
                }
            }
        }

        if isEmpty {
            ZZHUD.showError(withStatus: text)
            return
        }
        
        var templeateArray: [String] = []
        for (_, template) in infoDic.templateLists.enumerated() {
            var content: String = template.content!
            
            for (_, model) in infoDic.dimension.enumerated() {
                if model.type != 3 {
                    changeText(content: &content, placeContent: #"{\#(model.code!)}"#, placedContent: model.inputContent!)
                }
                else {
                    if let skillsArray = skillsArray {
                        var skillDes = ""
                        for (index, skill) in skillsArray.enumerated() {
                            skillDes += "\(String(describing: skill.name!))"
                            if index < skillsArray.count - 1 {
                                skillDes += ", "
                            }
                        }
                        changeText(content: &content, placeContent: #"{\#(model.code!)}"#, placedContent: skillDes)
                    }
                }
            }
            templeateArray.append(content)
        }
        
        
        delegate?.confirmSelection(createContents: templeateArray, skills: skillsArray)
        dismiss()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}

// MARK: Notifications
extension ZZAutoCreateView {
    func addNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(keyboardWillHide),
//                                               name: UIResponder.keyboardWillHideNotification,
//                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    func removeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let view = UIApplication.shared.keyWindow?.perform(Selector(("firstResponder"))) {
            if let info = notification.userInfo, let firstTextField = view.takeRetainedValue() as? UITextField {
                let curkeyBoardRect = info["UIKeyboardBoundsUserInfoKey"] as! CGRect
                let curkeyBoardHeight = curkeyBoardRect.size.height
                
                let beginRect = info["UIKeyboardFrameBeginUserInfoKey"] as! CGRect
                let endRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
                
                let keywindow = UIApplication.shared.keyWindow
                let newFrame = keywindow?.convert(firstTextField.superview!.frame, from: firstTextField.superview?.superview!)
                let keyBoardTop = screenHeight - curkeyBoardHeight;
                if (curkeyBoardHeight > newFrame!.size.height + newFrame!.origin.y) {
                    return;
                }
                
                /*! 第三方键盘回调三次问题，监听仅执行最后一次 */
                // pragma warning iOS 11 Will Some Problems
                if beginRect.size.height > 0 && (beginRect.origin.y - endRect.origin.y > 0) {
                    UIView.animate(withDuration: 0.25) {
                        self.top -= (newFrame!.size.height + newFrame!.origin.y) - keyBoardTop;
                    }
                }
            }
        }
    }
    
//    @objc func keyboardWillHide() {
//        UIView.animate(withDuration: 0.25) {
//            self.top -= 10//screenHeight - self.height
//        }
//    }
    
    @objc func keyboardWillChangeFrame(notification: Notification) {
//        if let view = UIApplication.shared.keyWindow?.perform(Selector(("firstResponder"))) {
//            if let info = notification.userInfo, let firstTextField = view.takeRetainedValue() as? UITextField {
//                let curkeyBoardRect = info["UIKeyboardBoundsUserInfoKey"] as! CGRect
//                let curkeyBoardHeight = curkeyBoardRect.size.height
//                let keywindow = UIApplication.shared.keyWindow
//                let newFrame = keywindow?.convert(firstTextField.superview!.frame, from: firstTextField.superview?.superview!)
//                let keyBoardTop = screenHeight - curkeyBoardHeight;
//                if (curkeyBoardHeight > newFrame!.size.height + newFrame!.origin.y) {
//                    return;
//                }
//
//                /*! 第三方键盘回调三次问题，监听仅执行最后一次 */
//                // pragma warning iOS 11 Will Some Problems
//                UIView.animate(withDuration: 0.25) {
//                    self.top -= (newFrame!.size.height + newFrame!.origin.y) - keyBoardTop;
//                }
//            }
//        }
    }
}

// MARK: ZZAutoCreateInputCellDelegate
extension ZZAutoCreateView: ZZAutoCreateInputCellDelegate {
    func didInput(content: String, demensionID: String) {
        for (_, dimensionModel) in infoDic.dimension.enumerated() {
            if dimensionModel.id == demensionID {
                dimensionModel.inputContent = content
                break;
            }
        }
    }
}

// MARK: UITableViewDelgate, UITablviewDataSource
extension ZZAutoCreateView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoDic.dimension.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let dimensionModel = infoDic.dimension?[indexPath.row] {
            if dimensionModel.type == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: ZZAutoCreateSelectCell.cellIdentifier(), for: indexPath) as! ZZAutoCreateSelectCell
                cell.configureData(model: dimensionModel, skills: skillsArray)
                cell.selectionStyle = .none
                cell.accessoryType = .disclosureIndicator
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ZZAutoCreateInputCell.cellIdentifier(), for: indexPath) as! ZZAutoCreateInputCell
                cell.configureData(model: dimensionModel)
                weak var weakSelf = self
                cell.delegate = weakSelf!
                cell.superParentView = self
                cell.superTableView = tableView
                cell.selectionStyle = .none
                return cell
            }
        }
        return tableView.dequeueReusableCell(withIdentifier: "tableviewcell", for: indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dimensionModel = infoDic.dimension?[indexPath.row] {
            if dimensionModel.type == 3 {
                JumpToSkillSelection()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}

// MARK: Navigator
extension ZZAutoCreateView {
    func JumpToSkillSelection() {
        self.hide()
        self.delegate?.showSkillsView(skills: skillsArray)
    }
}

// MARK: Layout
extension ZZAutoCreateView {
    func layout() {
        self.addSubview(bgView)
        self.addSubview(contentView)
        contentView.addSubview(cancleBtn)
        contentView.addSubview(titleLabel)
        contentView.addSubview(confirmBtn)
        contentView.addSubview(tableView)
        
        bgView.frame = self.bounds
        contentView.frame = CGRect(x: 0.0, y: screenHeight, width: screenWidth, height: 374)
        
        cancleBtn.mas_makeConstraints { (make) in
            make?.top.equalTo()(contentView)?.offset()(15)
            make?.right.equalTo()(contentView)?.offset()(-15)
            make?.size.mas_equalTo()(CGSize(width: 13, height: 13))
        }
        
        titleLabel.mas_makeConstraints { (make) in
            make?.top.equalTo()(contentView)?.offset()(45)
            make?.left.equalTo()(contentView)?.offset()(15)
            make?.right.equalTo()(contentView)?.offset()(-15)
        }
        
        confirmBtn.mas_makeConstraints { (make) in
            make?.bottom.equalTo()(contentView)?.offset()(-15)
            make?.left.equalTo()(contentView)?.offset()(15)
            make?.right.equalTo()(contentView)?.offset()(-15)
            make?.height.equalTo()(44)
        }
        
        tableView.mas_makeConstraints { (make) in
            make?.top.equalTo()(titleLabel.mas_bottom)?.offset()(26)
            make?.bottom.equalTo()(confirmBtn.mas_top)?.offset()(-20)
            make?.left.equalTo()(contentView)
            make?.right.equalTo()(contentView)
        }
    }
}

