//
//  HomeViewController.swift
//  jeolhak
//
//  Created by 윤대현 on 3/27/25.
//

import UIKit

// MARK: - 할인 가게 등록 페이지

class UploadViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    private func setupLayout() {
        let titleLabel = UILabel()
        titleLabel.text = "할인 정보 등록"
        titleLabel.font = UIFont(name: "Jua-Regular", size: 24)
        titleLabel.textColor = .mainPink
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let formView = UploadFormView()
        formView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(formView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            formView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            formView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            formView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
}
