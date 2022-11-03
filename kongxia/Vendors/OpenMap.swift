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
    case baidu
    case apple
}

@objc class OpenMapKit: NSObject {
    
    @objc public static func showMap(name: String, latitudde: Double, longtitude: Double) {
        switch canOpenMap() {
        case .gaode:
            openGaodeMap(name: name, latitudde: latitudde, longtitude: longtitude)
        case .baidu:
            openBaiduMap(name: name, latitudde: latitudde, longtitude: longtitude)
        default:
            openAppleMap()
        }
    }
    
}

extension OpenMapKit {
    static func canOpenMap() -> MapType {
        if canOpenMap(urlString: "iosamap://") {
            return .gaode
        } else if canOpenMap(urlString: "baidumap://") {
            return .baidu
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
        
        guard let urlStrencoded = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlStrencoded) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {

        }
    }
    
    static func openBaiduMap(name: String, latitudde: Double, longtitude: Double) {
        let coordinate = CLLocationCoordinate2DMake(latitudde, longtitude)
                
                // 将高德的经纬度转为百度的经纬度
        let baiduCoordinate = LocationUtil.transformFromWGSToBaidu(location: coordinate)
        let destination = "\(baiduCoordinate.latitude),\(baiduCoordinate.longitude)"
        
        // baidumap://map/place/search?query=%E9%A4%90%E9%A6%86&location=31.204055632862,121.41117785465&radius=1000&region=上海&src=ios.baidu.openAPIdemo
//        let urlString = "baidumap://map/place/search?query=\(name)&location=\(latitudde),\(longtitude)&radius=1000&region=\()&src=kongxia"
        let urlString = "baidumap://map/show?zoom=16&center=\(latitudde),\(longtitude)&src=kongxia"
        let str = urlString as String
        
        
        guard let urlStrencoded = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlStrencoded) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {

        }
    }
    
    static func openAppleMap() {
        let location = ZZUserHelper.shareInstance().location
        let coor = CLLocationCoordinate2D(latitude: location?.coordinate.latitude ?? 0, longitude: location?.coordinate.longitude ?? 0)
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
          let placemark = MKPlacemark(coordinate: coor, addressDictionary: nil)
          let mapItem = MKMapItem(placemark: placemark)
          mapItem.name = "map" // Provide the name of the destination in the To: field
        mapItem.openInMaps(launchOptions: options)
    }
}
