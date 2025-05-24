//
//  HomeSelectedUserInfoView.swift
//  jeolhak
//
//  Created by 윤대현 on 5/25/25.
//

import UIKit

// MARK: - 사용자가 선택한 단과대학, 학과 보여주는 작은 뷰

class HomeSelectedUserInfoView: UIView {
    
    private let label = UILabel()
    
    init(content: String){
        super.init(frame: .zero)
        setupView()
        setupContent()
        update(content: content) // 초기 텍스트 설정
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        backgroundColor = .white
        
        layer.cornerRadius = 15
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 6
        layer.masksToBounds = false
    }
    
    private func setupContent() {
        label.font = UIFont(name: "Jua-Regular", size: 14)
        label.textColor = .mainPink
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
    
    func update(content: String){
        label.text = content
    }
}
