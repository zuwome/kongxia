//
//  MapPoiManger.swift
//  kongxia
//
//  Created by qiming xiao on 2022/10/29.
//  Copyright © 2022 TimoreYu. All rights reserved.
//

import Foundation

@objc class POIManager: NSObject {
    
    static let token: String = "dc0c8a27ef710168defd4e5e0e38233c"
    static let defaultKeyword: String = "公园"
    @objc public static func getPois(keyword: String, location: CLLocationCoordinate2D, completion: @escaping ([PoiModel]) -> Void) {
        var keywords = keyword.isEmpty ? defaultKeyword : keyword
        let urlstr = "http://api.tianditu.gov.cn/v2/search?postStr={\"keyWord\":\"\(keywords)\",\"level\":12,\"pointLonlat\":\"\(location.longitude),\(location.latitude)\",\"queryType\":3,\"start\":0,\"count\":50,\"queryRadius\":5000}&type=query&tk=\(token)"
        
        guard let urlstr = urlstr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        guard let url = URL(string:urlstr) else {
            return
        }
        
        //2、创建URLRequest
        let request: URLRequest = URLRequest(url: url)
        
        //3、创建URLSession
        let configration = URLSessionConfiguration.default
        let session =  URLSession(configuration: configration)

        //4、URLSessionTask子类
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                do {
                    let result: NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                        print(result)
                    if let pois = result["pois"],
                       let poiModelArr: [PoiModel] = NSArray.yy_modelArray(with: PoiModel.self, json: pois) as? [PoiModel] {
                        DispatchQueue.main.async {
                            completion(poiModelArr)
                        }
                    }

                }catch{

                }
          }
        }
        //5、启动任务
        task.resume()
    }
    
    @objc public static func getPois(location: CLLocationCoordinate2D, completion: @escaping ([PoiModel]) -> Void) {
        getPois(keyword: defaultKeyword, location: location, completion: completion)
    }
    
}
