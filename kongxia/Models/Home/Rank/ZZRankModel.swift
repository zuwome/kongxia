//
//  ZZRankModel.swift
//  zuwome
//
//  Created by qiming xiao on 2019/5/24.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit

class ZZRankResponeModel: NSObject {
    @objc var title_one: String?
    @objc var title_two: String?
    @objc var rankWgShow: Bool = true // 4.0.0之前是控制显示土豪榜、4.0.0之后是控制显示点唱Party的
    @objc var result: [ZZRankModel]?
    @objc var pdSongTip: NSDictionary?

    @objc var charisma_show: Bool = true
    @objc var charisma_title: String?
    @objc var charisma_b: String?
    @objc var list_charisma_rank: [ZZUser]?
    @objc class func modelContainerPropertyGenericClass() -> [String : Any]? {
        return [
            "result": ZZRankModel.classForCoder(),
            "list_charisma_rank": ZZUser.classForCoder()
        ]
    }
}

class ZZMyRankDetailsResponeModel: NSObject {
    @objc var text: ZZMyRankingDetailsTextModel?
    @objc var result: [ZZRankModel]?
    
    @objc class func modelContainerPropertyGenericClass() -> [String : Any]? {
        return [
            "result": ZZRankModel.classForCoder(),
            "text": ZZMyRankingDetailsTextModel.classForCoder()
        ]
    }
}

class ZZRankModel: NSObject {
    @objc var aggregate: AggregateModel?
    @objc var userInfo: ZZUser?
    @objc var follow_status: String?
    @objc var ranking: String?
    
    // -1:显示 
    @objc var rank_show: NSNumber?
    
    // 1: 上升 0:不变 -1:下降
    @objc var is_up: NSNumber?
    @objc class func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["aggregate": AggregateModel.classForCoder(), "from": ZZUser.classForCoder()]
    }
    
    var nameWidth: CGFloat = -1.0
    
}

class AggregateModel: NSObject {
    @objc var _id: String?
    @objc var totalPrice: String?
    @objc var totalDay: String?
}

class ZZMyRankingDetailsTextModel: NSObject {
    @objc var title: String?
    @objc var text_arr: [String]?
}



