//
//  HomeViewController.swift
//  jeolhak
//
//  Created by 윤대현 on 3/27/25.
//

import UIKit

class NotificationViewController: UIViewController {
    
    private var dateView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateView = NotificationValueView(image: "star", content: "새로운 가게가 등록되었습니다.")
        
        view.addSubview(dateView)
    }
}
