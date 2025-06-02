//
//  StoreDetailView.swift
//  jeolhak
//
//  Created by 윤대현 on 5/28/25.
//

import UIKit
import Kingfisher

// MARK: - 가게 상세 페이지 구성 뷰

class StoreDetailView: UIView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let shopImage = UIImageView()
    private let shopName = UILabel()
    private let shopCategory = PaddingLabel()
    private let locationIcon = UIImageView()
    private let shopAddress = UILabel()
    
    private let divider = UIView()
    
    private let saleInfoTitle = UILabel()
    private let saleInfoIcon = UIImageView()
    private let saleInfo = UILabel()
    private let saleDateTitle = UILabel()
    private let saleDateIcon = UIImageView()
    private let saleDate = UILabel()
    private let targetTitle = UILabel()
    private let shopDepartmentIcon = UIImageView()
    private let shopDepartment = UILabel()
    private let shopMajor = UILabel()
    private let etcTitle = UILabel()
    private let etcIcon = UIImageView()
    private let etc = UILabel()
    
    private let mapButton = UIButton()
    
    private let store: Store
    
    init(store: Store) {
        self.store = store
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        setupSubviews(store: store)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews(store: Store) {
        // 스크롤뷰 설정
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        
        // 컨텐츠 뷰 설정
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // 이미지
        shopImage.kf.indicatorType = .activity
        shopImage.kf.setImage(with: URL(string: store.imageURL), options: [.transition(.fade(0.5)), .processor(RoundCornerImageProcessor(cornerRadius: 20))])
        shopImage.contentMode = .scaleAspectFill
        shopImage.clipsToBounds = true
        shopImage.translatesAutoresizingMaskIntoConstraints = false
        
        // 텍스트 설정
        shopName.text = store.name
        shopName.font = UIFont(name: "Jua-Regular", size: 18)
        shopName.textColor = .mainPink
        
        shopCategory.text = store.category
        shopCategory.font = UIFont(name: "Jua-Regular", size: 13)
        shopCategory.textColor = .mainPink
        shopCategory.backgroundColor = UIColor.mainPink.withAlphaComponent(0.1)
        shopCategory.padding = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        shopCategory.textAlignment = .center
        shopCategory.layer.cornerRadius = 10
        shopCategory.layer.masksToBounds = true
        
        locationIcon.image = UIImage(systemName: "location.fill")
        locationIcon.tintColor = .darkGray
        
        shopAddress.text = store.address
        shopAddress.font = UIFont(name: "Jua-Regular", size: 14)
        shopAddress.textColor = .darkGray
        
        divider.backgroundColor = .mainPink
        divider.layer.cornerRadius = 2
        
        saleInfoTitle.text = "할인 정보"
        saleInfoTitle.font = UIFont(name: "Jua-Regular", size:18)
        saleInfoTitle.textColor = .mainPink
        
        saleInfoIcon.image = UIImage(systemName: "banknote")
        saleInfoIcon.tintColor = .darkGray
        
        saleInfo.text = store.saleInfo
        saleInfo.font = UIFont(name: "Jua-Regular", size: 16)
        saleInfo.textColor = .darkGray
        saleInfo.numberOfLines = 0
        
        saleDateTitle.text = "할인 기간"
        saleDateTitle.font = UIFont(name: "Jua-Regular", size: 18)
        saleDateTitle.textColor = .mainPink
        
        saleDateIcon.image = UIImage(systemName: "calendar")
        saleDateIcon.tintColor = .darkGray
        
        // 날짜 형식 변환 유틸리티
        let formatted = DateFormatterUtils.formatSaleDate(store.saleDate)
        saleDate.text = formatted
        saleDate.font = UIFont(name: "Jua-Regular", size: 16)
        saleDate.textColor = .darkGray
        
        targetTitle.text = "할인 대상"
        targetTitle.font = UIFont(name: "Jua-Regular", size: 18)
        targetTitle.textColor = .mainPink
        
        shopDepartmentIcon.image = UIImage(systemName: "graduationcap")
        shopDepartmentIcon.tintColor = .darkGray
        
        shopDepartment.text = store.department
        shopDepartment.font = UIFont(name: "Jua-Regular", size: 16)
        shopDepartment.textColor = .darkGray
        
        shopMajor.text = store.major == "" ? " 전체학생" : store.major.trimmingCharacters(in: .whitespacesAndNewlines)
        shopMajor.font = UIFont(name: "Jua-Regular", size: 16)
        shopMajor.textColor = .darkGray
        
        print("shopDepartment.text : ", store.department)
        print("shopMajor.text : ", store.major)
        
        etcTitle.text = "설명(기타)"
        etcTitle.font = UIFont(name: "Jua-Regular", size: 18)
        etcTitle.textColor = .mainPink
        
        etcIcon.image = UIImage(systemName: "list.clipboard")
        etcIcon.tintColor = .darkGray
        
        etc.text = store.etc
        etc.font = UIFont(name: "Jua-Regular", size: 16)
        etc.textColor = .darkGray
        etc.numberOfLines = 0
        
        // 지도 버튼 설정 (고정 위치)
        mapButton.setTitle("네이버 지도에서 보기", for: .normal)
        mapButton.setTitleColor(.white, for: .normal)
        mapButton.backgroundColor = .mainPink
        mapButton.titleLabel?.font = UIFont(name: "Jua-Regular", size: 18)
        mapButton.layer.cornerRadius = 10
        mapButton.translatesAutoresizingMaskIntoConstraints = false
        mapButton.addTarget(self, action: #selector(openInNaverMap), for: .touchUpInside)
        addSubview(mapButton) // 스크롤뷰가 아닌 메인 뷰에 추가
        
        // 이미지도 메인 뷰에 고정
        addSubview(shopImage)
        
        // 스크롤 가능한 요소들을 contentView에 추가
        [shopName, shopCategory, locationIcon, shopAddress, divider,
         saleInfoTitle, saleInfoIcon, saleInfo,
         saleDateTitle, saleDateIcon, saleDate,
         targetTitle, shopDepartmentIcon, shopDepartment, shopMajor,
         etcTitle, etcIcon, etc].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // 이미지 제약조건 (상단 고정 - 타이틀바 여백 추가)
            shopImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            shopImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            shopImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            shopImage.heightAnchor.constraint(equalToConstant: 220),
            
            // 스크롤뷰 제약조건 (이미지 아래부터 시작)
            scrollView.topAnchor.constraint(equalTo: shopImage.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: mapButton.topAnchor, constant: -16),
            
            // 컨텐츠뷰 제약조건
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // 지도 버튼 제약조건 (하단 고정 - 탭바 여백 추가)
            mapButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mapButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mapButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            mapButton.heightAnchor.constraint(equalToConstant: 44),
            
            // 스크롤 가능한 컨텐츠 제약조건 (shopName부터 시작)
            shopName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            shopName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            shopCategory.centerYAnchor.constraint(equalTo: shopName.centerYAnchor),
            shopCategory.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            shopAddress.topAnchor.constraint(equalTo: shopName.bottomAnchor, constant: 15),
            locationIcon.centerYAnchor.constraint(equalTo: shopAddress.centerYAnchor),
            locationIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            locationIcon.widthAnchor.constraint(equalToConstant: 16),
            locationIcon.heightAnchor.constraint(equalToConstant: 17),
            shopAddress.leadingAnchor.constraint(equalTo: locationIcon.trailingAnchor, constant: 5),
            shopAddress.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            divider.topAnchor.constraint(equalTo: shopAddress.bottomAnchor, constant: 10),
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            divider.heightAnchor.constraint(equalToConstant: 2),
            
            saleInfoTitle.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 15),
            saleInfoTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            saleInfoIcon.centerYAnchor.constraint(equalTo: saleInfo.centerYAnchor),
            saleInfoIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            saleInfoIcon.widthAnchor.constraint(equalToConstant: 16),
            saleInfoIcon.heightAnchor.constraint(equalToConstant: 17),
            saleInfo.topAnchor.constraint(equalTo: saleInfoTitle.bottomAnchor, constant: 10),
            saleInfo.leadingAnchor.constraint(equalTo: saleInfoIcon.trailingAnchor, constant: 10),
            saleInfo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            saleDateTitle.topAnchor.constraint(equalTo: saleInfo.bottomAnchor, constant: 15),
            saleDateTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            saleDateIcon.centerYAnchor.constraint(equalTo: saleDate.centerYAnchor),
            saleDateIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            saleDateIcon.widthAnchor.constraint(equalToConstant: 16),
            saleDateIcon.heightAnchor.constraint(equalToConstant: 17),
            saleDate.topAnchor.constraint(equalTo: saleDateTitle.bottomAnchor, constant: 10),
            saleDate.leadingAnchor.constraint(equalTo: saleDateIcon.trailingAnchor, constant: 10),
            saleDate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            targetTitle.topAnchor.constraint(equalTo: saleDate.bottomAnchor, constant: 15),
            targetTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            shopDepartmentIcon.centerYAnchor.constraint(equalTo: shopDepartment.centerYAnchor),
            shopDepartmentIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 17),
            shopDepartmentIcon.widthAnchor.constraint(equalToConstant: 16),
            shopDepartmentIcon.heightAnchor.constraint(equalToConstant: 16),
            shopDepartment.topAnchor.constraint(equalTo: targetTitle.bottomAnchor, constant: 10),
            shopDepartment.leadingAnchor.constraint(equalTo: shopDepartmentIcon.trailingAnchor, constant: 10),
            shopMajor.centerYAnchor.constraint(equalTo: shopDepartment.centerYAnchor),
            shopMajor.leadingAnchor.constraint(equalTo: shopDepartment.trailingAnchor),
            
            etcTitle.topAnchor.constraint(equalTo: shopMajor.bottomAnchor, constant: 15),
            etcTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            etcIcon.centerYAnchor.constraint(equalTo: etc.centerYAnchor),
            etcIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            etcIcon.widthAnchor.constraint(equalToConstant: 16),
            etcIcon.heightAnchor.constraint(equalToConstant: 16),
            etc.topAnchor.constraint(equalTo: etcTitle.bottomAnchor, constant: 10),
            etc.leadingAnchor.constraint(equalTo: etcIcon.trailingAnchor, constant: 10),
            etc.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            etc.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20) // 마지막 요소의 하단 여백
        ])
    }
    
    // 네이버 지도 클릭
    @objc private func openInNaverMap() {
        let coordinateURL = URL(string: "nmap://place?lat=\(store.lat)&lng=\(store.lng)&name=\(store.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&appname=com.jeolhak.ios.jeolhak")!
        // let url = URL(string: "nmap://search?query=\(store.address + " " + store.name)&appname=com.jeolhak.ios.jeolhak")!
        let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8")!
        
        if UIApplication.shared.canOpenURL(coordinateURL) {
            UIApplication.shared.open(coordinateURL)
        } else {
            UIApplication.shared.open(appStoreURL)
        }
    }
}
