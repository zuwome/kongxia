//
//  PoiModel.swift
//  kongxia
//
//  Created by qiming xiao on 2022/10/29.
//  Copyright © 2022 TimoreYu. All rights reserved.
//

import Foundation

@objc class PoiModel: NSObject {
    @objc var address: String?
    @objc var distance: String?
    @objc var phone: String?
    @objc var poiType: String?
    @objc var name: String?
    @objc var source: String?
    @objc var hotPointID: String?
    
    @objc var lonlat: String? {
        didSet {
            if let parts = lonlat?.components(separatedBy: ","),
               parts.count == 2 {
                longitude = Double(parts.first ?? "0") ?? 0
                latitude = Double(parts.last ?? "0") ?? 0
            }
        }
    }
    
    @objc var longitude: Double = 0
    @objc var latitude: Double = 0
//    @objc class func modelContainerPropertyGenericClass() -> [String : Any]? {
//        return [
//            "result": ZZRankModel.classForCoder(),
//            "list_charisma_rank": ZZUser.classForCoder()
//        ]
//    }
}
