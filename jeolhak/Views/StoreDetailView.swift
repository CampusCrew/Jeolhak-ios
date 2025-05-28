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
    
    private let shopImage = UIImageView()
    private let shopName = UILabel()
    private let shopCategory = UILabel()
    private let locationIcon = UIImageView()
    private let shopAddress = UILabel()
    private let saleInfoTitle = UILabel()
    private let saleInfo = UILabel()
    private let saleDateTitle = UILabel()
    private let saleDate = UILabel()
    private let targetTitle = UILabel()
    private let shopDepartment = UILabel()
    private let shopMajor = UILabel()
    private let etcTitle = UILabel()
    private let etc = UILabel()
    
    private let divider1 = UIView()
    private let divider2 = UIView()
    private let divider3 = UIView()
    private let divider4 = UIView()
    
    init(store: Store) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        setupSubviews(store: store)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews(store: Store) {
        // 이미지
        shopImage.kf.indicatorType = .activity
        shopImage.kf.setImage(with: URL(string: store.imageURL), options: [.transition(.fade(0.5)), .processor(RoundCornerImageProcessor(cornerRadius: 20))])
        shopImage.contentMode = .scaleAspectFill
        shopImage.clipsToBounds = true
        
        // 텍스트 설정
        shopName.text = store.name
        shopName.font = UIFont(name: "Jua-Regular", size: 24)
        shopName.textColor = .black
        
        shopCategory.text = store.category
        shopCategory.font = UIFont(name: "Jua-Regular", size: 16)
        shopCategory.textColor = .lightGray
        
        locationIcon.image = UIImage(systemName: "location.fill")
        locationIcon.tintColor = .darkGray
        
        shopAddress.text = store.address
        shopAddress.font = UIFont(name: "Jua-Regular", size: 18)
        shopAddress.textColor = .darkGray
        
        saleInfoTitle.text = "할인 정보"
        saleInfoTitle.font = UIFont(name: "Jua-Regular", size: 20)
        saleInfoTitle.textColor = .black
        
        saleInfo.text = store.saleInfo
        saleInfo.font = UIFont(name: "Jua-Regular", size: 18)
        saleInfo.textColor = .darkGray
        saleInfo.numberOfLines = 0
        
        saleDateTitle.text = "할인 기간"
        saleDateTitle.font = UIFont(name: "Jua-Regular", size: 20)
        saleDateTitle.textColor = .black
        
        saleDate.text = store.saleDate
        saleDate.font = UIFont(name: "Jua-Regular", size: 18)
        saleDate.textColor = .darkGray
        
        targetTitle.text = "할인 대상"
        targetTitle.font = UIFont(name: "Jua-Regular", size: 20)
        targetTitle.textColor = .black
        
        shopDepartment.text = store.department
        shopDepartment.font = UIFont(name: "Jua-Regular", size: 18)
        shopDepartment.textColor = .darkGray
        
        shopMajor.text = store.major == "" ? "전체학생" : store.major
        shopMajor.font = UIFont(name: "Jua-Regular", size: 18)
        shopMajor.textColor = .darkGray
        
        etcTitle.text = "설명(기타)"
        etcTitle.font = UIFont(name: "Jua-Regular", size: 20)
        etcTitle.textColor = .black
        
        etc.text = store.etc
        etc.font = UIFont(name: "Jua-Regular", size: 18)
        etc.textColor = .darkGray
        etc.numberOfLines = 0
        
        [shopImage, shopName, shopCategory, locationIcon, shopAddress,
         divider1, saleInfoTitle, saleInfo,
         divider2, saleDateTitle, saleDate,
         divider3, targetTitle, shopDepartment, shopMajor,
         divider4, etcTitle, etc].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            shopImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            shopImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            shopImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            shopImage.heightAnchor.constraint(equalToConstant: 200),
            
            shopName.topAnchor.constraint(equalTo: shopImage.bottomAnchor, constant: 15),
            shopName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            shopCategory.centerYAnchor.constraint(equalTo: shopName.centerYAnchor),
            shopCategory.leadingAnchor.constraint(equalTo: shopName.trailingAnchor, constant: 10),
            
            shopAddress.topAnchor.constraint(equalTo: shopName.bottomAnchor, constant: 15),
            locationIcon.centerYAnchor.constraint(equalTo: shopAddress.centerYAnchor),
            locationIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            locationIcon.widthAnchor.constraint(equalToConstant: 16),
            locationIcon.heightAnchor.constraint(equalToConstant: 16),
            shopAddress.leadingAnchor.constraint(equalTo: locationIcon.trailingAnchor, constant: 5),
            shopAddress.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            divider1.topAnchor.constraint(equalTo: shopAddress.bottomAnchor, constant: 10),
            divider1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            divider1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            divider1.heightAnchor.constraint(equalToConstant: 1),
            
            saleInfoTitle.topAnchor.constraint(equalTo: divider1.bottomAnchor, constant: 15),
            saleInfoTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            saleInfo.topAnchor.constraint(equalTo: saleInfoTitle.bottomAnchor, constant: 10),
            saleInfo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            saleInfo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            divider2.topAnchor.constraint(equalTo: saleInfo.bottomAnchor, constant: 10),
            divider2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            divider2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            divider2.heightAnchor.constraint(equalToConstant: 1),
            
            saleDateTitle.topAnchor.constraint(equalTo: divider2.bottomAnchor, constant: 15),
            saleDateTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            saleDate.topAnchor.constraint(equalTo: saleDateTitle.bottomAnchor, constant: 10),
            saleDate.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            saleDate.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            divider3.topAnchor.constraint(equalTo: saleDate.bottomAnchor, constant: 10),
            divider3.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            divider3.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            divider3.heightAnchor.constraint(equalToConstant: 1),
            
            targetTitle.topAnchor.constraint(equalTo: divider3.bottomAnchor, constant: 15),
            targetTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            shopDepartment.topAnchor.constraint(equalTo: targetTitle.bottomAnchor, constant: 10),
            shopDepartment.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            shopMajor.centerYAnchor.constraint(equalTo: shopDepartment.centerYAnchor),
            shopMajor.leadingAnchor.constraint(equalTo: shopDepartment.trailingAnchor, constant: 10),
            
            divider4.topAnchor.constraint(equalTo: shopDepartment.bottomAnchor, constant: 10),
            divider4.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            divider4.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            divider4.heightAnchor.constraint(equalToConstant: 1),
            
            etcTitle.topAnchor.constraint(equalTo: divider4.bottomAnchor, constant: 15),
            etcTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            etc.topAnchor.constraint(equalTo: etcTitle.bottomAnchor, constant: 10),
            etc.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            etc.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}

