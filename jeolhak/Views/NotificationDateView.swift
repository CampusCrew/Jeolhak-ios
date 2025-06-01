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
        backgroundColor = .mainPink
        
        layer.cornerRadius = 20
        layer.masksToBounds = true
        
        setLabel()
    }
    
    private func setLabel(){
        let label = UILabel()
        label.text = date
        label.font = UIFont(name: "Jua-Regular", size: 18)
        label.textColor = .white
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        
        // 패딩값 기준, label의 길이 조절
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            // label의 최대 폭이 dateView 내부 padding을 고려해 150보다 작게
            label.widthAnchor.constraint(lessThanOrEqualToConstant: 110) // 150 - (좌우 여백 20 + 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
