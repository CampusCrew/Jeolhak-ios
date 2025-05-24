//
//  SplashViewController.swift
//  jeolhak
//
//  Created by 윤대현 on 4/2/25.
//

import UIKit

class SplashViewController: UIViewController {
    private var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // 로고
        setupLogo()
        
        // 라벨
        setupLabel()
        
        // 설정된 시간 후 메인화면 전환
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.routeBasedOnLaunchStatus()
        }
    }
    
    private func routeBasedOnLaunchStatus() {
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        
        if isFirstLaunch {
            let userInfoVC = UserInfoViewController()
            userInfoVC.entryMode = .initialLaunch
            userInfoVC.modalPresentationStyle = .fullScreen
            self.present(userInfoVC, animated: true)
        } else {
            self.switchToMainTabBar()
        }
    }
    
    private func switchToMainTabBar() {
        let mainTabBarController = MainTabBarController()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                window.rootViewController = mainTabBarController
            }, completion: nil)
        }
    }
    
    
    // 로고 설정
    private func setupLogo(){
        logoImageView = UIImageView(image: UIImage(named: "SplashLogo"))
        // 비율 유지
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 130),
            logoImageView.heightAnchor.constraint(equalToConstant: 130)
        ])
    }
    
    // 라벨 설정
    private func setupLabel(){
        let label = UILabel()
        label.text = "절약학개론"
        label.font = UIFont(name: "Jua-Regular", size: 24)
        label.textColor = .mainPink
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 280)
        ])
        
    }
}
