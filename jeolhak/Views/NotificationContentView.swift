//
//  NotificationValueView.swift
//  jeolhak
//
//  Created by 윤대현 on 3/30/25.
//

import UIKit

class NotificationContentView: UIView {

    private var image: String
    private var content: String
    
    init(image: String, content: String){
        self.image = image
        self.content = content
        super.init(frame: .zero)

        setupView()
        setupContent()
    }
    
    /** View 배경 세팅 */
    private func setupView(){
        backgroundColor = .white
        
        layer.cornerRadius = 20
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.mainPink.cgColor
        
        // 그림자
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 6
        layer.masksToBounds = false
    }
    
    private func setupContent(){
        // 아이콘 배경
        let iconBackground = UIView()
        iconBackground.backgroundColor = .mainPink
        iconBackground.layer.cornerRadius = 20
        iconBackground.clipsToBounds = true
        iconBackground.translatesAutoresizingMaskIntoConstraints = false
        
        // 아이콘 이미지
        let icon = UIImageView(image: UIImage(systemName: image))
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        iconBackground.addSubview(icon)
        
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: iconBackground.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: iconBackground.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 20),
            icon.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // 텍스트
        let label = UILabel()
        label.text = content
        label.font = UIFont(name: "Jua-Regular", size: 20)
        label.textColor = .mainPink
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // HStack 생성
        let stackView = UIStackView(arrangedSubviews: [iconBackground, label])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            iconBackground.widthAnchor.constraint(equalToConstant: 40),
            iconBackground.heightAnchor.constraint(equalToConstant: 40),
            
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
     
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
