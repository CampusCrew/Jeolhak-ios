//
//  MapManager.swift
//  jeolhak
//
//  Created by 윤대현 on 4/5/25.
//

// MARK: - 네이버 지도를 공유하는 싱글턴 클래스

import Foundation
import CoreLocation
import NMapsMap

class MapManager: NSObject, CLLocationManagerDelegate {
    static let shared = MapManager()
    
    private let locationManager = CLLocationManager()
    private var mapView: NMFMapView? = nil

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func setMapView(_ mapView: NMFMapView) {
        self.mapView = mapView
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let latLng = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
        let cameraUpdate = NMFCameraUpdate(scrollTo: latLng)
        cameraUpdate.animation = .easeIn
        mapView?.moveCamera(cameraUpdate)
        locationManager.stopUpdatingLocation()
    }
}
