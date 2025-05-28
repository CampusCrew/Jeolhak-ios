//
//  StoreViewController.swift
//  jeolhak
//
//  Created by 윤대현 on 5/27/25.
//

import UIKit

// MARK: - 개별 가게 상세 페이지

class StoreViewController: UIViewController {
    
    // 가게 정보
    private var store: Store!
    
    // 초기화
    init(store: Store) {
        super.init(nibName: nil, bundle: nil)
        self.store = store
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "할인 상세 정보"
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.mainPink,
            .font: UIFont(name: "Jua-Regular", size: 18)!
        ]
        
        self.navigationController?.navigationBar.tintColor = .mainPink
        self.navigationItem.backButtonTitle = ""
        
        let detailView = StoreDetailView(store: store)
        view.addSubview(detailView)
        
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
