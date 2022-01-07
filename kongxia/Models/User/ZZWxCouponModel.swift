//
//  ZZWxCouponModel.swift
//  zuwome
//
//  Created by qiming xiao on 2019/3/10.
//  Copyright © 2019 TimoreYu. All rights reserved.
//

import UIKit
import ObjectMapper

class ZZWxCouponModel: Mappable {
    var _id: String?
    var __v: Int?
    var off: UIImage?
    var created_at: String?
    var from: WXOrderUserInfoModel?
    
    init(){
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        _id      <- map["_id"]
        __v    <- map["__v"]
        off   <- map["off"]
        from <- map["from"]
        created_at   <- map["created_at"]
    }
}

