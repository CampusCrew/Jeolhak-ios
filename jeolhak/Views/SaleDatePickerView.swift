//
//  SaleDatePickerView.swift
//  jeolhak
//
//  Created by 윤대현 on 5/31/25.
//

import UIKit

// MARK: - 할인 정보 등록할 때 사용되는 DatePicker View

class SaleDatePickerViewController: UIViewController {
    
    private let datePicker = UIDatePicker()
    private let confirmButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupDatePicker()
        setupConfirmButton()
        
        preferredContentSize = CGSize(width: 360, height: 300)
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.largestUndimmedDetentIdentifier = .medium
        }
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 30)
        ])
    }
    
    private func setupConfirmButton() {
        confirmButton.setTitle("적용", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.backgroundColor = .mainPink
        confirmButton.layer.cornerRadius = 10
        confirmButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        view.addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            confirmButton.widthAnchor.constraint(equalToConstant: 100),
            confirmButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func confirmTapped() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let selectedDate = formatter.string(from: datePicker.date)

        NotificationCenter.default.post(name: .didSelectSaleDate,
                                        object: nil,
                                        userInfo: ["date": selectedDate])
        
        presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
}
