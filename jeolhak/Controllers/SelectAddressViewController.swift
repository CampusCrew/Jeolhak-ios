//
//  SelectAddressViewController.swift
//  jeolhak
//
//  Created by 윤대현 on 5/31/25.
//

import UIKit
import NMapsMap

// MARK: - 가게 주소 선택 페이지 (네이버 맵)

class SelectAddressViewController: UIViewController, NMFMapViewCameraDelegate {
    
    // MARK: - 선언
    private var selectMapView = NMFNaverMapView()
    private let bottomCardView = UIView()
    private let locationLabel = UILabel()
    private let saveButton = UIButton()
    private let centerMarker = NMFMarker()
    
    // 커스텀 "현재 위치 버튼"
    private var customLocationButton: NMFLocationButton!
    
    // MARK: - 컨트롤러 초기화
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 최초 실행
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "지도에서 주소 확인"
        self.view.backgroundColor = .white
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.mainPink,
            .font: UIFont(name: "Jua-Regular", size: 18)!
        ]
        
        self.navigationController?.navigationBar.tintColor = .mainPink
        self.navigationItem.backButtonTitle = ""
        
        self.selectMapView = NMFNaverMapView(frame: view.frame)
        // 지도 타입
        self.selectMapView.mapView.mapType = .basic
        // 커스텀 현재 위치 버튼을 연결하기 위해 기존 위치 버튼 해제
        self.selectMapView.showLocationButton = false
        // 위치 오버레이 숨기기
        self.selectMapView.mapView.locationOverlay.hidden = true
        // 지도 확대 축소
        self.selectMapView.showScaleBar = true
        
        self.selectMapView.mapView.positionMode = .disabled
        self.selectMapView.mapView.logoAlign = .rightTop
        
        // 지도 중앙점 변경 (하단에서 216 이격)
        self.selectMapView.mapView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 216, right: 0)
        view.addSubview(selectMapView)
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 37.479132, lng: 127.011770))
        selectMapView.mapView.moveCamera(cameraUpdate)
        
        centerMarker.position = selectMapView.mapView.cameraPosition.target
        centerMarker.iconImage = NMFOverlayImage(name: "selectAddressMarker")
        centerMarker.width = 35
        centerMarker.height = 42
        centerMarker.anchor = CGPoint(x: 0.5, y: 1.0)
        centerMarker.mapView = selectMapView.mapView
        
        selectMapView.mapView.addCameraDelegate(delegate: self)
        
        
        setupBottomCardView()
        // 커스텀 현재 위치 버튼 바인딩
        setupCustomLocationButton()
    }
    
    // MARK: - 현재 위치 버튼 커스텀
    private func setupCustomLocationButton() {
        // NMFLocationButton 인스턴스 생성
        customLocationButton = NMFLocationButton()
        
        // 지도뷰 연결
        customLocationButton.mapView = selectMapView.mapView
        customLocationButton.mapView?.locationOverlay.hidden = true
        
        // 부모 뷰에 추가
        view.addSubview(customLocationButton)
        
        customLocationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customLocationButton.bottomAnchor.constraint(equalTo: bottomCardView.topAnchor, constant: -15),
            customLocationButton.trailingAnchor.constraint(equalTo: bottomCardView.trailingAnchor),
            customLocationButton.widthAnchor.constraint(equalToConstant: 48),
            customLocationButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    // MARK: - 하단 카드 뷰 설정
    private func setupBottomCardView() {
        bottomCardView.backgroundColor = .white
        bottomCardView.layer.cornerRadius = 15
        bottomCardView.layer.shadowColor = UIColor.black.cgColor
        bottomCardView.layer.shadowOffset = CGSize(width: 0, height: -2)
        bottomCardView.layer.shadowOpacity = 0.1
        bottomCardView.layer.shadowRadius = 4
        
        view.addSubview(bottomCardView)
        bottomCardView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bottomCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bottomCardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            bottomCardView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        setupLocationLabel()
        setupSaveButton()
    }
    
    // MARK: - 네이버 지도 이동 추적
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        centerMarker.position = mapView.cameraPosition.target
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        centerMarker.position = mapView.cameraPosition.target
    }
    // 이동이 끝났을 때 좌표값 label Update
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        let markerCoordinate = centerMarker.position
        locationLabel.text = "위치\n위도: \(markerCoordinate.lat)\n경도: \(markerCoordinate.lng)"
    }
    
    // MARK: - 위치 라벨 설정
    private func setupLocationLabel() {
        locationLabel.text = "위치"
        locationLabel.font = UIFont(name: "Jua-Regular", size: 16)
        locationLabel.textColor = .black
        locationLabel.textAlignment = .left
        locationLabel.numberOfLines = 0
        
        bottomCardView.addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: bottomCardView.topAnchor, constant: 20),
            locationLabel.leadingAnchor.constraint(equalTo: bottomCardView.leadingAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(equalTo: bottomCardView.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - 저장 버튼 설정
    private func setupSaveButton() {
        saveButton.setTitle("저장", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = .mainPink
        saveButton.layer.cornerRadius = 8
        saveButton.titleLabel?.font = UIFont(name: "Jua-Regular", size: 16)
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        bottomCardView.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: bottomCardView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: bottomCardView.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: bottomCardView.bottomAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - 저장 버튼 액션
    @objc private func saveButtonTapped() {
        let markerCoordinate = centerMarker.position
        print("선택된 위치 - 위도: \(markerCoordinate.lat), 경도: \(markerCoordinate.lng)")
        
        navigationController?.popViewController(animated: true)
    }
}

