//
//  MapPoiManger.swift
//  kongxia
//
//  Created by qiming xiao on 2022/10/29.
//  Copyright © 2022 TimoreYu. All rights reserved.
//

import Foundation

@objc class POIManager: NSObject {
    
    static let token: String = "de7f361b604d6920d9a761f7ee04f87e"
    static let defaultKeyword: String = "休闲餐饮"//"公园"
    @objc public static func getPoisss(keyword: String, location: CLLocationCoordinate2D, completion: @escaping ([PoiModel]) -> Void) {
        let keywords = keyword.isEmpty ? defaultKeyword : keyword
        let urlstr = "http://api.tianditu.gov.cn/v2/search?postStr={\"keyWord\":\"\(keywords)\",\"level\":12,\"pointLonlat\":\"\(location.longitude),\(location.latitude)\",\"queryType\":3,\"start\":0,\"count\":50,\"queryRadius\":10000}&type=query&tk=\(token)"
        
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
    
    @objc public static func getPoisss(location: CLLocationCoordinate2D, completion: @escaping ([PoiModel]) -> Void) {
        getPoisss(keyword: defaultKeyword, location: location, completion: completion)
    }
    
    @objc public static let shared = POIManager()
    
    private let search: AMapSearchAPI
    
    override init() {
        search = AMapSearchAPI()
        
        super.init()
        
        search.delegate = self
    }
    
    typealias CompleteHandler = (_ pois: [PoiModel])->Void;
    var handler: CompleteHandler?
    
    @objc public func getGDPoi(keyword: String, city: String, cityLimited: Bool, completion: @escaping CompleteHandler) {
        if keyword.isEmpty {
            return
        }
        
        handler = completion
        
        let request = AMapPOIKeywordsSearchRequest()
        request.keywords = keyword
        request.types = "餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施"
        request.city = city
        request.cityLimit = cityLimited
        request.requireExtension = true

        search.aMapPOIKeywordsSearch(request)
    }
    
    @objc public func getGDPoi(coordinate: CLLocationCoordinate2D, completion: @escaping CompleteHandler) {
        handler = completion
        
        let request = AMapPOIAroundSearchRequest()

        request.location = AMapGeoPoint.location(withLatitude: coordinate.latitude, longitude: coordinate.longitude)
        request.sortrule = 0;
        request.requireExtension = true
        
        search.aMapPOIAroundSearch(request)
    }
    
}

extension POIManager: AMapSearchDelegate {
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        
        if response.count == 0 {
            return
        }
        
        //解析response获取POI信息，具体解析见 Demo
        
        let pois: [PoiModel] = response.pois.compactMap {
            let poi = PoiModel()
            poi.longitude = $0.location.longitude
            poi.latitude = $0.location.latitude
            poi.address = $0.address
            poi.name = $0.name
            
            return poi
        }
        
        handler?(pois)
    }
}

