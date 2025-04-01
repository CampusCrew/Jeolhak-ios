//
//  HomeViewController.swift
//  jeolhak
//
//  Created by 윤대현 on 3/27/25.
//

import UIKit

class NotificationViewController: UIViewController {
    
    private var dateView: UIView!
    
    private var contentView1: UIView!
    
    private var contentView2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        dateView = NotificationDateView(date: "오늘")
        view.addSubview(dateView)
        dateView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 상단 제약 설정 (safeAreaLayout 기준)
            dateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            dateView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        contentView1 = NotificationContentView(image: "speaker.wave.1.fill", content: "새로운 가게가 등록되었어요", color: .mainPink)
        view.addSubview(contentView1)
        contentView1.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView1.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 15),
            contentView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        contentView2 = NotificationContentView(image: "bell.fill", content: "할인 기간이 이틀 남았어요", color: .mainMint)
        view.addSubview(contentView2)
        contentView2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView2.topAnchor.constraint(equalTo: contentView1.bottomAnchor, constant: 15),
            contentView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
