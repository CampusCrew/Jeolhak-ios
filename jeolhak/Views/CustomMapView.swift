//
//  CustomMapView.swift
//  jeolhak
//
//  Created by 윤대현 on 4/5/25.
//

import UIKit
import NMapsMap

class CustomMapView: UIView {
    let customMapView: NMFNaverMapView = {
        let view = NMFNaverMapView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.mapView.mapType = .basic
        view.showLocationButton = true
        view.showScaleBar = true
        view.mapView.positionMode = .direction
        view.mapView.logoAlign = .rightBottom
        view.mapView.logoMargin = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 10)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(customMapView)
        NSLayoutConstraint.activate([
            customMapView.topAnchor.constraint(equalTo: topAnchor),
            customMapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            customMapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            customMapView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
