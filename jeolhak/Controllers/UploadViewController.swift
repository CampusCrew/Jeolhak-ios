//
//  HomeViewController.swift
//  jeolhak
//
//  Created by 윤대현 on 3/27/25.
//

import UIKit

class UploadViewController: UIViewController {
    
    override func viewDidLoad() {
        view.backgroundColor = .clear
        
        // 상단 제목
        let title = setTitle()
        view.addSubview(title)
        
        // 하단 입력 컨테이너
    }
    
    // 상단 타이틀 정의
    private func setTitle() -> UIView {
        let label = UILabel()
        label.text = "할인 매장 등록"
        label.font = UIFont(name: "Jua-Reqular", size: 24)
        label.textColor = .mainPink
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
}
