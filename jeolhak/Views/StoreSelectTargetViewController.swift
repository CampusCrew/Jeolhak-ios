//
//  StoreSelectSaleTargetViewViewController.swift
//  jeolhak
//
//  Created by 윤대현 on 5/29/25.
//

import UIKit

// MARK: 할인 대상 선택 PickerView + CardView

class StoreSelectTargetViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    private let titleLabel = UILabel()
    private let pickerView = UIPickerView()
    private let nextButton = UIButton()

    private let departments: [Department] = allDepartments
    private var selectedDepartmentIndex: Int = 0
    private var selectedMajor: String = ""

    private var selectedDivision: String = "학과"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupLabel()
        setupPicker()
        setupButton()

        preferredContentSize = CGSize(width: 360, height: 480)
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersEdgeAttachedInCompactHeight = true
        }
        modalPresentationStyle = .formSheet
    }

    private func setupLabel() {
        titleLabel.text = "단과대학과 학과를 선택해주세요"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .mainPink
        titleLabel.font = UIFont(name: "Jua-Regular", size: 21)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)
        ])
    }

    private func setupPicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickerView)

        NSLayoutConstraint.activate([
            pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            pickerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            pickerView.heightAnchor.constraint(equalToConstant: 280)
        ])
    }

    private func setupButton() {
        nextButton.setTitle("다음", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.backgroundColor = .mainPink
        nextButton.layer.cornerRadius = 20
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)

        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: -10),
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - UIPickerView DataSource & Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return departments.count
        } else {
            return departments[selectedDepartmentIndex].majors.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? departments[row].departmentName : departments[selectedDepartmentIndex].majors[row]
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
        label.text = component == 0 ? departments[row].departmentName : departments[selectedDepartmentIndex].majors[row]
        return label
    }

    // MARK: - Next Button Action
    // 다음 버튼 클릭 시 UploadFormView로 전달
    @objc private func nextTapped() {
        let selectedDept = departments[selectedDepartmentIndex].departmentName
        let selectedMaj = selectedMajor.isEmpty ? departments[selectedDepartmentIndex].majors[0] : selectedMajor
        let result = "\(selectedDept) \(selectedMaj)"

        NotificationCenter.default.post(
            name: .didSelectTarget,
            object: nil,
            userInfo: ["target": result]
        )
        
        // StoreSelectTargetViewController와
        // triggerVC(DismissTriggerViewController)까지 동시에 dismiss
        presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
}
