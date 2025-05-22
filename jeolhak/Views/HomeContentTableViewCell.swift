//
//  HomeContentItemView.swift
//  jeolhak
//
//  Created by 윤대현 on 4/10/25.
//

import UIKit

// MARK: - 홈 화면 카드뷰 가게 정보
class HomeContentTableViewCell: UITableViewCell {
    
    static let identifier = "HomeContentTableViewCell"
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 뷰 세팅
    private func setupViews(){
        selectionStyle = .none
        
        // 가게 사진
        shopImageView.contentMode = .scaleAspectFit
        shopImageView.clipsToBounds = true
        shopImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // 가게 이름 (Title)
        shopTitleLabel.font = UIFont(name: "Jua-Regular", size: 16)
        shopTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 가게 분류
        shopCategoryLabel.font = UIFont(name: "Jua-Regular", size: 14)
        shopCategoryLabel.textColor = .gray
        shopCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 가게 설명
        shopContentLabel.font = UIFont(name: "Jua-Regular", size: 14)
        shopContentLabel.textColor = .darkGray
        shopContentLabel.numberOfLines = 2
        shopContentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 즐겨찾기
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        
        // 하단 분류 선
        let line = UIView()
        line.backgroundColor = .gray
        line.translatesAutoresizingMaskIntoConstraints = false
        
        updateFavoriteIcon()
        
        [shopImageView, shopTitleLabel, shopCategoryLabel, shopContentLabel, favoriteButton, line].forEach {
            contentView.addSubview($0)
        }
        
        // 레이아웃 설정 (제약조건)
        NSLayoutConstraint.activate([
            // 가게 사진
            shopImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            shopImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shopImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            shopImageView.heightAnchor.constraint(equalToConstant: 180),
            
            // 가게 이름
            shopTitleLabel.topAnchor.constraint(equalTo: shopImageView.bottomAnchor, constant: 8),
            shopTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            // 가게 분류
            shopCategoryLabel.centerYAnchor.constraint(equalTo: shopTitleLabel.centerYAnchor),
            shopCategoryLabel.leadingAnchor.constraint(equalTo: shopTitleLabel.trailingAnchor, constant: 6),
            
            // 즐겨찾기
            favoriteButton.centerYAnchor.constraint(equalTo: shopTitleLabel.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24),
            
            // 가게 설명
            shopContentLabel.topAnchor.constraint(equalTo: shopTitleLabel.bottomAnchor, constant: 6),
            shopContentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            shopContentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            shopContentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            // 하단 분류 선
            line.topAnchor.constraint(equalTo: shopContentLabel.bottomAnchor, constant: 12),
            line.centerXAnchor.constraint(equalTo: centerXAnchor),
            line.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            line.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            line.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    // MARK: - 뷰 설정
    // 생성자로 받아온 뷰 초기화
    func configure(shopImage: String, shopTitle: String, shopCategory: String, shopContent: String, shopFavorite: Bool){
        shopImageView.image = UIImage(named: shopImage) // URL 이미지 비동기 로드 가능
        shopTitleLabel.text = shopTitle
        shopCategoryLabel.text = shopCategory
        shopContentLabel.text = shopContent
        isFavorite = shopFavorite
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
