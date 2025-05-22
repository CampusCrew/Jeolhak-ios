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
    
    // 하단 카드뷰
    private var bottomCardView: BottomCardView!
    private var bottomInfoViewTopConstraintNeedsReset = true
    
    // 검색 뷰
    private var searchBarContainer: UIView!
    
    // 지도 뷰
    private var mapContainerView: CustomMapView!
    
    // 마커 클러스터
    private var clusterer : NMCClusterer<StoreKey>?
    
    // 사용자 데이터
    private var department: String = ""
    private var major: String = ""
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 카드 최대 높이가 초기값일 때만 실행
        if bottomInfoViewTopConstraintNeedsReset {
            bottomCardView.setMaxCardHight(searchBarContainer.frame.maxY + 20)
            bottomCardView.closeCardView()
            bottomInfoViewTopConstraintNeedsReset = false
        }
    }
    
    // 다른 탭으로 이동할 때
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        bottomCardView.closeCardView()
        bottomCardView.resetBackgroundColor()
    }
    
    // 뷰 최초 실행 사이클
    override func viewDidLoad() {
        super.viewDidLoad()
        
        department = UserDefaults.standard.string(forKey: "department") ?? "없음"
        major = UserDefaults.standard.string(forKey: "major") ?? "없음"
        
        print("사용자 단과대 : ", department)
        print("사용자 학과 : ", major)
        
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
        
        // 위치 콜백
        setLocationCallback()
   
        // 지도 출력
        MapManager.shared.setMapView(mapContainerView.customMapView.mapView)
        
        // 검색바 출력
        setupSearchBar()
        
        // 하단 카드뷰 출력
        bottomCardView = BottomCardView(parentView: self.view, height: 120, isHomeViewCheck: true)
    }
    
    /** 사용자 위치 근방 할인 가게 호출 */
    private func fetchStores(latitude: Double,
                             longitude: Double,
                             _ department: String?,
                             _ major: String?,
                             _ mapContainerView: CustomMapView){
        // 쿼리 스트링용 단과대학 변수
        let payloadDepartment: String
        // 쿼리 스트링용 학과 변수
        let payloadMajor: String
        
        if let dept = department, let maj = major {
                if dept == "''" && maj == "''" {
                    payloadDepartment = "''"
                    payloadMajor = "''"
                } else {
                    payloadDepartment = dept
                    payloadMajor = maj
                }
            } else if let dept = department {
                payloadDepartment = dept
                payloadMajor = ""
            } else if let maj = major {
                payloadDepartment = ""
                payloadMajor = maj
            } else {
                payloadDepartment = "''"
                payloadMajor = "''"
            }
        
        let parameters: [String: Any] = [
                "lat": latitude,
                "lng": longitude,
                "department": payloadDepartment,
                "major": payloadMajor
            ]
        
        NetworkManager.shared.requestGET(urlString: APIConstants.getStores, parameters: parameters) {
            (result: Result<StoreResponse, APIError>) in
            switch result{
            case .success(let storeResponse):
                print("받아온 가게의 수 : ", storeResponse.data.count)
                self.displaySetMarker(storeResponse.data, mapContainerView)
            case .failure(let error):
                print("오류 발생", error)
                print(APIConstants.getStores)
            }
        }
    }
    
    /** 현재 위치 기준 마커 요청 */
    private func displaySetMarker(_ stores: [Store], _ mapContainerView: CustomMapView) {
        let builder = NMCBuilder<StoreKey>()
        builder.minZoom = 9
        builder.maxZoom = 16
        // builder.animate = false

        let leafMarkerUpdater = LeafMarkerUpdater()
        leafMarkerUpdater.stores = stores
        builder.leafMarkerUpdater = leafMarkerUpdater

        clusterer = builder.build()
        clusterer?.mapView = mapContainerView.customMapView.mapView

        var keyTagMap: [StoreKey: NSNull] = [:]
        for (index, store) in stores.enumerated() {
            let key = StoreKey(identifier: index, position: NMGLatLng(lat: store.lat, lng: store.lng))
            keyTagMap[key] = NSNull()
        }

        clusterer?.clear()
        clusterer?.addAll(keyTagMap)
    }
    
    // 위치 콜백 정의
    private func setLocationCallback() {
        // 위치 호출 콜백
        MapManager.shared.onLocationUpdate = { [weak self] coordinate in
            guard let self = self else { return }
            // 학교에서 작업하고 있으므로 임의적으로 다사랑으로 지정
            self.fetchStores(latitude: 35.960804, longitude: 126.957785,department,major, mapContainerView)
//            self.fetchStores(latitude: coordinate.latitude,
//                             longitude: coordinate.longitude,
//                             department,
//                             major,
//                             mapContainerView)
        }
        
        // 위치 호출 실패 시 익산 신동 다사랑 좌표 사용
        MapManager.shared.onLocationUpdateFail = { [weak self] in
                guard let self = self else { return }
                let fallbackLat = 35.960804
                let fallbackLng = 126.957785
                self.fetchStores(latitude: fallbackLat,
                                 longitude: fallbackLng,
                                 department,
                                 major,
                                 mapContainerView)
            }
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
