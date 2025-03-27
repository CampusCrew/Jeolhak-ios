//
//  HomeViewController.swift
//  jeolhak
//
//  Created by 윤대현 on 3/27/25.
//

import UIKit
import NMapsMap

class HomeViewController: UIViewController {
    
    // 하단 카드뷰
    private var bottomInfoView: UIView!
    private var bottomInfoViewTopConstraint: NSLayoutConstraint!
    
    private let collapsedHeight: CGFloat = 100
    private let expandedHeight: CGFloat = 350
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        
        setupSearchBar()
        
        setupInfoView()
        
    }
    
    /** 지도 설정 함수 */
    private func setupMapView(){
        let mapView = NMFMapView(frame: view.frame)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.mapType = .basic
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: 35.9684, lng: 126.9581))
        
        mapView.moveCamera(cameraUpdate)
        
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
    
    /** 검색창 설정  */
    private func setupSearchBar() {
        // 배경 컨테이너
        let searchBarContainer = createSearchBarContainer()
        searchBarContainer.translatesAutoresizingMaskIntoConstraints = false
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
        button.tintColor = .systemPink
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    /**
     하단 카드뷰 설정
     */
    /** 하단 카드 뷰 생성 함수 */
    private func setupInfoView(){
        bottomInfoView = UIView()
        bottomInfoView.backgroundColor = .white
        bottomInfoView.layer.cornerRadius = 20
        bottomInfoView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bottomInfoView)
        
        // 카드 뷰 : 상단 회색 줄 (핸들러 설정)
        let handle = UIView()
        handle.backgroundColor = .systemGray4
        handle.layer.cornerRadius = 3
        handle.translatesAutoresizingMaskIntoConstraints = false
        bottomInfoView.addSubview(handle)
        
        NSLayoutConstraint.activate([
            handle.topAnchor.constraint(equalTo: bottomInfoView.topAnchor, constant: 8),
            handle.centerXAnchor.constraint(equalTo: bottomInfoView.centerXAnchor),
            handle.widthAnchor.constraint(equalToConstant: 40),
            handle.heightAnchor.constraint(equalToConstant: 5)
        ])
        
        // 카드뷰 제약조건
        bottomInfoViewTopConstraint = bottomInfoView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -collapsedHeight  // collapsed 상태에서도 핸들러 보이기
        )
        // 중요 : 제약조건에서 view.bottomAnchor가 아닌, safeAreaLayoutGuide로 해야함.
        // 제약조건 활성화
        bottomInfoViewTopConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            bottomInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomInfoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // 드래그 제스처 연결
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleInfoViewPan(_:)))
        bottomInfoView.addGestureRecognizer(panGesture)
    }
    
    /** 하단 카드 뷰 제스처 핸들링 */
    @objc private func handleInfoViewPan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        // 현재 위치에서 이동
        let newTopConstant = bottomInfoViewTopConstraint.constant + translation.y
        
        // 제스처 중일 때는 따라다님
        if gesture.state == .changed {
            if newTopConstant >= -expandedHeight && newTopConstant <= -collapsedHeight {
                bottomInfoViewTopConstraint.constant = newTopConstant
                gesture.setTranslation(.zero, in: view)
            }
        } else if gesture.state == .ended {
            // 빠르게 위로 올리면 확장
            let shouldExpand = velocity.y < 0
            animateBottomSheet(expand: shouldExpand)
        }
    }
    
    /** 하단 카드 뷰 애니메이션 */
    private func animateBottomSheet(expand: Bool) {
        bottomInfoViewTopConstraint.constant = expand ? -expandedHeight : -collapsedHeight
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
