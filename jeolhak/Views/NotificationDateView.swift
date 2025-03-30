//
//  Date.swift
//  jeolhak
//
//  Created by 윤대현 on 3/29/25.
//

import UIKit

class NotificationDateView: UIView {
    
    private var date: String

    init(date: String) {
        self.date = date
        super.init(frame: .zero)
        backgroundColor = .systemPink
        
        layer.cornerRadius = 20
        layer.masksToBounds = true
        
        setLabel()
    }
    
    private func setLabel(){
        let label = UILabel()
        label.text = date
        label.font = UIFont(name: "Jua-Regular", size: 14)
        label.textColor = .white
        
        label.translatesAutoresizingMaskIntoConstraints = false
            
        addSubview(label)
        
        // 패딩값 기준, label의 길이 조절
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
