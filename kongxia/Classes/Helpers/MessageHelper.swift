//
//  MessageHelper.swift
//  kongxia
//
//  Created by qiming xiao on 2023/1/12.
//  Copyright © 2023 TimoreYu. All rights reserved.
//

import Foundation

@objc class MessageHelper: NSObject {
    
    static func SendMessage(message: String, to targetIds: [String], pushContent: String, pushData: String, completeHandler: @escaping () -> Void) {
        
        
        let queue = DispatchQueue(label: "com.flion.dispatchgroup", attributes: .concurrent)
        let group = DispatchGroup()
        
        targetIds.forEach { targetId in
            queue.async(group: group) {
                _ = SendMessage(message: message, to: targetId, pushContent: "收到一条新的信息", pushData: pushContent )
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            completeHandler()
        }
        
    }
    
    static func SendMessage(message: String, to targetId: String, pushContent: String, pushData: String) -> RCMessage? {
        let messageContent = RCTextMessage(content: message)
        
        let rcmessage = RCIMClient.shared().sendMessage(RCConversationType.ConversationType_PRIVATE, targetId: targetId, content: messageContent, pushContent: pushContent, pushData: pushContent) { _ in
            
        }
        
        return rcmessage
    }
    
}
