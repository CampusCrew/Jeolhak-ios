//
//  HomeContentItemView.swift
//  jeolhak
//
//  Created by 윤대현 on 4/10/25.
//

import UIKit
// Kingfisher 호출
import Kingfisher

// MARK: - 홈 화면 카드뷰 가게 정보
class HomeContentTableViewCell: UITableViewCell {
    
    static let identifier = "HomeContentTableViewCell"
    
    // MARK: - UI 초기화
    private var containerView = UIView()
    private var shopImageView = UIImageView()
    private var shopTitleLabel = UILabel()
    private var shopAddressLabel = UILabel()
    private var shopCategoryLabel = PaddingLabel()
    private var shopSaleInfoLabel = UILabel()

    
    // 가게 이름 탭 클로저
    var onTitleTapped: (() -> Void)?
    
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
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        // 컨테이너 뷰 설정
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 15
        containerView.layer.masksToBounds = false
        
        // 그림자 효과 추가
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = CGSize(width: 1, height: 3)
        containerView.layer.shadowRadius = 6
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // 가게 사진 - 상단에 배치
        shopImageView.contentMode = .scaleAspectFill
        shopImageView.clipsToBounds = true
        shopImageView.backgroundColor = UIColor.systemGray6
        shopImageView.layer.cornerRadius = 15
        shopImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // 상단 모서리만 라운드
        shopImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // 가게 이름 (Title)
        shopTitleLabel.font = UIFont(name: "Jua-Regular", size: 18)
        shopTitleLabel.textColor = .mainPink
        shopTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 가게 주소
        shopAddressLabel.font = UIFont(name: "Jua-Regular", size: 13)
        shopAddressLabel.textColor = .lightGray
        shopAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 가게 이름 탭 제스처 연결
        shopTitleLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(titleTapped))
        shopTitleLabel.addGestureRecognizer(tapGesture)
        
        // 가게 분류 - 우측 상단에 배지 스타일
        shopCategoryLabel.font = UIFont(name: "Jua-Regular", size: 12)
        shopCategoryLabel.textColor = .mainPink
        shopCategoryLabel.backgroundColor = UIColor.mainPink.withAlphaComponent(0.1)
        shopCategoryLabel.padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        shopCategoryLabel.textAlignment = .center
        shopCategoryLabel.layer.cornerRadius = 10
        shopCategoryLabel.layer.masksToBounds = true
        shopCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 가게 설명
        shopSaleInfoLabel.font = UIFont(name: "Jua-Regular", size: 14)
        shopSaleInfoLabel.textColor = .darkGray
        shopSaleInfoLabel.numberOfLines = 1
        shopSaleInfoLabel.lineBreakMode = .byTruncatingTail
        shopSaleInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 뷰 계층 구조 설정
        contentView.addSubview(containerView)
        [shopImageView, shopTitleLabel, shopAddressLabel, shopCategoryLabel, shopSaleInfoLabel].forEach {
            containerView.addSubview($0)
        }
        
        // 레이아웃 설정
        NSLayoutConstraint.activate([
            // 컨테이너 뷰
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // 가게 사진 - 상단 전체
            shopImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            shopImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            shopImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            shopImageView.heightAnchor.constraint(equalToConstant: 200),
            
            // 가게 분류 - 우측 상단 (텍스트 길이에 따라 동적 크기)
            shopCategoryLabel.centerYAnchor.constraint(equalTo: shopTitleLabel.centerYAnchor),
            shopCategoryLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            shopCategoryLabel.heightAnchor.constraint(equalToConstant: 20),
            
            // 가게 이름 - 이미지 아래 좌측
            shopTitleLabel.topAnchor.constraint(equalTo: shopImageView.bottomAnchor, constant: 16),
            shopTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            shopTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: shopCategoryLabel.leadingAnchor, constant: -8),
            
            // 가게 주소 - 타이틀 아래
            shopAddressLabel.topAnchor.constraint(equalTo: shopTitleLabel.bottomAnchor, constant: 4),
            shopAddressLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            shopAddressLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // 가게 설명 - 주소 아래
            shopSaleInfoLabel.topAnchor.constraint(equalTo: shopAddressLabel.bottomAnchor, constant: 8),
            shopSaleInfoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            shopSaleInfoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            shopSaleInfoLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    // 탭 제스처 정의
    @objc private func titleTapped() {
        onTitleTapped?()
    }
    
    // MARK: - 뷰 설정
    // 생성자로 받아온 뷰 초기화
    func configure(shopImage: String, shopTitle: String, shopAddress: String, shopCategory: String, shopSaleInfo: String, shopFavorite: Bool){
        
        // Kingfisher를 사용한 이미지 로딩
        let resizingProcessor = ResizingImageProcessor(referenceSize: CGSize(width: 400, height: 200), mode: .aspectFill)
        
        shopImageView.kf.indicatorType = .activity
        shopImageView.kf.setImage(
            with: URL(string: shopImage),
            options: [
                .transition(.fade(0.5)),
                .processor(resizingProcessor),
                .cacheSerializer(FormatIndicatedCacheSerializer.png)
            ]
        )
        
        shopTitleLabel.text = shopTitle
        shopAddressLabel.text = shopAddress
        shopCategoryLabel.text = shopCategory
        shopSaleInfoLabel.text = shopSaleInfo
    }
}

// MARK: - 카테고리 라벨 패딩을 위한 서브클래스
class PaddingLabel: UILabel {
    var padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }
}
