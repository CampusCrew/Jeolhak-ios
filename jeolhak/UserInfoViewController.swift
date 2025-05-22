//
//  UserInfoViewController.swift
//  jeolhak
//
//  Created by 윤대현 on 5/22/25.
//

import UIKit

class UserInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private let titleLabel = UILabel()
    private let pickerView = UIPickerView()
    private let nextButton = UIButton()
    
    // MARK: - DepartmentModal 불러오기
    private let departments: [Department] = allDepartments
    private var selectedDepartmentIndex: Int = 0
    private var selectedMajor: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLabel()
        setupPicker()
        setupButton()
        
        //        print("Departments loaded: \(departments.count)")
        //            if let first = departments.first {
        //                print("First department: \(first.departmentName), Majors: \(first.majors.count)")
        //            }
    }
    
    // MARK: - UI 구성
    private func setupLabel() {
        titleLabel.text = "단과대학과 학과를 선택해주세요"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .mainPink
        titleLabel.font = UIFont(name: "Jua-Regular", size: 21)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200)
        ])
    }
    
    private func setupPicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickerView)
        
        NSLayoutConstraint.activate([
            pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pickerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            pickerView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setupButton() {
        nextButton.setTitle("다음", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.backgroundColor = .mainPink
        nextButton.layer.cornerRadius = 20
        nextButton.layer.shadowColor = UIColor.black.cgColor
        nextButton.layer.shadowOpacity = 0.2
        nextButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        nextButton.layer.shadowRadius = 5
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)
        
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 40),
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - PickerView Delegate, DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 // 단과대학 + 학과
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? departments.count : departments[selectedDepartmentIndex].majors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0
        ? departments[row].departmentName
        : departments[selectedDepartmentIndex].majors[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedDepartmentIndex = row
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            selectedMajor = departments[selectedDepartmentIndex].majors[0]
        } else {
            selectedMajor = departments[selectedDepartmentIndex].majors[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        
        label.textAlignment = .center
        label.textColor = .mainPink
        label.font = UIFont(name: "Jua-Regular", size: 16)

        label.text = component == 0
            ? departments[row].departmentName
            : departments[selectedDepartmentIndex].majors[row]
        
        return label
    }
    
    // MARK: - 다음 버튼 액션
    @objc private func nextTapped() {
        let selectedDept = departments[selectedDepartmentIndex].departmentName
        let selectedMaj = selectedMajor.isEmpty ? departments[selectedDepartmentIndex].majors[0] : selectedMajor
        
        // "전체" 키워드 문자열 판별
        let finalDept = selectedDept.contains("전체") ? "" : selectedDept
        let finalMaj = selectedDept.contains("전체") ? "" : selectedMaj
        
        
        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        UserDefaults.standard.set(selectedDept, forKey: "department")
        UserDefaults.standard.set(selectedMaj, forKey: "major")
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let mainTabBarController = MainTabBarController()
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                window.rootViewController = mainTabBarController
            }, completion: nil)
        }
    }
}
