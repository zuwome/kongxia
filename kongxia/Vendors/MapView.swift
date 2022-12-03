//
//  MapView.swift
//  kongxia
//
//  Created by qiming xiao on 2022/10/29.
//  Copyright © 2022 TimoreYu. All rights reserved.
//

import Foundation
import MapKit

@objc protocol MapViewDelegate: NSObjectProtocol {
    func regionDidChanged(coordinate: CLLocationCoordinate2D)
}

@objc class MapView: UIView {
    @objc weak var delegate: MapViewDelegate?
    
    @objc var regionDidChange: ((CLLocationCoordinate2D) -> Void)?
    
    @objc lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.delegate = self
        view.showsCompass = false
        view.showsScale = false
        return view;
    }()
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mapView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        mapView.frame = CGRect(x: 1, y: 1, width: frame.width - 2, height: frame.height - 2)
    }
}

extension MapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        regionDidChange?(mapView.centerCoordinate)
        delegate?.regionDidChanged(coordinate: mapView.centerCoordinate)
    }
}

extension MapView {
    @objc public func setCenter(_ coordinate: CLLocationCoordinate2D, animated: Bool) {
        mapView.setCenter(coordinate, animated: animated)
    }
    
    @objc public func setRegion(_ region: MKCoordinateRegion, animated: Bool) {
        let fitRegion = mapView.regionThatFits(region)
        mapView.setRegion(fitRegion, animated: animated)
    }
}
