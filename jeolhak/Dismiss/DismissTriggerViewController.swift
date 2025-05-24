//
//  DismissTriggerViewController.swift
//  jeolhak
//
//  Created by 윤대현 on 5/24/25.
//

import UIKit

// MARK: - 모달을 위한 임시 ViewController
// 모달을 출력했을 때 호출하는 VC를 Naver Map View가 가리고 있기에 활용한다.
class DismissTriggerViewController: UIViewController {
    
    private let modalToPresent: UIViewController
    
    init(modal: UIViewController) {
        self.modalToPresent = modal
        super.init(nibName: nil, bundle: nil)
        
        modalToPresent.modalPresentationStyle = .formSheet
        modalToPresent.isModalInPresentation = false
        modalToPresent.presentationController?.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        present(modalToPresent, animated: true, completion: nil)
    }
    
    @objc private func backgroundTapped() {
        if let presentedVC = self.presentedViewController {
            presentedVC.dismiss(animated: true) {
                self.dismiss(animated: true)
            }
        } else {
            self.dismiss(animated: true)
        }
    }
    
    @objc private func dismissSelf() {
        self.dismiss(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension DismissTriggerViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.dismiss(animated: true)
    }
}
