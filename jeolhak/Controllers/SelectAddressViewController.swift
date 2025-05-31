//
//  SelectAddressViewController.swift
//  jeolhak
//
//  Created by 윤대현 on 5/31/25.
//

import UIKit
import NMapsMap

// MARK: - 가게 주소 선택 페이지 (네이버 맵)

class SelectAddressViewController: UIViewController, NMFMapViewCameraDelegate, CLLocationManagerDelegate {
    
    // MARK: - 위치 관리
    // 위치 매니저
    private let locationManager = CLLocationManager()
    // 중복 요청 방지
    private var hasRequestedLocation = false
    // 초기 위치 설정 중인지 확인하는 플래그
    private var isInitialLocationSetting = false
    // 현재 위치 저장
    var currentLocation: CLLocationCoordinate2D? = nil
    // 위치 업데이트 콜백
    var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)?
    var onLocationUpdateFail: (() -> Void)?
    
    // MARK: - 선택된 주소 콜백 클로저
    var onAddressSelected: ((String) -> Void)?
    
    // MARK: - 초기 로딩 상태 관리
    private var isInitialSetupComplete = false
    private var shouldUpdateAddressAfterInitialSetup = false
    
    // MARK: - Scale Bar 클릭 여부 추적용 변수
    private var isScaleBarInteraction = false
    
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
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 최초 실행
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 바 세팅
        setupNavigationBar()
        
        // 지도 세팅 (마커는 위치를 받은 후에 설정)
        setupMapView()
        
        // 하단 카드뷰
        setupBottomCardView()
        
        // 커스텀 현재 위치 확인 버튼
        setupCustomLocationButton()
        
        // 초기 라벨 텍스트 설정
        locationLabel.text = "현재 위치를 확인하는 중..."
    }
    
    // MARK: - 지도 세팅
    private func setupMapView() {
        self.selectMapView = NMFNaverMapView(frame: view.frame)
        selectMapView.mapView.mapType = .basic
        selectMapView.showLocationButton = false
        selectMapView.mapView.locationOverlay.hidden = true
        selectMapView.showScaleBar = true
        selectMapView.mapView.positionMode = .disabled
        selectMapView.mapView.logoAlign = .rightTop
        selectMapView.mapView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 176, right: 0)
        
        view.addSubview(selectMapView)
        
        selectMapView.mapView.addCameraDelegate(delegate: self)
        
        // 위치 요청 시작
        if !hasRequestedLocation {
            hasRequestedLocation = true
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - 네비게이션 바 커스텀
    private func setupNavigationBar() {
        self.title = "지도에서 주소 확인"
        self.view.backgroundColor = .white
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .white
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.mainPink,
            .font: UIFont(name: "Jua-Regular", size: 18)!
        ]
        navBarAppearance.shadowColor = UIColor.black.withAlphaComponent(0.1)
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
        navigationController?.navigationBar.tintColor = .mainPink
        
        let closeButton = UIBarButtonItem(
            image: UIImage(systemName: "arrowshape.left.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapClose)
        )
        self.navigationItem.leftBarButtonItem = closeButton
    }
    
    // MARK: - 마커 세팅 (위치를 받은 후에 호출)
    private func setupCenterMarker(at position: NMGLatLng) {
        centerMarker.position = position
        centerMarker.iconImage = NMFOverlayImage(name: "selectAddressMarker")
        centerMarker.width = 35
        centerMarker.height = 42
        centerMarker.anchor = CGPoint(x: 0.5, y: 1.0)
        centerMarker.mapView = selectMapView.mapView
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let coordinate = location.coordinate
        currentLocation = coordinate // 위치 저장
        
        let latLng = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
        
        // 초기 위치 설정 플래그 활성화
        isInitialLocationSetting = true
        
        // 지도 카메라 이동
        let cameraUpdate = NMFCameraUpdate(scrollTo: latLng)
        cameraUpdate.animation = .easeIn
        self.selectMapView.mapView.moveCamera(cameraUpdate)
        
        // 마커 설정 (처음에만)
        if !isInitialSetupComplete {
            setupCenterMarker(at: latLng)
            isInitialSetupComplete = true
            shouldUpdateAddressAfterInitialSetup = true
        } else {
            // 이미 설정된 경우 위치만 업데이트
            centerMarker.position = latLng
        }
        
        // 콜백 실행
        onLocationUpdate?(coordinate)
        
        // 위치 업데이트 중단
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("위치 정보 흭득 실패: \(error.localizedDescription)")
        locationLabel.text = "현재 위치\n\n위치 정보를 가져올 수 없습니다"
        onLocationUpdateFail?()
    }
    
    
    // MARK: - 뒤로가기 버튼
    @objc private func didTapClose() {
        presentingViewController?.presentingViewController?.dismiss(animated: true)
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
            bottomCardView.heightAnchor.constraint(equalToConstant: 160)
        ])
        
        setupLocationLabel()
        setupSaveButton()
    }
    
    // MARK: - 네이버 지도 이동 추적
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        // 초기 설정이 완료된 후에만 마커 위치 업데이트
        if isInitialSetupComplete {
            centerMarker.position = mapView.cameraPosition.target
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        // 초기 설정이 완료된 후에만 마커 위치 업데이트
        if isInitialSetupComplete {
            centerMarker.position = mapView.cameraPosition.target
        }
        
        // Scale Bar 클릭 시 reason = -2
        if reason == -2 {
            isScaleBarInteraction = true
        }
    }
    
    // MARK: - 네이버 지도 움직임 끝났을 때 좌표 -> 도로명주소 변환 (라벨 업데이트)
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        // 초기 설정이 완료되지 않았다면 API 호출하지 않음
        guard isInitialSetupComplete else { return }
        
        // Scale Bar 클릭으로 인한 변화면 API 호출하지 않음
        if isScaleBarInteraction {
            isScaleBarInteraction = false
            return
        }
        
        // 초기 위치 설정 후 첫 번째 주소 업데이트
        if shouldUpdateAddressAfterInitialSetup {
            shouldUpdateAddressAfterInitialSetup = false
            // 0.3초 딜레이를 주어 지도 안정화 후 주소 가져오기
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.updateAddressLabel()
            }
            return
        }
        
        // 이후 모든 지도 이동에 대해 주소 업데이트
        updateAddressLabel()
    }
    
    // MARK: - 주소 라벨 업데이트 메서드
    private func updateAddressLabel() {
        // 마커 위치를 다시 한번 확실히 설정
        centerMarker.position = selectMapView.mapView.cameraPosition.target
        
        let markerCoordinate = centerMarker.position
        
        // API 호출
        NetworkManager.shared.getAddressFromCoordinate(lat: markerCoordinate.lat, lng: markerCoordinate.lng) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let address):
                    print("도로명 주소: \(address)")
                    self.locationLabel.text = "현재 위치\n\n\(address)"
                case .failure(let error):
                    print("주소 변환 실패: \(error)")
                    self.locationLabel.text = "현재 위치\n\n올바른 위치가 아니에요"
                }
            }
        }
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
        saveButton.setTitle("해당 위치로 주소 등록", for: .normal)
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
        
        let currentText = locationLabel.text ?? ""
        let addressText = extractAddressFromLabelText(currentText)
        
        
        onAddressSelected?(addressText)
        
        presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
    
    // MARK: - 라벨 텍스트에서 주소 부분만 추출
    private func extractAddressFromLabelText(_ text: String) -> String {
        // "현재 위치\n\n주소" 형태에서 주소 부분만 추출
        let components = text.components(separatedBy: "\n\n")
        if components.count > 1 {
            return components[1]
        }
        return text
    }
}
