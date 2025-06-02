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
    private var shopImageView = UIImageView()
    private var shopTitleLabel = UILabel()
    private var shopAddressLabel = UILabel()
    private var shopCategoryLabel = UILabel()
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
        
        // (임시) 다크모드 무시하고 배경 강제 white
        contentView.backgroundColor = .white
        
        // 가게 사진 - 개선된 설정
        shopImageView.contentMode = .scaleAspectFill  // scaleAspectFit → scaleAspectFill로 변경
        shopImageView.clipsToBounds = true
        shopImageView.backgroundColor = UIColor.systemGray6  // 로딩 중 배경색
        shopImageView.layer.cornerRadius = 20  // 직접 cornerRadius 설정
        shopImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // 가게 이름 (Title)
        shopTitleLabel.font = UIFont(name: "Jua-Regular", size: 16)
        shopTitleLabel.textColor = .black
        shopTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 가게 주소
        shopAddressLabel.font = UIFont(name: "Jua-Regular", size: 11)
        shopAddressLabel.textColor = .lightGray
        shopAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 가게 이름 탭 제스처 연결
        shopTitleLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(titleTapped))
        shopTitleLabel.addGestureRecognizer(tapGesture)
        
        // 가게 분류
        shopCategoryLabel.font = UIFont(name: "Jua-Regular", size: 14)
        shopCategoryLabel.textColor = .gray
        shopCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 가게 설명
        shopSaleInfoLabel.font = UIFont(name: "Jua-Regular", size: 14)
        shopSaleInfoLabel.textColor = .darkGray
        shopSaleInfoLabel.numberOfLines = 2
        shopSaleInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 하단 분류 선
        let line = UIView()
        line.backgroundColor = .mainPink
        line.translatesAutoresizingMaskIntoConstraints = false
        
        [shopImageView, shopTitleLabel, shopAddressLabel, shopCategoryLabel, shopSaleInfoLabel, line].forEach {
            contentView.addSubview($0)
        }
        
        // 레이아웃 설정 (제약조건) - 이미지 비율 고정
        NSLayoutConstraint.activate([
            // 가게 사진 - 300:180 비율로 고정
            shopImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            shopImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            shopImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            shopImageView.heightAnchor.constraint(equalTo: shopImageView.widthAnchor, multiplier: 180.0/300.0), // 3:5 비율 고정
            
            // 가게 이름
            shopTitleLabel.topAnchor.constraint(equalTo: shopImageView.bottomAnchor, constant: 8),
            shopTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            // 가게 주소
            shopAddressLabel.centerYAnchor.constraint(equalTo: shopTitleLabel.centerYAnchor),
            shopAddressLabel.leadingAnchor.constraint(equalTo: shopCategoryLabel.trailingAnchor, constant: 10),
            
            // 가게 분류
            shopCategoryLabel.centerYAnchor.constraint(equalTo: shopTitleLabel.centerYAnchor),
            shopCategoryLabel.leadingAnchor.constraint(equalTo: shopTitleLabel.trailingAnchor, constant: 6),
            
            // 가게 설명
            shopSaleInfoLabel.topAnchor.constraint(equalTo: shopTitleLabel.bottomAnchor, constant: 6),
            shopSaleInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            shopSaleInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            // 하단 분류 선
            line.topAnchor.constraint(equalTo: shopSaleInfoLabel.bottomAnchor, constant: 12),
            line.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            line.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            line.heightAnchor.constraint(equalToConstant: 1),
            line.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    // 탭 제스처 정의
    @objc private func titleTapped() {
        onTitleTapped?()
    }
    
    // MARK: - 뷰 설정
    // 생성자로 받아온 뷰 초기화
    func configure(shopImage: String, shopTitle: String, shopAddress: String, shopCategory: String, shopSaleInfo: String, shopFavorite: Bool){
        
        // 방법 1: Kingfisher의 Resizing Processor 사용 (권장)
        let resizingProcessor = ResizingImageProcessor(referenceSize: CGSize(width: 300, height: 180), mode: .aspectFill)
        let cornerProcessor = RoundCornerImageProcessor(cornerRadius: 20)
        let combinedProcessor = resizingProcessor |> cornerProcessor
        
        shopImageView.kf.indicatorType = .activity
        shopImageView.kf.setImage(
            with: URL(string: shopImage),
            placeholder: createPlaceholderImage(),
            options: [
                .transition(.fade(0.5)),
                .processor(combinedProcessor),
                .cacheSerializer(FormatIndicatedCacheSerializer.png) // PNG로 캐시하여 품질 유지
            ]
        )
        
        shopTitleLabel.text = shopTitle
        shopAddressLabel.text = shopAddress
        shopCategoryLabel.text = shopCategory
        shopSaleInfoLabel.text = shopSaleInfo
    }
    
    // 플레이스홀더 이미지 생성
    private func createPlaceholderImage() -> UIImage? {
        let size = CGSize(width: 300, height: 180)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        UIColor.systemGray5.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        
        // 간단한 아이콘이나 텍스트 추가 가능
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.systemGray3
        ]
        let text = "이미지 로딩중..."
        let textSize = text.size(withAttributes: attrs)
        let textRect = CGRect(
            x: (size.width - textSize.width) / 2,
            y: (size.height - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height
        )
        text.draw(in: textRect, withAttributes: attrs)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
