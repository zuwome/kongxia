//
//  LocationModel.swift
//  kongxia
//
//  Created by qiming xiao on 2022/10/29.
//  Copyright © 2022 TimoreYu. All rights reserved.
//

import Foundation
import CoreLocation

@objc class LocationModel: NSObject {
    
    @objc public var location: CLLocation?
     
    // address dictionary properties
    @objc public var name: String? // eg. Apple Inc.

    @objc public var thoroughfare: String? // street name, eg. Infinite Loop

    @objc public var subThoroughfare: String? // eg. 1

    @objc public var locality: String? // city, eg. Cupertino

    @objc public var subLocality: String? // neighborhood, common name, eg. Mission District

    @objc public var administrativeArea: String? // state, eg. CA

    @objc public var subAdministrativeArea: String? // county, eg. Santa Clara

    @objc public var postalCode: String? // zip code, eg. 95014

    @objc public var isoCountryCode: String? // eg. US

    @objc public var country: String? // eg. United States
    
    override init() {}
    
    init(_ placemark: CLPlacemark) {
        location = placemark.location
        name = placemark.name
        thoroughfare = placemark.thoroughfare
        subThoroughfare = placemark.subThoroughfare
        locality = placemark.locality
        subLocality = placemark.subLocality
        administrativeArea = placemark.administrativeArea
        subAdministrativeArea = placemark.subAdministrativeArea
        postalCode = placemark.postalCode
        isoCountryCode = placemark.isoCountryCode
        country = placemark.country
    }
}
