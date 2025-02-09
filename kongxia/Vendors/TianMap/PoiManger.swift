//
//  MapPoiManger.swift
//  kongxia
//
//  Created by qiming xiao on 2022/10/29.
//  Copyright © 2022 TimoreYu. All rights reserved.
//

import Foundation

@objc class POIManager: NSObject {
    
    private static let beasURL = "http://api.tianditu.gov.cn/v2/search"
    
    private static let token: String = "de7f361b604d6920d9a761f7ee04f87e"
    private static let defaultKeyword: String = "休闲餐饮"//"公园"
    
//    let urlstr = "http://api.tianditu.gov.cn/v2/search?postStr={\"keyWord\":\"\(keyword)\",\"level\":12,\"mapBound\":\"-180,-90,180,90\",\"queryType\":1,\"count\":100,\"start\":0,\"show\":2}&type=query&tk=\(token)"
//     http://api.tianditu.gov.cn/v2/search?postStr={"keyWord":"咖啡","queryType":12,"start":0,"count":10,"specify":"厦门"}&type=query&tk=de7f361b604d6920d9a761f7ee04f87e
//    let urlstr = "http://api.tianditu.gov.cn/v2/search?postStr={\"keyWord\":\"\(keyword)\",\"queryType\":12,\"start\":0,\"count\":100,\"specify\":\"\(city)\"}&type=query&tk=\(token)"

    @objc public static func searchPoi(keyword: String, completion: @escaping ([PoiModel]) -> Void) {
        var components = URLComponents(string: beasURL)
        components?.queryItems = [
            URLQueryItem(name: "postStr", value: "{\"keyWord\":\"\(keyword)\",\"level\":12,\"mapBound\":\"-180,-90,180,90\",\"queryType\":1,\"count\":100,\"start\":0,\"show\":2}"),
            URLQueryItem(name: "type", value: "query"),
            URLQueryItem(name: "tk", value: token)
        ]
        
        guard let url = components?.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
            
        
        // 创建 URLSession 数据任务
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            // 处理响应数据
            if let data = data {
                do {
                    let result: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    if let pois = result["pois"],
                       let poiModelArr: [PoiModel] = NSArray.yy_modelArray(with: PoiModel.self, json: pois) as? [PoiModel] {
                        DispatchQueue.main.async {
                            completion(poiModelArr)
                        }
                    } else {
                        completion([])
                    }
                } catch {
                }
            }
        }
        
        // 启动数据任务
        dataTask.resume()
    }
    
    @objc public static func searchPoiss(keyword: String, city: String, completion: @escaping ([PoiModel]) -> Void) {

        var components = URLComponents(string: beasURL)
        components?.queryItems = [
            URLQueryItem(name: "postStr", value: "{\"keyWord\":\"\(keyword)\",\"queryType\":12,\"start\":0,\"count\":100,\"specify\":\"\(city)\",\"show\":2}"),
            URLQueryItem(name: "type", value: "query"),
            URLQueryItem(name: "tk", value: token)
        ]
        
        guard let url = components?.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
            
        
        // 创建 URLSession 数据任务
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            // 处理响应数据
            if let data = data {
                do {
                    let result: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    if let pois = result["pois"],
                       let poiModelArr: [PoiModel] = NSArray.yy_modelArray(with: PoiModel.self, json: pois) as? [PoiModel] {
                        DispatchQueue.main.async {
                            completion(poiModelArr)
                        }
                    } else {
                        completion([])
                    }
                } catch {
                }
            }
        }
        
        // 启动数据任务
        dataTask.resume()
    }
    
    @objc public static func searchPoi(keyword: String, location: CLLocationCoordinate2D, completion: @escaping ([PoiModel]) -> Void) {
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
    
    @objc public static func searchPoi(location: CLLocationCoordinate2D, completion: @escaping ([PoiModel]) -> Void) {
        searchPoi(keyword: defaultKeyword, location: location, completion: completion)
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
