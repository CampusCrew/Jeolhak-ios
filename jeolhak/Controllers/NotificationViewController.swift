//
//  HomeViewController.swift
//  jeolhak
//
//  Created by 윤대현 on 3/27/25.
//

import UIKit

class NotificationViewController: UIViewController {
    
    private let dateView = NotificationDateView(date: "오늘")
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    private var notifications: [(image: String, content: String, color: UIColor)] = [
        ("speaker.wave.1.fill", "새로운 가게가 등록되었어요", .mainPink),
        ("bell.fill", "할인 기간이 이틀 남았어요", .mainMint)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 알람 옵저버
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handlePushNotification(_:)),
                                               name: .didReceivePushNotification,
                                               object: nil)
        
        setupDateView()
        setupScrollView()
        setupStackView()
        loadNotifications()
    }
    
    // 알람 수신 시 리스트뷰 append
    @objc private func handlePushNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let body = userInfo["body"] as? String else { return }
        
        // content 추가
        notifications.append((image: "bell.fill", content: body, color: .mainPink))
        loadNotifications()
    }
    
    private func setupDateView() {
        view.addSubview(dateView)
        dateView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            dateView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 15),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }
    
    private func loadNotifications() {
        for (icon, content, color) in notifications {
            let notificationView = NotificationContentView(image: icon, content: content, color: color)
            notificationView.translatesAutoresizingMaskIntoConstraints = false
            addSwipeToDelete(to: notificationView)
            stackView.addArrangedSubview(notificationView)
        }
    }
    
    private func addSwipeToDelete(to view: UIView) {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipe.direction = .left
        view.addGestureRecognizer(swipe)
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        guard let swipedView = gesture.view else { return }
        UIView.animate(withDuration: 0.3, animations: {
            swipedView.alpha = 0
            swipedView.transform = CGAffineTransform(translationX: -swipedView.frame.width, y: 0)
        }, completion: { _ in
            swipedView.removeFromSuperview()
        })
    }
}
