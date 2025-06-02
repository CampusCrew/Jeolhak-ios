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
    
    private let emptyStateLabel = UILabel()
    private var emptyStateIcon: UIImageView?
    private var emptyStateContainer: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupDateView()
        setupScrollView()
        setupStackView()
        setupEmptyState()
        setupObservers()
        
        // 저장된 알림들 불러오기
        loadNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 화면이 나타날 때마다 최신 알림 불러오기
        loadNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupNavigationBar() {
        title = "알림"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // Title 스타일 커스텀
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .white
        navBarAppearance.titleTextAttributes = [
            .font: UIFont(name: "Jua-Regular", size: 24)!,
            .foregroundColor: UIColor.mainPink
        ]
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        // 전체삭제 버튼 커스텀
        let clearButton = UIBarButtonItem(
            title: "전체삭제",
            style: .plain,
            target: self,
            action: #selector(clearAllTapped)
        )
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Jua-Regular", size: 16)!,
            .foregroundColor: UIColor.mainPink
        ]
        clearButton.setTitleTextAttributes(attributes, for: .normal)
        clearButton.setTitleTextAttributes(attributes, for: .highlighted)
        
        navigationItem.rightBarButtonItem = clearButton
    }
    
    // MARK: - 알람이 없을 때
    private func setupEmptyState() {
        // 라벨 설정
        emptyStateLabel.text = "알람이 오지 않았어요!"
        emptyStateLabel.textColor = .gray
        emptyStateLabel.font = UIFont(name: "Jua-Regular", size: 24) ?? UIFont.systemFont(ofSize: 24)
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.isHidden = true
        
        // 아이콘 설정
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: "cloud.rain.fill")
        iconImageView.tintColor = .mainPink
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.isHidden = true
        
        // 컨테이너 뷰 생성 (라벨과 아이콘을 담을 용도)
        let containerView = UIView()
        containerView.isHidden = true
        
        // 서브뷰 추가
        view.addSubview(containerView)
        containerView.addSubview(emptyStateLabel)
        containerView.addSubview(iconImageView)
        
        // Auto Layout 설정
        containerView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 컨테이너 뷰를 view 중앙에 배치
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40),
            
            // 라벨 제약조건
            emptyStateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            // 아이콘 제약조건 (라벨 오른쪽 10pt 떨어진 위치)
            iconImageView.leadingAnchor.constraint(equalTo: emptyStateLabel.trailingAnchor, constant: 10),
            iconImageView.centerYAnchor.constraint(equalTo: emptyStateLabel.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 25),
            iconImageView.heightAnchor.constraint(equalToConstant: 25),
            iconImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        // 참조 저장 (나중에 show/hide 할 때 사용하기 위해)
        self.emptyStateContainer = containerView
        self.emptyStateIcon = iconImageView
    }
    
    private func setupObservers() {
        // 새로운 알림 수신
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNotificationUpdate(_:)),
            name: .notificationListUpdated,
            object: nil
        )
        
        // 전체 삭제
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNotificationCleared),
            name: .notificationListCleared,
            object: nil
        )
    }
    
    private func setupDateView() {
        view.addSubview(dateView)
        dateView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dateView.centerXAnchor.constraint(equalTo: view.centerXAnchor), // 가로 중앙 정렬
            dateView.widthAnchor.constraint(equalToConstant: 150), // 고정 길이 100
            dateView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: dateView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupStackView() {
        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
    private func loadNotifications() {
        // 기존 알림 뷰들 제거
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let notifications = NotificationManager.shared.loadNotifications()
        
        if notifications.isEmpty {
            emptyStateContainer?.isHidden = false
            emptyStateLabel.isHidden = false
            emptyStateIcon?.isHidden = false
        } else {
            emptyStateContainer?.isHidden = true
            emptyStateLabel.isHidden = true
            emptyStateIcon?.isHidden = true
            
            // 최신순으로 표시
            for notification in notifications.reversed() {
                let notificationView = NotificationContentView(notification: notification)
                stackView.addArrangedSubview(notificationView)
            }
        }
    }
    
    @objc private func handleNotificationUpdate(_ notification: Notification) {
        guard let newNotification = notification.object as? NotificationItem else { return }
        
        emptyStateLabel.isHidden = true
        
        // 새로운 알림을 맨 위에 애니메이션과 함께 추가
        let newNotificationView = NotificationContentView(notification: newNotification)
        
        newNotificationView.alpha = 0
        newNotificationView.transform = CGAffineTransform(translationX: 0, y: -30)
        
        stackView.insertArrangedSubview(newNotificationView, at: 0)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            newNotificationView.alpha = 1
            newNotificationView.transform = .identity
        }
        
        // 스크롤을 맨 위로
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrollView.setContentOffset(.zero, animated: true)
        }
    }
    
    @objc private func handleNotificationCleared() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        emptyStateContainer?.isHidden = false
        emptyStateLabel.isHidden = false
        emptyStateIcon?.isHidden = false
    }
    
    @objc private func clearAllTapped() {
        let alert = UIAlertController(title: "알림 삭제", message: "모든 알림을 삭제하시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { _ in
            NotificationManager.shared.clearAllNotifications()
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(alert, animated: true)
    }
}
