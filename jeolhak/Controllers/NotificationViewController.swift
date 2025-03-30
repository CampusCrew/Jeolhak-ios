//
//  HomeViewController.swift
//  jeolhak
//
//  Created by 윤대현 on 3/27/25.
//

import UIKit

class NotificationViewController: UIViewController {
    
    private var dateView: UIView!
    
    private var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateView = NotificationDateView(date: "3월 30일")
        view.addSubview(dateView)
        dateView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 상단 제약 설정 (safeAreaLayout 기준)
            dateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            dateView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        contentView = NotificationContentView(image: "speaker.fill", content: "새로운 가게가 등록되었어요")
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 15),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
