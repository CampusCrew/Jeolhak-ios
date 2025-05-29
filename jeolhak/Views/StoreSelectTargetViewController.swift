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
    private let divisionLabel = UILabel()
    private let divisionStack = UIStackView()
    private let targetLabel = UILabel()
    private let targetStack = UIStackView()
    private let nextButton = UIButton()

    private let departments: [Department] = allDepartments
    private var selectedDepartmentIndex: Int = 0
    private var selectedMajor: String = ""

    private var selectedDivision: String = "학과"
    private var selectedTarget: String = "재학생"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupLabel()
        setupPicker()
        setupCheckboxes()
        setupButton()

        preferredContentSize = CGSize(width: 360, height: 550)
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
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30)
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
            pickerView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    private func setupCheckboxes() {
        setupSection(label: divisionLabel, title: "구분 선택", stack: divisionStack, options: ["단과", "학과"]) { [weak self] selected in
            self?.selectedDivision = selected
        }

        setupSection(label: targetLabel, title: "대상 선택", stack: targetStack, options: ["재학생", "휴학생", "재학생/휴학생"]) { [weak self] selected in
            self?.selectedTarget = selected
        }

        NSLayoutConstraint.activate([
            divisionLabel.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 10),
            divisionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            divisionStack.topAnchor.constraint(equalTo: divisionLabel.bottomAnchor, constant: 6),
            divisionStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            targetLabel.topAnchor.constraint(equalTo: divisionStack.bottomAnchor, constant: 20),
            targetLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            targetStack.topAnchor.constraint(equalTo: targetLabel.bottomAnchor, constant: 6),
            targetStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupSection(label: UILabel, title: String, stack: UIStackView, options: [String], onSelect: @escaping (String) -> Void) {
        label.text = title
        label.textColor = .mainPink
        label.font = UIFont(name: "Jua-Regular", size: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        stack.axis = .horizontal
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        for option in options {
            let button = createCheckboxButton(title: option)
            button.addAction(UIAction { _ in
                self.updateCheckboxSelection(stack: stack, selected: option)
                onSelect(option)
            }, for: .touchUpInside)
            stack.addArrangedSubview(button)
        }
    }

    private func createCheckboxButton(title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.mainPink, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.titleLabel?.font = UIFont(name: "Jua-Regular", size: 16)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.mainPink.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 6
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        return button
    }

    private func updateCheckboxSelection(stack: UIStackView, selected: String) {
        for case let button as UIButton in stack.arrangedSubviews {
            let isSelected = (button.title(for: .normal) == selected)
            button.isSelected = isSelected
            button.backgroundColor = isSelected ? .mainPink : .white
            button.setTitleColor(isSelected ? .white : .mainPink, for: .normal)
        }
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
            nextButton.topAnchor.constraint(equalTo: targetStack.bottomAnchor, constant: 25),
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - PickerView Delegate/DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 2 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? departments.count : departments[selectedDepartmentIndex].majors.count
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
    @objc private func nextTapped() {
        let selectedDept = departments[selectedDepartmentIndex].departmentName
        let selectedMaj = selectedMajor.isEmpty ? departments[selectedDepartmentIndex].majors[0] : selectedMajor

        let partDivision = selectedDivision
        let partName = (partDivision == "단과") ? selectedDept : selectedMaj
        let saleTarget = "\(partName) \(selectedTarget)"

        let payload: [String: String] = [
            "partDivision": partDivision,
            "partName": partName,
            "saleTarget": saleTarget
        ]

        print("✅ 최종 전송 데이터: \(payload)")
    }
}
