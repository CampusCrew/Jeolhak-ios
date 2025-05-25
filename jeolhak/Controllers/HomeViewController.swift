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
    
    // 사용자 데이터 표시
    private var departmentView: HomeSelectedUserInfoView!
    private var majorView: HomeSelectedUserInfoView!
    
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
        
        // 단과대학, 학과 변경
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshAfterChange),
            name: .didUpdateUserSelection,
            object: nil
        )
        
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
        
        // 검색, 단과/학과 정보 출력
        setupSearchBarAndUserInfo()
        
        // 하단 카드뷰 출력
        bottomCardView = BottomCardView(parentView: self.view, height: 120, isHomeViewCheck: true)
    }
    
    @objc private func refreshAfterChange() {
        department = UserDefaults.standard.string(forKey: "department") ?? "없음"
        major = UserDefaults.standard.string(forKey: "major") ?? "없음"
        
        print("변경된 단과대학 : ", department)
        print("변경된 학과 : ", major)
        
        // View 업데이트
        departmentView.update(content: department)
        majorView.update(content: major)
        
        // 현재 위치 기반 API 요청 다시 진행 (변경된 단과, 학과 정보)
        if let currentLocation = MapManager.shared.currentLocation {
            print("현재 위치 기반 단과, 학과 업데이트")
            fetchStores(latitude: 35.960804, // 테스트로 다사랑에서 확인하기
                        longitude: 126.957785,
                        department,
                        major,
                        mapContainerView)
            //            fetchStores(latitude: currentLocation.latitude,
            //                        longitude: currentLocation.longitude,
            //                        department,
            //                        major,
            //                        mapContainerView)
        } else {
            print("현재 위치 불러오기 실패. 다사랑 기준 단과, 학과 업데이트")
            fetchStores(latitude: 35.960804,
                        longitude: 126.957785,
                        department,
                        major,
                        mapContainerView)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
                print("받아온 가게 정보 : ", storeResponse.data)
                self.displaySetMarker(storeResponse.data, mapContainerView)
                self.bottomCardView.updateStores(storeResponse.data)
                print("✅ bottomCardView 상태: \(String(describing: self.bottomCardView))")
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
        builder.maxZoom = 14
        // builder.animate = false
        
        let leafMarkerUpdater = LeafMarkerUpdater()
        leafMarkerUpdater.stores = stores
        builder.leafMarkerUpdater = leafMarkerUpdater
        
        // 새로운 클러스터 생성
        let newClusterer = builder.build()
        newClusterer.mapView = mapContainerView.customMapView.mapView
        
        // 기존 클러스터 제거
        clusterer?.clear()
        clusterer = newClusterer
        
        var keyTagMap: [StoreKey: NSNull] = [:]
        for (index, store) in stores.enumerated() {
            let key = StoreKey(identifier: index, position: NMGLatLng(lat: store.lat, lng: store.lng))
            keyTagMap[key] = NSNull()
        }
        
        clusterer?.addAll(keyTagMap)
    }
    
    // 위치 콜백 정의 (현재 위치 기반, 모달 모드가 init일 때 실행)
    private func setLocationCallback() {
        // 위치 호출 콜백
        MapManager.shared.onLocationUpdate = { [weak self] coordinate in
            guard let self = self else { return }
            // 학교에서 작업하고 있으므로 임의적으로 다사랑으로 지정
            self.fetchStores(latitude: 35.960804,
                             longitude: 126.957785,
                             department,
                             major,
                             mapContainerView)
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
    
    // 선택된 단과대학, 학과 표시
    private func setupSearchBarAndUserInfo() {
        let infoStackView = UIView()
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(infoStackView)
        
        departmentView = HomeSelectedUserInfoView(content: department)
        departmentView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.addSubview(departmentView)
        
        majorView = HomeSelectedUserInfoView(content: major)
        majorView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.addSubview(majorView)
        
        let searchBarView = HomeSearchBarView()
        self.searchBarContainer = searchBarView
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBarView)
        
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -10),
            infoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // departmentView (왼쪽)
            departmentView.topAnchor.constraint(equalTo: infoStackView.topAnchor),
            departmentView.bottomAnchor.constraint(equalTo: infoStackView.bottomAnchor),
            departmentView.leadingAnchor.constraint(equalTo: infoStackView.leadingAnchor),
            
            // majorView (오른쪽)
            majorView.topAnchor.constraint(equalTo: infoStackView.topAnchor),
            majorView.bottomAnchor.constraint(equalTo: infoStackView.bottomAnchor),
            majorView.leadingAnchor.constraint(equalTo: departmentView.trailingAnchor, constant: 20),
            majorView.trailingAnchor.constraint(equalTo: infoStackView.trailingAnchor),
            
            searchBarView.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 10),
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            searchBarView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
