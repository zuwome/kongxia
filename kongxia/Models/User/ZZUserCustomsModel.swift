//
//  ZZUserCustomsModel.swift
//  kongxia
//
//  Created by qiming xiao on 2020/10/6.
//  Copyright © 2020 TimoreYu. All rights reserved.
//

import UIKit
import ObjectMapper

class ZZUserCustomsModel: Mappable {
    var serviceTitle: String?
    var femaleImg: String?
    var maleImg: String?
    var content: String?
    var femaleServiceList: [String]?
    var maleServiceList: [String]?
    init(){
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        serviceTitle <- map["serviceTitle"]
        femaleImg <- map["femaleImg"]
        maleImg <- map["maleImg"]
        content <- map["content"]
        femaleServiceList <- map["femaleServiceList"]
        maleServiceList <- map["maleServiceList"]
    }
}
