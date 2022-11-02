//
//  OpenMap.swift
//  kongxia
//
//  Created by qiming xiao on 2022/11/2.
//  Copyright © 2022 TimoreYu. All rights reserved.
//

import Foundation

enum MapType {
    case gaode
    case apple
}

@objc class OpenMapKit: NSObject {
    
    @objc public static func showMap(name: String, latitudde: Double, longtitude: Double) {
        switch canOpenMap() {
        case .gaode:
            openGaodeMap(name: name, latitudde: latitudde, longtitude: longtitude)
        default:
            openAppleMap()
        }
    }
    
}

extension OpenMapKit {
    static func canOpenMap() -> MapType {
        if canOpenMap(urlString: "iosamap://") {
            return .gaode
        } else {
            return .apple
        }
    }
    
    static func canOpenMap(urlString: String) -> Bool {
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            return true
        }
        return false
    }
}

@objc extension OpenMapKit {
    static func openGaodeMap(name: String, latitudde: Double, longtitude: Double) {
        let urlStr = "iosamap://viewMap?sourceApplication=kongixa&poiname=\(name)&lat=\(latitudde)&lon=\(longtitude)&dev=0"
        
        guard let urlSs = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlSs) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {

        }
    }
    
    static func openAppleMap() {
//        let urlStr = 
    }
}
