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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            self.switchToMainTabBar()
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
    
    // 라벨 설정
    
    // 메인화면 전환 함수
    private func switchToMainTabBar() {
        let mainTabBarController = MainTabBarController()
        
        // rootViewController 교체
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            // 애니메이션
            // 애니메이션 효과 (선택)
                        UIView.transition(with: window,
                                          duration: 0.3,
                                          options: .transitionCrossDissolve,
                                          animations: {
                                              window.rootViewController = mainTabBarController
                                          },
                                          completion: nil)
        }
    }


}
