//
//  HomeMoveMapResearchView.swift
//  jeolhak
//
//  Created by 윤대현 on 5/26/25.
//

import UIKit

// MARK: - 지도 이동 멈춤 시, "현재 위치에서 검색" 뷰 화면 표시 (임시적으로 사용 안함)

class HomeMoveMapResearchView: UIView {
    
    private var label = UILabel()
    private var iconView = UIImageView()
    
    // 뷰 클릭 클로저
    var onTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
        setupContent()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 15
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 6
        layer.masksToBounds = false
    }
    
    private func setupContent() {
        // 아이콘
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        iconView.image = UIImage(systemName: "arrow.triangle.2.circlepath", withConfiguration: config)
        iconView.tintColor = .mainMint
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        // 라벨
        label.font = UIFont(name: "Jua-Regular", size: 14)
        label.textColor = .mainMint
        label.numberOfLines = 1
        label.text = "현재 위치에서 새로고침"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(iconView)
        addSubview(label)
        
        NSLayoutConstraint.activate([
                    iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                    iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
                    iconView.widthAnchor.constraint(equalToConstant: 18),
                    iconView.heightAnchor.constraint(equalToConstant: 18),
                    
                    label.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
                    label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
                    label.centerYAnchor.constraint(equalTo: centerYAnchor),
                    label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
                    label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
                ])
    }
    
    // 탭 제스쳐 연결
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
    }
    
    @objc private func handleTap() {
        onTap?()
    }
}
