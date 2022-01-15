//
//  ZZAutoCreateInputCell.swift
//  zuwome
//
//  Created by qiming xiao on 2019/5/9.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

protocol ZZAutoCreateInputCellDelegate: NSObjectProtocol {
    func didInput(content: String, demensionID: String)
}

class ZZAutoCreateInputCell: ZZTableViewCell {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.numberOfLines = 2
        label.textColor = UIColor.rgbColor(102, 102, 102)
        return label
    }()
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.boldSystemFont(ofSize: 14)
        textField.textColor = UIColor.rgbColor(63, 58, 58)
        textField.textAlignment = .left
        textField.delegate = self
        textField.returnKeyType = .done
        return textField
    }()
    
    var demensionID: String?
    weak var delegate: ZZAutoCreateInputCellDelegate?
    weak var superParentView: UIView?
    weak var superTableView: UITableView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layout()
        self.addNotifications()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureData(model: ZZAutoCreateDimensionModel) {
        titleLabel.text = model.name
        if let inputContet = model.inputContent, inputContet.count > 0 {
            inputTextField.text = inputContet
        }
        else {
            inputTextField.placeholder = "请填写你的\(model.name ?? "")"
        }
        demensionID  = model.id
    }
}

// MARK: Notifications
extension ZZAutoCreateInputCell {
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

            let keywindow = UIApplication.shared.keyWindow
            let newFrame = keywindow?.convert(self.frame, from: superTableView)
            let keyBoardTop = screenHeight - curkeyBoardHeight;
            if (curkeyBoardHeight > newFrame!.size.height + newFrame!.origin.y) {
                return;
            }

            /*! 第三方键盘回调三次问题，监听仅执行最后一次 */
            // pragma warning iOS 11 Will Some Problems
            if beginRect.size.height > 0 && (beginRect.origin.y - endRect.origin.y > 0) {
                UIView.animate(withDuration: 0.25) {
                    self.superParentView!.top -= (newFrame!.size.height + newFrame!.origin.y) - keyBoardTop;
                }
            }
        }
    }
    
    @objc func keyboardWillHide() {
        UIView.animate(withDuration: 0.25) {
            self.superParentView!.top = screenHeight - self.superParentView!.height
        }
    }
    
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


// MARK: UITextFieldDelegate
extension ZZAutoCreateInputCell: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let content = textField.text, let demensionID = demensionID {
            delegate?.didInput(content: content, demensionID: demensionID)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Layout
extension ZZAutoCreateInputCell {
    func layout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(inputTextField)
        
        titleLabel.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(self)
            make?.left.equalTo()(self)?.offset()(15)
            make?.width.equalTo()(100)
        }
        
        inputTextField.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(self)
            make?.left.equalTo()(titleLabel.mas_right)
            make?.right.equalTo()(self)?.offset()(-15)
        }
    }
}
