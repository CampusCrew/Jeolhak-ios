//
//  HomeViewController.swift
//  jeolhak
//
//  Created by 윤대현 on 3/27/25.
//

import UIKit
import NMapsMap

class FavoriteViewController: UIViewController {
    
    // 하단 카드뷰
    private var bottomCardView: BottomCardView!
    private var bottomInfoViewTopConstraintNeedsReset = true
    
    // 지도 뷰
    private var mapContainerView: CustomMapView!
    
    // 다른 뷰 이동
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if bottomInfoViewTopConstraintNeedsReset {
            bottomCardView.setMaxCardHight(100)
            bottomCardView.closeCardView()
            bottomInfoViewTopConstraintNeedsReset = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bottomCardView.closeCardView()
        bottomCardView.resetBackgroundColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 지도 초기화
        mapContainerView = CustomMapView()
        mapContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapContainerView)
        
        NSLayoutConstraint.activate([
            mapContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            mapContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        MapManager.shared.setMapView(mapContainerView.customMapView.mapView)
        bottomCardView = BottomCardView(parentView: self.view, height: 300, isHomeViewCheck: false)
    }
}
