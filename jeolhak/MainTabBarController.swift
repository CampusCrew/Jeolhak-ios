//
//  ViewController.swift
//  jeolhak
//
//  Created by 윤대현 on 3/27/25.
//

/**
 시작 화면
 */

import UIKit

class MainTabBarController: UITabBarController {
    
    let homeVC = HomeViewController()
    let favoriteVC = FavoriteViewController()
    let notifivationVC = NotificationViewController()
    let uploadVC = UploadViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controllers = [homeVC, favoriteVC, notifivationVC, uploadVC]
        self.viewControllers = controllers.map{
            UINavigationController(rootViewController: $0)
        }
        
        setTabBar()
    }
    
    // 탭 바 설정
    func setTabBar() {
        // 기존 탭바 아이템 설정 그대로 유지
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
        favoriteVC.tabBarItem = UITabBarItem(title: "즐겨찾기", image: UIImage(systemName: "star"), tag: 1)
        notifivationVC.tabBarItem = UITabBarItem(title: "알림", image: UIImage(systemName: "bell"), tag: 2)
        uploadVC.tabBarItem = UITabBarItem(title: "등록", image: UIImage(systemName: "plus"), tag: 3)
        
        // 탭 바 appearance 설정
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground() // 배경 투명 방지
        appearance.backgroundColor = .white // 배경색 설정
        
        
        // 탭바 아이템 색상 설정
        let itemAppearance = UITabBarItemAppearance()  // UITabBarItemAppearance 객체 생성
            
        // 선택된 아이템 스타일 설정
        itemAppearance.selected.iconColor = UIColor.gray
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.gray]
        
        // 미선택된 아이템 스타일 설정
        itemAppearance.normal.iconColor = UIColor.systemPink
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemPink]
    
        // appearance에 itemAppearance 적용
        appearance.stackedLayoutAppearance = itemAppearance
        
        // 텍스트 스타일
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        
        // 적용
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        // 탭바 구분선
        tabBar.layer.borderWidth = 0.3
        tabBar.layer.borderColor = UIColor.gray.cgColor
 
    }
}
