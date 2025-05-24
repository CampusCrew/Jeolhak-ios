//
//  HomeSearchBarView.swift
//  jeolhak
//
//  Created by 윤대현 on 5/24/25.
//

import UIKit

class HomeSearchBarView: UIView {
    
    let textField = UITextField()
    let menuButton = UIButton()
    let searchButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        setupTextField()
        setupButtons()
        
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 1, height: 3)
        layer.shadowRadius = 6
        
        addSubview(textField)
        addSubview(menuButton)
        addSubview(searchButton)
        
        NSLayoutConstraint.activate([
            menuButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            menuButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            menuButton.widthAnchor.constraint(equalToConstant: 30),
            menuButton.heightAnchor.constraint(equalToConstant: 30),
            
            searchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            searchButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 30),
            searchButton.heightAnchor.constraint(equalToConstant: 30),
            
            textField.leadingAnchor.constraint(equalTo: menuButton.trailingAnchor, constant: 5),
            textField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -5),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupTextField() {
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = .clear
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont(name: "Jua-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        textField.attributedPlaceholder = NSAttributedString(
            string: "장소명",
            attributes: [
                .foregroundColor: UIColor.gray,
                .font: font
            ]
        )
    }
    
    private func setupButtons() {
        menuButton.setImage(UIImage(systemName: "storefront"), for: .normal)
        menuButton.tintColor = .mainPink
        
        // 단과대학, 학과 수정 이벤트 액션
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .mainPink
        searchButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // 버튼 클릭 이벤트
    @objc private func menuButtonTapped() {
        if let presentedVC = parentViewController?.presentedViewController as? UserInfoViewController {
            presentedVC.dismiss(animated: true)
        } else {
            let userInfoVC = UserInfoViewController()
            userInfoVC.entryMode = .changeSettings

            let triggerVC = DismissTriggerViewController(modal: userInfoVC)
            triggerVC.modalPresentationStyle = .overFullScreen
            triggerVC.modalTransitionStyle = .crossDissolve

            parentViewController?.present(triggerVC, animated: false)
        }
    }
}

