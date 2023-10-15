//
//  UIAlertHelper.swift
//  kongxia
//
//  Created by qiming xiao on 2023/10/14.
//  Copyright © 2023 TimoreYu. All rights reserved.
//

import Foundation

@objc class alertAction: NSObject {
    var title: String
    var style: UIAlertAction.Style
    var handler: ((UIAlertAction) -> Void)?

    required init(title: String, style: UIAlertAction.Style, handler: ( (UIAlertAction) -> Void)?) {
        self.title = title
        self.style = style
        self.handler = handler
    }
    
    @objc static func create(title: String, style: UIAlertAction.Style, handler: ( (UIAlertAction) -> Void)?) -> alertAction {
        self.init(title: title, style: style, handler: handler)
    }
}


@objc extension UIAlertController {
    
    @objc static func showAlertActions(in controller: UIViewController,
                            title: String?,
                            message: String?,
                            actions: [alertAction]) {
        let alertC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { a in
            let action = UIAlertAction(title: a.title, style: a.style, handler: a.handler)
            alertC.addAction(action)
        }
        
        controller.present(alertC, animated: true)
    }
    
    @objc static func showOkAlert(in controller: UIViewController,
                                  title: String?,
                                  message: String?,
                                  confirmTitle: String,
                                  confirmHandler: ((UIAlertAction) -> Void)?) {
        let alertC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmA = UIAlertAction(title: confirmTitle, style: .default, handler: confirmHandler)
        alertC.addAction(confirmA)
        
        controller.present(alertC, animated: true)
    }
    
    @objc static func showOkCancelAlert(in controller: UIViewController, 
                                        title: String?,
                                        message: String?,
                                        confirmTitle: String,
                                        confirmHandler: ((UIAlertAction) -> Void)?,
                                        cancelTitle: String,
                                        cancelHandler: ((UIAlertAction) -> Void)?) {
        let alertC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmA = UIAlertAction(title: confirmTitle, style: .default, handler: confirmHandler)
        let cancelA = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler)
        alertC.addAction(confirmA)
        alertC.addAction(cancelA)
        
        controller.present(alertC, animated: true)
    }
}

@objc extension UIViewController {
    
    @objc func showAlertActions(_ title: String?,
                                message: String?,
                                actions: [alertAction]) {
        UIAlertController.showAlertActions(in: self,
                                           title: title,
                                           message: message,
                                           actions: actions)
    }
    
    @objc func showOkAlert(_ title: String?,
                           message: String?,
                           confirmTitle:String,
                           confirmHandler:((UIAlertAction) -> Void)?) {
        UIAlertController.showOkAlert(in: self,
                                      title: title,
                                      message: message,
                                      confirmTitle: confirmTitle,
                                      confirmHandler: confirmHandler)
    }
    
    @objc func showOkCancelAlert(_ title: String?,
                                 message: String?,
                                 confirmTitle: String,
                                 confirmHandler: ((UIAlertAction) -> Void)?,
                                 cancelTitle: String,
                                 cancelHandler: ((UIAlertAction) -> Void)?) {
        UIAlertController.showOkCancelAlert(in: self,
                                            title: title,
                                            message: message,
                                            confirmTitle: confirmTitle,
                                            confirmHandler: confirmHandler,
                                            cancelTitle: cancelTitle,
                                            cancelHandler: cancelHandler)

    }
}

@objc extension UIAlertController {
    
    @objc static func showSheetActions(in controller: UIViewController,
                                       title: String?,
                                       message: String?,
                                       cancelTitle: String,
                                       cancelHandler: ((UIAlertAction) -> Void)?,
                                       actions: [alertAction]) {
        let alertC = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actions.forEach { a in
            let action = UIAlertAction(title: a.title, style: a.style, handler: a.handler)
            alertC.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler)
        alertC.addAction(cancelAction)
        
        controller.present(alertC, animated: true)
    }
    
    @objc static func showOkSheet(in controller: UIViewController,
                                  title: String?,
                                  message: String?,
                                  confirmTitle: String,
                                  confirmHandler: ((UIAlertAction) -> Void)?) {
        let alertC = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: confirmTitle, style: .default, handler: confirmHandler)
        alertC.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertC.addAction(cancelAction)

        controller.present(alertC, animated: true)
    }
    
    @objc static func showOkCancelSheet(in controller: UIViewController,
                                        title: String?,
                                        message: String?,
                                        confirmTitle: String,
                                        confirmHandler: ((UIAlertAction) -> Void)?,
                                        cancelTitle: String,
                                        cancelHandler: ((UIAlertAction) -> Void)?) {
        let alertC = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: confirmTitle, style: .default, handler: confirmHandler)
        alertC.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler)
        alertC.addAction(cancelAction)

        controller.present(alertC, animated: true)
    }
}

@objc extension UIViewController {
    
    @objc func showSheetActions(_ title: String?,
                                message: String?,
                                cancelTitle: String,
                                cancelHandler: ((UIAlertAction) -> Void)?,
                                actions: [alertAction]) {
        UIAlertController.showSheetActions(in: self,
                                           title: title,
                                           message: message,
                                           cancelTitle: cancelTitle,
                                           cancelHandler: cancelHandler,
                                           actions: actions)
    }

    @objc func showOkSheet(_ title: String?,
                           message: String?,
                           confirmTitle: String,
                           confirmHandler: ((UIAlertAction) -> Void)?) {
        UIAlertController.showOkSheet(in: self,
                                      title: title,
                                      message: message,
                                      confirmTitle: confirmTitle,
                                      confirmHandler: confirmHandler)
    }
    
    @objc func showOkCancelSheet(_ title: String?,
                                 message: String?,
                                 confirmTitle: String,
                                 confirmHandler: ((UIAlertAction) -> Void)?,
                                 cancelTitle: String,
                                 cancelHandler: ((UIAlertAction) -> Void)?) {
        UIAlertController.showOkCancelSheet(in: self,
                                            title: title,
                                            message: message,
                                            confirmTitle: confirmTitle,
                                            confirmHandler: confirmHandler,
                                            cancelTitle: cancelTitle,
                                            cancelHandler: cancelHandler)
    }
}


