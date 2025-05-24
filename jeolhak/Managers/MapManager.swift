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
    
    // 현재 위치 저장
    var currentLocation: CLLocationCoordinate2D? = nil

    // 중복 요청 방지
    private var hasRequestedLocation = false
    
    // 위치 업데이트 콜백
    var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)?
    var onLocationUpdateFail: (() -> Void)?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    // 네이버 맵 연결 시 최초 1회 위치 요청
    func setMapView(_ mapView: NMFMapView) {
        self.mapView = mapView
        
        if !hasRequestedLocation {
            hasRequestedLocation = true
            locationManager.startUpdatingLocation()
        }
    }

    // 수동으로 현재 위치 요청
    func requestCurrentLocation() {
        locationManager.startUpdatingLocation()
    }

    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let coordinate = location.coordinate
        currentLocation = coordinate // 위치 저장
        
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
        print("위치 정보 흭득 실패: \(error.localizedDescription)")
        onLocationUpdateFail?()
    }
}
