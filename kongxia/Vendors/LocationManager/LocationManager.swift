//
//  LocationManager.swift
//  GeoManager
//
//  Created by qiming xiao on 2022/11/3.
//

import Foundation
import CoreLocation

@objc class LocationMangers: NSObject {
    
    @objc public static let shared = LocationMangers()
    
    @objc public var getAuthHandler: ((_ success: Bool) -> Void)?
    @objc public var getLocationHandler: ((_ location: CLLocation, _ error: Error?) -> Void)?
    @objc public var getPlacemarkHandler: ((_ placemark: CLPlacemark?, _ error: Error?) -> Void)?
    
    @objc public var hasLocationService: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    @objc public var authorizationStatus: CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            let status: CLAuthorizationStatus = locationManager.authorizationStatus
            print("location authorizationStatus is \(status.rawValue)")
            return status
        } else {
            let status = CLLocationManager.authorizationStatus()
            print("location authorizationStatus is \(status.rawValue)")
            return status
        }
    }
    
    @objc public var hasPermission: Bool {
        switch authorizationStatus {
        case .notDetermined, .restricted, .denied:
            return false
        case .authorizedWhenInUse, .authorizedAlways:
            return true
        default:
            break
        }
        return false
    }
    
    
    private var locationManager: CLLocationManager!
    private var geocoder: CLGeocoder!
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        geocoder = CLGeocoder()
    }
    
    @objc func requestLocationAuthorizaiton(handler: @escaping ((_ success: Bool) -> Void)) {
        self.getAuthHandler = handler
        locationManager.requestWhenInUseAuthorization()
    }
    
    @objc func requestLocation() {
        locationManager.requestLocation()
    }
    
    @objc func requestLocation(_ handler: @escaping (_ location: CLLocation, _ error: Error?) -> Void) {
        getLocationHandler = handler
        locationManager.requestLocation()
    }
    
    @objc func requestPlacemark(_ handler: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> Void) {
        getPlacemarkHandler = handler
        locationManager.requestLocation()
    }
}

extension LocationMangers {
    func reverseLocation(location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [unowned self] placemarks, error in

            guard error == nil, let placemark = placemarks?.first else {
                return
            }
            
            self.getPlacemarkHandler?(placemark, nil)
        }
    }
}

extension LocationMangers: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        handleChangeAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleChangeAuthorization()
    }
    
    private func handleChangeAuthorization() {
        guard authorizationStatus != .denied else {
            return
        }
        
        getAuthHandler?(hasPermission ? true : false)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        handleDidUpdateLocations(locations: locations)
        manager.stopUpdatingHeading()
    }
    
    private func handleDidUpdateLocations(locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
//        print("latitude: \(location.coordinate.latitude) longitude:\(location.coordinate.longitude)")
        
//        getLocationHandler?(location)
        reverseLocation(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        getPlacemarkHandler?(nil, error)
    }
}
