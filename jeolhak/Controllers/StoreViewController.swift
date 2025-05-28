//
//  StoreViewController.swift
//  jeolhak
//
//  Created by 윤대현 on 5/27/25.
//

import UIKit

class StoreViewController: UIViewController {
    
    // 가게 이미지
    private var shopImage: UIImageView!
    // 가게 이름
    private var shopName: UILabel!
    // 가게 카테고리
    private var shopCategory: UILabel!
    // 가게 주소
    private var shopAddress: UILabel!
    // 할인 대상 : 학과
    private var shopMajor: UILabel!
    // 할인 대상 : 단과대학
    private var shopDepartment: UILabel!
    // 할인 정보
    private var saleInfo: UILabel!
    // 할인 기간
    private var saleDate: UILabel!
    // 기타 설명
    private var etc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        // 1. 가게 이미지
        shopImage = UIImageView()
        shopImage.image = UIImage(named: "testImage")
        shopImage.translatesAutoresizingMaskIntoConstraints = false
        shopImage.contentMode = .scaleAspectFill
        shopImage.clipsToBounds = true
        view.addSubview(shopImage)
        
        // 2. 가게 이름
        shopName = UILabel()
        shopName.text = "이디아 동산점"
        shopName.translatesAutoresizingMaskIntoConstraints = false
        shopName.font = UIFont(name: "Jua-Regular", size: 16)
        shopName.textColor = .black
        view.addSubview(shopName)
        
        // 2-2. 가게 카테고리
        shopCategory = UILabel()
        shopCategory.text = "카페"
        shopCategory.translatesAutoresizingMaskIntoConstraints = false
        shopCategory.font = UIFont(name: "Jua-Regular", size: 14)
        shopCategory.textColor = .darkGray
        view.addSubview(shopCategory)
        
        // 3. 가게 주소
        shopAddress = UILabel()
        shopAddress.text = "서동로 18길 101길"
        shopAddress.translatesAutoresizingMaskIntoConstraints = false
        shopAddress.font = UIFont(name: "Jua-Regular", size: 16)
        shopAddress.textColor = .black
        view.addSubview(shopAddress)
        
        // 4. 할인 정보
        saleInfo = UILabel()
        saleInfo.text = "모든 음료 10% 추가 할인"
        saleInfo.translatesAutoresizingMaskIntoConstraints = false
        saleInfo.font = UIFont(name: "Jua-Regular", size: 16)
        saleInfo.textColor = .black
        saleInfo.numberOfLines = 0
        view.addSubview(saleInfo)
        
        // 5. 할인 기간
        saleDate = UILabel()
        saleDate.text = "2025.03.04~2025.12.31"
        saleDate.translatesAutoresizingMaskIntoConstraints = false
        saleDate.font = UIFont(name: "Jua-Regular", size: 16)
        saleDate.textColor = .black
        view.addSubview(saleDate)
        
        // 6-1. 할인 대상 - 단과대학
        shopDepartment = UILabel()
        shopDepartment.text = "창의공과대학"
        shopDepartment.translatesAutoresizingMaskIntoConstraints = false
        shopDepartment.font = UIFont(name: "Jua-Regular", size: 16)
        shopDepartment.textColor = .black
        view.addSubview(shopDepartment)
        
        // 6-2. 할인 대상 - 학과
        shopMajor = UILabel()
        shopMajor.text = "컴퓨터소프트웨어공학과"
        shopMajor.translatesAutoresizingMaskIntoConstraints = false
        shopMajor.font = UIFont(name: "Jua-Regular", size: 14)
        shopMajor.textColor = .darkGray
        view.addSubview(shopMajor)
        
        // 7. 기타 정보
        etc = UILabel()
        etc.text = "반드시 클리커를 통해 인증을 해야합니다."
        etc.translatesAutoresizingMaskIntoConstraints = false
        etc.font = UIFont(name: "Jua-Regular", size: 16)
        etc.textColor = .black
        etc.numberOfLines = 0
        view.addSubview(etc)
        
        NSLayoutConstraint.activate(
            [
                // 1. 이미지 (상단 0부터 높이 300)
                shopImage.topAnchor
                    .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                shopImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                shopImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                shopImage.heightAnchor.constraint(equalToConstant: 300),
                
                // 2. 가게 이름
                shopName.topAnchor
                    .constraint(equalTo: shopImage.bottomAnchor, constant: 15),
                shopName.leadingAnchor
                    .constraint(equalTo: view.leadingAnchor, constant: 16),
                
                // 2-2. 카테고리
                shopCategory.centerYAnchor
                    .constraint(equalTo: shopName.centerYAnchor),
                shopCategory.leadingAnchor
                    .constraint(equalTo: shopName.trailingAnchor, constant: 10),
                
                // 3. 주소
                shopAddress.topAnchor
                    .constraint(equalTo: shopName.bottomAnchor, constant: 15),
                shopAddress.leadingAnchor
                    .constraint(equalTo: view.leadingAnchor, constant: 16),
                shopAddress.trailingAnchor
                    .constraint(equalTo: view.trailingAnchor, constant: -16),
                
                // 4. 할인 정보
                saleInfo.topAnchor
                    .constraint(equalTo: shopAddress.bottomAnchor, constant: 15),
                saleInfo.leadingAnchor
                    .constraint(equalTo: view.leadingAnchor, constant: 16),
                saleInfo.trailingAnchor
                    .constraint(equalTo: view.trailingAnchor, constant: -16),
                
                // 5. 할인 기간
                saleDate.topAnchor
                    .constraint(equalTo: saleInfo.bottomAnchor, constant: 15),
                saleDate.leadingAnchor
                    .constraint(equalTo: view.leadingAnchor, constant: 16),
                saleDate.trailingAnchor
                    .constraint(equalTo: view.trailingAnchor, constant: -16),
                
                // 6. 할인 대상 (단과)
                shopDepartment.topAnchor
                    .constraint(equalTo: saleDate.bottomAnchor, constant: 15),
                shopDepartment.leadingAnchor
                    .constraint(equalTo: view.leadingAnchor, constant: 16),
                
                // 6-2. 학과
                shopMajor.centerYAnchor
                    .constraint(equalTo: shopDepartment.centerYAnchor),
                shopMajor.leadingAnchor
                    .constraint(
                        equalTo: shopDepartment.trailingAnchor,
                        constant: 10
                    ),
                
                // 7. 기타
                etc.topAnchor
                    .constraint(equalTo: shopDepartment.bottomAnchor, constant: 15),
                etc.leadingAnchor
                    .constraint(equalTo: view.leadingAnchor, constant: 16),
                etc.trailingAnchor
                    .constraint(equalTo: view.trailingAnchor, constant: -16)
            ]
        )
    }
}
