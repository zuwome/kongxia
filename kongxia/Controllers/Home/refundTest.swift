//
//  refundTest.swift
//  kongxia
//
//  Created by qiming xiao on 2024/4/8.
//  Copyright © 2024 TimoreYu. All rights reserved.
//

import Foundation
import StoreKit

@objc class RefundTest:NSObject {
    @available(iOS 13.0.0, *)
    @objc static func Refund() {
        Task {
            if #available(iOS 15.0, *) {
                if let s = await UIViewController.currentDisplay().view.window?.windowScene {
                    if let dd = UserDefaults.standard.object(forKey: "refund") as? String, let id = UInt64(dd) {
                        do {
                            let status = try await Transaction.beginRefundRequest(for: id, in: s)
                            
                            print(status)
                        } catch {
                            print(error)
                        }
                    }
                    
                }
            }
        }
        
    }
}
