//
//  ZZSayHiModel.swift
//  zuwome
//
//  Created by qiming xiao on 2019/6/11.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

class ZZSayHiModelRespones: NSObject {
    @objc var showFirm: NSNumber?
    @objc var title_a: String?
    @objc var title_b: String?
    @objc var send_content: String? {
        willSet {
            if self.send_content?.count ?? 0 > 0 {
                isContentModified = !(self.send_content == newValue)
            }
            self.send_content = newValue
        }
    }
    @objc var firm_title: String?
    @objc var users: [ZZUser]? {
        didSet {
            guard let users = self.users else {
                return
            }
            var arr = [SayHiUser]()
            for (index, user) in users.enumerated() {
                let sayHiUser = SayHiUser(user: user, index: index)
                arr.append(sayHiUser)
            }
            self.sayHiUsers = arr
        }
    }
    @objc var sayHiUsers: [SayHiUser]?
    var isContentModified: Bool = false
    
    @objc class func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["users": ZZUser.classForCoder()]
    }
}

class SayHiUser: NSObject {
    let user: ZZUser
    let index: Int
    var isSelected: Bool = true
    
    init(user: ZZUser, index: Int) {
        self.user = user
        self.index = index
        super.init()
    }
}
