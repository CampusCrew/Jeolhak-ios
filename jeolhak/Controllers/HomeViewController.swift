//
//  HomeViewController.swift
//  jeolhak
//
//  Created by 윤대현 on 3/27/25.
//

import UIKit
// 위치 정보 관리
import CoreLocation
// 네이버 지도
import NMapsMap

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    // 위치 정보 관리자
    var locationManager = CLLocationManager()
    
    // 네이버 지도 객체
    private var mainMapView: NMFNaverMapView!
    // 지도 호출 여부 플래그
    private var isMapInitialized = false
    
    // 하단 카드뷰
    private var bottomInfoView: BottomInfoView!
    private var bottomInfoViewTopConstraintNeedsReset = true
    
    // 검색 뷰
    private var searchBarContainer: UIView!
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // expandedTopConstant가 초기값일 때만 실행
        if bottomInfoViewTopConstraintNeedsReset {
            bottomInfoView.configureExpandedTop(searchBarContainer.frame.maxY + 20)
            bottomInfoView.resetPosition()
            bottomInfoViewTopConstraintNeedsReset = false
        }
    }
    
    // 뷰 최초 실행 사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        // 위치 설정
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        // 포그라운드 감지
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        
        setupSearchBar()
        bottomInfoView = BottomInfoView(parentView: self.view)
        
        // 앱 실행 시 위치 업데이트 강제 요청
        locationManager.startUpdatingLocation()
    }
    
    // 앱이 포그라운드로 복귀했을 때 실행되는 함수
    @objc private func appWillEnterForeground(){
        print("실행")
        if mainMapView == nil {
            setupMapView()
        }
        locationManager.startUpdatingLocation()
    }
    
    // 권한 변경 감지
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager){
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("위치 권한 허용 -> 위치 업데이트 시작")
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("위치 권한 거부됨.")
            setupMapView() // 위치는 초기값으로 지정
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    // 위치 감지
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let latLng = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
        let cameraUpdate = NMFCameraUpdate(scrollTo: latLng)
        cameraUpdate.animation = .easeIn
        
        // 지도 없을 시 지도 초기 세팅
        if mainMapView == nil {
            setupMapView()
        }
        
        // 항상 현재 위치로 카메라 이동
        mainMapView?.mapView.moveCamera(cameraUpdate)
        
        // 위치 업데이트 중단
        locationManager.stopUpdatingLocation()
    }
    
    /** 지도 설정 함수 */
    private func setupMapView(){
        mainMapView = NMFNaverMapView(frame: view.frame)
        mainMapView.translatesAutoresizingMaskIntoConstraints = false
        mainMapView.mapView.mapType = .basic
        // 지도 줌 버튼 활성화
        mainMapView.showScaleBar = true
        // 현 위치 버튼 활성화
        mainMapView.showLocationButton = true
        // 위치 추적 모드 : PositionDirection 활성화
        mainMapView.mapView.positionMode = .direction
        
        // 네이버 로고 위치
        mainMapView.mapView.logoAlign = .rightBottom
        mainMapView.mapView.logoMargin = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 10)

        
        view.insertSubview(mainMapView, at: 0)
        
        // 지도 Auto Layout
        NSLayoutConstraint.activate([
            // 화면 상단에 맞추기
            mainMapView.topAnchor.constraint(equalTo: view.topAnchor),
            // 화면 좌측에 맞추기
            mainMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            // 화면 우측에 맞추기
            mainMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // 화면 하단에 맞추기
            mainMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /** 검색창 설정  */
    private func setupSearchBar() {
        // 배경 컨테이너
        let searchBarContainer = createSearchBarContainer()
        searchBarContainer.translatesAutoresizingMaskIntoConstraints = false
        self.searchBarContainer = searchBarContainer
        view.addSubview(searchBarContainer)
        
        // 검색창 배경 Auty Layout
        NSLayoutConstraint.activate([
            // 화면 상단 간격(safeArea 기준)
            searchBarContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            // 좌측 여백
            searchBarContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            // 우측 여백
            searchBarContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            // 세로 길이 고정
            searchBarContainer.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // TextField
        let textField = createTextField()
        searchBarContainer.addSubview(textField)
        
        // TextField Auto Layout
        NSLayoutConstraint.activate([
            // 메뉴 버튼 여백 설정 (좌측)
            textField.leadingAnchor.constraint(equalTo: searchBarContainer.leadingAnchor, constant: 50),
            // 검색 버튼과의 여백 설정 (우측)
            textField.trailingAnchor.constraint(equalTo: searchBarContainer.trailingAnchor, constant: -50),
            // View 세로 중앙 설정
            textField.centerYAnchor.constraint(equalTo: searchBarContainer.centerYAnchor)
        ])
        
        // Menu Button
        let menuButton = createButton(imageName: "line.horizontal.3")
        searchBarContainer.addSubview(menuButton)
        
        // Menu Button Auto Layout
        NSLayoutConstraint.activate([
            // 왼쪽 여백 설정
            menuButton.leadingAnchor.constraint(equalTo: searchBarContainer.leadingAnchor, constant: 15),
            // View 세로 중앙 설정
            menuButton.centerYAnchor.constraint(equalTo: searchBarContainer.centerYAnchor),
            // 버튼 크기 설정 30*30
            menuButton.widthAnchor.constraint(equalToConstant: 30),
            menuButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Search Button
        let searchButton = createButton(imageName: "magnifyingglass")
        searchBarContainer.addSubview(searchButton)
        
        // Search Button Auto Layout
        NSLayoutConstraint.activate([
            // 오른쪽 여백 설정
            searchButton.trailingAnchor.constraint(equalTo: searchBarContainer.trailingAnchor, constant: -15),
            // View 세로 중앙 정렬
            searchButton.centerYAnchor.constraint(equalTo: searchBarContainer.centerYAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 30),
            // 버튼 크기 설정 30*30
            searchButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        
    }
    
    /**
     UI 생성 함수 모음 : 검색창, 텍스트 필드, 버튼
     */
    /** 검색창 컨테이너 생성 */
    private func createSearchBarContainer() -> UIView {
        let searchBarContainer = UIView()
        
        // 배경, 모서리
        searchBarContainer.backgroundColor = .white
        searchBarContainer.layer.cornerRadius = 20
        // 뷰가 부모 뷰 침범 허용 (그림자 효과를 위함)
        searchBarContainer.layer.masksToBounds = false
        
        // 그림자
        searchBarContainer.layer.shadowColor = UIColor.black.cgColor
        searchBarContainer.layer.shadowOpacity = 0.2 // 0.0 ~ 1.0 사이 지정
        searchBarContainer.layer.shadowOffset = CGSize(width: 1, height: 3)
        searchBarContainer.layer.shadowRadius = 6 // 흐림 강도
        
        return searchBarContainer
    }
    
    /** 텍스트 필드 생성 */
    private func createTextField() -> UITextField {
        let textField = UITextField()
        
        textField.placeholder = "장소명"
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = .clear
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }
    
    /** 버튼 생성 */
    private func createButton(imageName: String) -> UIButton {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.tintColor = .mainPink
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
}
