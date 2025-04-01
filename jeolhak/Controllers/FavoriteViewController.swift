//
//  HomeViewController.swift
//  jeolhak
//
//  Created by 윤대현 on 3/27/25.
//

import UIKit
import NMapsMap

class FavoriteViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
    }
    
    /** 지도 설정 함수 */
    private func setupMapView(){
        let mapView = NMFMapView(frame: view.frame)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.mapType = .basic
        
        view.addSubview(mapView)
        
        // 지도 Auto Layout
        NSLayoutConstraint.activate([
            // 화면 상단에 맞추기
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            // 화면 좌측에 맞추기
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            // 화면 우측에 맞추기
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // 화면 하단에 맞추기
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
