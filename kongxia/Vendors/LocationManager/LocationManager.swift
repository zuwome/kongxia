//
//  LocationManager.swift
//  kongxia
//
//  Created by qiming xiao on 2022/10/29.
//  Copyright © 2022 TimoreYu. All rights reserved.
//

import Foundation
import CoreLocation

@objc class LocationManager: NSObject {
    @objc public static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @objc public var authorizationStatus: CLAuthorizationStatus {
        if #available(iOS 14, *) {
            return locationManager.authorizationStatus
        } else {
            return CLLocationManager.authorizationStatus()
        }
    }
    
    @objc public var locationServicesEnabled: Bool {
        CLLocationManager.locationServicesEnabled()
    }
    
    @objc public var isAuthorized: Bool {
        authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }
    
    @objc public var success: ((CLLocation, CLPlacemark) -> Void)?
    @objc public var failure: ((CLAuthorizationStatus, String) -> Void)?
    
    private var isUpdating: Bool = false
    override init() {
        super.init()
        defaultLocationSetting()
    }
    
    private func defaultLocationSetting() {
        locationManager.delegate = self
        locationManager.distanceFilter = 100
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func getLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func startGettingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    @objc public func getLocation(
        success: ((CLLocation, CLPlacemark) -> Void)? = nil,
        failure: ((CLAuthorizationStatus, String) -> Void)? = nil) {
            self.success = success
            self.failure = failure
            print("authorizationStatus: \(authorizationStatus)")
            
            guard !isUpdating else {
                return
            }
            
            guard !(authorizationStatus == .denied || authorizationStatus == .restricted) else {
                self.failure?(authorizationStatus, "denied")
                return
            }
            
            isUpdating = true
            
            if authorizationStatus == .notDetermined {
                getLocationAuthorization()
            } else {
                startGettingLocation()
            }
    }
}

extension LocationManager {
    func reverseLocation(location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            self.isUpdating = false
            
            guard error == nil else {
                
                return
            }
            
            guard let placemark = placemarks?.first else {
                
                return
            }
            
            self.configurePlaceMark(placemark: placemark, location: location)
        }
    }
    
    func configurePlaceMark(placemark: CLPlacemark, location: CLLocation) {
//        let location = LocationModel(placemark)
        success?(location, placemark)
    }
}

extension LocationManager: CLLocationManagerDelegate {
    // 代理方法，位置更新时回调
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationManager.stopUpdatingLocation()
        
        guard let location = locations.last else {
            isUpdating = false
            return
        }

        reverseLocation(location: location)
    }
    
    // 代理方法，当定位授权更新时回调
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse ||
            status == .authorizedAlways &&
            isUpdating {
            getLocation(success: success, failure: failure)
        }
        isUpdating = false
    }

    // 当获取定位出错时调用
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // 这里应该停止调用api
        locationManager.stopUpdatingLocation()
        
        isUpdating = false
    }
}
