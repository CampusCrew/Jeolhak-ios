//
//  HomeContentItemView.swift
//  jeolhak
//
//  Created by 윤대현 on 4/10/25.
//

import UIKit

class HomeContentItemView: UIView {
    
    // MARK: - UI 초기화
    private var shopImageView = UIImageView()
    private var shopTitleLabel = UILabel()
    private var shopCategoryLabel = UILabel()
    private var shopContentLabel = UILabel()
    private var favoriteButton = UIButton()
    
    private var isFavorite: Bool = false {
        didSet{
            updateFavoriteIcon()
        }
    }
    
    // MARK: - 생성자
    init(shopImage: String, shopTitle: String, shopCategory: String, shopContent: String, shopFavorite: Bool) {
        super.init(frame: .zero)
        
        self.isFavorite = shopFavorite
        
        setupViews()
        setViewConfigure(shopImage: shopImage,
                  shopTitle: shopTitle,
                  shopCategory: shopCategory,
                  shopContent: shopContent)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 뷰 세팅
    private func setupViews(){
        translatesAutoresizingMaskIntoConstraints = false
        
        // 가게 사진
        shopImageView.contentMode = .scaleAspectFit
        shopImageView.clipsToBounds = true
        shopImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(shopImageView)
        
        // 가게 이름 (Title)
        shopTitleLabel.font = UIFont(name: "Jua-Regular", size: 16)
        shopTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(shopTitleLabel)
        
        // 가게 분류
        shopCategoryLabel.font = UIFont(name: "Jua-Regular", size: 14)
        shopCategoryLabel.textColor = .gray
        shopCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(shopCategoryLabel)
        
        // 가게 설명
        shopContentLabel.font = UIFont(name: "Jua-Regular", size: 14)
        shopContentLabel.textColor = .darkGray
        shopContentLabel.numberOfLines = 2
        shopContentLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(shopContentLabel)
        
        // 즐겨찾기
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        addSubview(favoriteButton)
        updateFavoriteIcon()
        
        // 레이아웃 설정 (제약조건)
        NSLayoutConstraint.activate([
            // 가게 사진
            shopImageView.topAnchor.constraint(equalTo: topAnchor),
            shopImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shopImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shopImageView.heightAnchor.constraint(equalToConstant: 180),
            
            // 가게 이름
            shopTitleLabel.topAnchor.constraint(equalTo: shopImageView.bottomAnchor, constant: 8),
            shopTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            
            // 가게 분류
            shopCategoryLabel.centerYAnchor.constraint(equalTo: shopTitleLabel.centerYAnchor),
            shopCategoryLabel.leadingAnchor.constraint(equalTo: shopTitleLabel.trailingAnchor, constant: 6),
            
            // 즐겨찾기
            favoriteButton.centerYAnchor.constraint(equalTo: shopTitleLabel.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24),
            
            // 가게 설명
            shopContentLabel.topAnchor.constraint(equalTo: shopTitleLabel.bottomAnchor, constant: 6),
            shopContentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            shopContentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            shopContentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - 뷰 설정
    // 생성자로 받아온 뷰 초기화
    private func setViewConfigure(shopImage: String, shopTitle: String, shopCategory: String, shopContent: String){
        shopImageView.image = UIImage(named: shopImage) // URL 이미지 비동기 로드 가능
        shopTitleLabel.text = shopTitle
        shopCategoryLabel.text = shopCategory
        shopContentLabel.text = shopContent
    }
    
    // 즐겨찾기 업데이트
    private func updateFavoriteIcon(){
        let imageName = isFavorite ? "star.fill" : "star"
        let image = UIImage(systemName: imageName)
        favoriteButton.setImage(image, for: .normal)
        favoriteButton.tintColor = isFavorite ? .systemYellow : .lightGray
    }
    
    // 즐겨찾기 셀렉터
    @objc private func toggleFavorite() {
        isFavorite.toggle()
    }

}
