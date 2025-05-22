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

    // 위치 업데이트 중복 방지 플래그
    private var hasRequestedLocation = false
    
    // 위치 업데이트 콜백
    var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)?
    
    // 위치 업데이트 실패 시 fallback 콜백
    var onLocationUpdateFail: (() -> Void)?

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func setMapView(_ mapView: NMFMapView) {
        self.mapView = mapView
        
        if !hasRequestedLocation {
            hasRequestedLocation = true
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let coordinate = location.coordinate
        let latLng = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
        
        // 지도 이동
        let cameraUpdate = NMFCameraUpdate(scrollTo: latLng)
        cameraUpdate.animation = .easeIn
        mapView?.moveCamera(cameraUpdate)
        
        // 콜백 실행
        onLocationUpdate?(coordinate)
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("위치 정보 흭득 실패 : \(error.localizedDescription)")
        onLocationUpdateFail?()
    }
}
