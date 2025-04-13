//
//  FavoriteContentItemView.swift
//  jeolhak
//
//  Created by 윤대현 on 4/12/25.
//

import UIKit


// MARK: - 즐겨찾기 한 가게 정보
class FavoriteContentItemView: UIView {
    
    // MARK: - UI 초기화
    private var shopTitleLabel = UILabel()
    private var shopCategoryLabel = UILabel()
    private var shopLocationLabel = UILabel()
    private var shopImageView = UIImageView()

    private var favoriteButton = UIButton()
    
    private var isFavorite: Bool = false {
        didSet{
            updateFavoriteIcon()
        }
    }
    
    // MARK: - 생성자
    init(shopTitle: String, shopCategory: String, shopLocation: String, shopImage: String, shopFavorite: Bool) {
        super.init(frame: .zero)
        
        self.isFavorite = shopFavorite
        
        setupViews()
        setViewConfigure(shopTitle: shopTitle,
                         shopCategory: shopCategory,
                         shopLocation: shopLocation,
                         shopImage: shopImage)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 뷰 세팅
    private func setupViews(){
        translatesAutoresizingMaskIntoConstraints = false
                
        // 가게 이름 (Title)
        shopTitleLabel.font = UIFont(name: "Jua-Regular", size: 16)
        shopTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(shopTitleLabel)
        
        // 가게 분류
        shopCategoryLabel.font = UIFont(name: "Jua-Regular", size: 14)
        shopCategoryLabel.textColor = .gray
        shopCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(shopCategoryLabel)
        
        // 가게 주소
        shopLocationLabel.font = UIFont(name: "Jua-Regular", size: 14)
        shopLocationLabel.textColor = .darkGray
        shopLocationLabel.numberOfLines = 2
        shopLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(shopLocationLabel)
        
        // 즐겨찾기
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        addSubview(favoriteButton)
        updateFavoriteIcon()
        
        // 가게 사진
        shopImageView.contentMode = .scaleAspectFit
        shopImageView.clipsToBounds = true
        shopImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(shopImageView)
        
        // 하단 분류 선
        let line = UIView()
        line.backgroundColor = .gray
        line.translatesAutoresizingMaskIntoConstraints = false
        addSubview(line)
        
        // 레이아웃 설정 (제약조건)
        NSLayoutConstraint.activate([
            // 가게 이름
            shopTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
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
            shopLocationLabel.topAnchor.constraint(equalTo: shopTitleLabel.bottomAnchor, constant: 6),
            shopLocationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            shopLocationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            shopLocationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            // 가게 사진
            shopImageView.topAnchor.constraint(equalTo: shopLocationLabel.bottomAnchor, constant: 12),
            shopImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shopImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shopImageView.heightAnchor.constraint(equalToConstant: 180),
            
            // 하단 분류 선
            line.topAnchor.constraint(equalTo: shopImageView.bottomAnchor, constant: 12),
            line.centerXAnchor.constraint(equalTo: centerXAnchor),
            line.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            line.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            line.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    // MARK: - 뷰 설정
    // 생성자로 받아온 뷰 초기화
    private func setViewConfigure(shopTitle: String, shopCategory: String, shopLocation: String, shopImage: String){
        shopTitleLabel.text = shopTitle
        shopCategoryLabel.text = shopCategory
        shopLocationLabel.text = shopLocation
        shopImageView.image = UIImage(named: shopImage)
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
