//
//  UserPrivateTermsHelper.swift
//  kongxia
//
//  Created by qiming xiao on 2020/10/5.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

import Foundation

class UserPrivateTermsHelper: NSObject {
    
    @objc static let shared = UserPrivateTermsHelper()
    var isValidate: Bool {
        get {
            if let userPrivateTermsVersion = UserDefaults.standard.object(forKey: "UserPrivateTermsVersion") as? String,
               let version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
               userPrivateTermsVersion == version  {
                return true
            }
            return false
        }
    }
    
    static func setupValidate() {
        UserDefaults.standard.setValue((Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "", forKey: "UserPrivateTermsVersion")
    }
    
    @objc func validate(controller: UIViewController) -> Bool {
        if isValidate {
            return false
        }
        showUserPrivateTerms(controller: controller)
        return true
    }
    
    func showUserPrivateTerms(controller: UIViewController) {
        let userPrivateTermsController = UserPrivateTermsController()
        userPrivateTermsController.delegate = self
        let navi = UINavigationController(rootViewController: userPrivateTermsController)
        if #available(iOS 13.0, *) {
            navi.isModalInPresentation = true
        }
        navi.modalPresentationStyle = .overCurrentContext
        ZZTabBarViewController.sharedInstance()?.present(navi, animated: true, completion: nil)
    }
    
    func showUserProtocol(controller: UIViewController) {
        let protocolController = ZZProtocolViewController()
        protocolController.hidesBottomBarWhenPushed = true
        let nav = ZZNavigationController(rootViewController: protocolController)
        controller.present(nav, animated: true, completion: nil)
    }
    
    func showPrivacyTerms(controller: UIViewController) {
        let webController = ZZLinkWebViewController()
        webController.urlString = H5Url.privacyProtocol;
        webController.navigationItem.title = "空虾隐私权政策"
        webController.hidesBottomBarWhenPushed = true
        
        let nav = ZZNavigationController(rootViewController: webController)
        controller.present(nav, animated: true, completion: nil)
    }
    
    func abortApp() {
//        UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
        exit(0)
    }
}

extension UserPrivateTermsHelper: UserPrivateTermsControllerDelegate {
    func agreedAction(viewController: UIViewController) {
        UserPrivateTermsHelper.setupValidate()
        viewController.dismiss(animated: false, completion: nil)
    }
    
    func disagreedAction(viewController: UIViewController) {
        abortApp()
    }
    
    func showUserProtocol(viewController: UIViewController) {
        showUserProtocol(controller: viewController)
    }
    
    func showPrivacyTerms(viewController: UIViewController) {
        showPrivacyTerms(controller: viewController)
    }
}
