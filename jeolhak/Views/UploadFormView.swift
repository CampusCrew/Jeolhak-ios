//
//  UploadFormView.swift
//  jeolhak
//
//  Created by 윤대현 on 5/28/25.
//

import UIKit

// MARK: - 할인 가게 등록 폼

class UploadFormView: UIView, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()
    
    private let registerButton = UIButton(type: .system)
    private let targetLabel = UILabel()
    private let targetStack = UIStackView()
    private var selectedTarget: String = "재학생"
    private var textFields: [UITextField] = []
    
    // 가게 주소 선택 라벨
    private let addressFieldLabel = UILabel()
    // 할인 대상 선택 라벨
    private let targetFieldLabel = UILabel()
    // 할인 기간 선택 라벨
    private let saleDateFieldLabel = UILabel()
    
    // DatePickerManager 사용
    private var datePickerManager: DatePickerManager?
    
    var onMapButtonTapped: (() -> Void)?
    var onTargetButtonTapped: (() -> Void)?
    var onSaleDateButtonTapped: (() -> Void)?
    var onRegisterButtonTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 할인 대상 수신
        NotificationCenter.default.addObserver(self, selector: #selector(handleTargetSelected(_:)), name: .didSelectTarget, object: nil)
        // 할인 기간 수신
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSaleDateSelected(_:)),
            name: .didSelectSaleDate,
            object: nil
        )
        
        setupLayout()
        setupDismissKeyboardGesture()
        setupKeyboardNotifications()
        setupDatePickerManager()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - DatePickerManager Setup
    
    private func setupDatePickerManager() {
        datePickerManager = DatePickerManager(stackView: stackView)
        datePickerManager?.delegate = self
    }
    
    // MARK: - Notification Handler
    
    // 할인 대상 수신 핸들러
    @objc private func handleTargetSelected(_ notification: Notification) {
        if let target = notification.userInfo?["target"] as? String {
            updateTargetField(with: target)
        }
    }
    
    // 할인 기간 수신 핸들러
    @objc private func handleSaleDateSelected(_ notification: Notification) {
        if let date = notification.userInfo?["date"] as? String {
            updateSaleDateField(with: date)
        }
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        setupRegisterButton()
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        // Add fields
        stackView.addArrangedSubview(makeField(title: "가게 이름", placeholder: "예) 모쿠모쿠"))
        stackView.addArrangedSubview(makeClickableField(title: "가게 주소", placeholder: "예) 익산시 무왕로 18-1길", label: addressFieldLabel, action: #selector(handleMapButtonTapped)))
        stackView.addArrangedSubview(makeClickableField(title: "할인 대상", placeholder: "예) 창의공과대학 컴퓨터소프트웨어공학과", label: targetFieldLabel, action: #selector(handleTargetButtonTapped)))
        stackView.addArrangedSubview(makeClickableField(title: "할인 기간", placeholder: "예) 6월 1일 ~ 7월 10일", label: saleDateFieldLabel, action: #selector(handleSaleInfoButtonTapped)))
        stackView.addArrangedSubview(makeField(title: "할인 정보", placeholder: "예) 30,000원 이상 결제 시 10% 할인"))
        stackView.addArrangedSubview(makeField(title: "기타 사항", placeholder: "예) 클리커 지참 필수"))
        stackView.addArrangedSubview(makeField(title: "요청자", placeholder: "예) 컴퓨터소프트웨어공학과 학생회"))
        
        setupTargetSelection()
        
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.heightAnchor.constraint(equalToConstant: 13).isActive = true
        stackView.addArrangedSubview(spacer)
        
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        stackView.addArrangedSubview(registerButton)
    }
    
    // MARK: - Custom Fields
    
    private func makeClickableField(title: String, placeholder: String, label: UILabel, action: Selector) -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 6
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: "Jua-Regular", size: 16)
        titleLabel.textColor = .mainPink
        
        let clickableView = UIView()
        clickableView.layer.borderWidth = 1
        clickableView.layer.borderColor = UIColor.mainPink.cgColor
        clickableView.layer.cornerRadius = 8
        clickableView.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        label.text = placeholder
        label.font = UIFont(name: "Jua-Regular", size: 13)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView()
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.tintColor = .mainPink
        iconImageView.contentMode = .scaleAspectFit
        
        let iconName: String
        switch title {
        case "가게 주소": iconName = "map"
        case "할인 대상": iconName = "graduationcap"
        case "할인 기간": iconName = "calendar.circle"
        default: iconName = "chevron.right"
        }
        
        iconImageView.image = UIImage(systemName: iconName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
        
        clickableView.addSubview(label)
        clickableView.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: clickableView.leadingAnchor, constant: 8),
            label.centerYAnchor.constraint(equalTo: clickableView.centerYAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: iconImageView.leadingAnchor, constant: -8),
            
            iconImageView.trailingAnchor.constraint(equalTo: clickableView.trailingAnchor, constant: -12),
            iconImageView.centerYAnchor.constraint(equalTo: clickableView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        clickableView.addGestureRecognizer(tapGesture)
        
        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(clickableView)
        
        return container
    }
    
    // MARK: - Update Methods
    
    func updateTargetField(with text: String) {
        targetFieldLabel.text = text
        targetFieldLabel.textColor = .black
    }
    
    func updateAddressField(with text: String) {
        addressFieldLabel.text = text
        addressFieldLabel.textColor = .black
    }
    
    func updateSaleDateField(with text: String) {
        saleDateFieldLabel.text = text
        saleDateFieldLabel.textColor = .black
    }
    
    private func setupRegisterButton() {
        registerButton.setTitle("등록", for: .normal)
        registerButton.titleLabel?.font = UIFont(name: "Jua-Regular", size: 24)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.backgroundColor = .mainPink
        registerButton.layer.cornerRadius = 15
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        registerButton.addAction(UIAction { _ in
            self.onRegisterButtonTapped?()
        }, for: .touchUpInside)
    }
    
    private func setupTargetSelection() {
        let targetContainer = UIView()
        targetContainer.translatesAutoresizingMaskIntoConstraints = false
        
        targetLabel.text = "대상 선택"
        targetLabel.textColor = .mainPink
        targetLabel.font = UIFont(name: "Jua-Regular", size: 16)
        targetLabel.textAlignment = .center
        targetLabel.translatesAutoresizingMaskIntoConstraints = false
        
        targetStack.axis = .horizontal
        targetStack.spacing = 20
        targetStack.alignment = .center
        targetStack.translatesAutoresizingMaskIntoConstraints = false
        
        targetContainer.addSubview(targetLabel)
        targetContainer.addSubview(targetStack)
        
        let options = ["재학생", "휴학생"]
        for option in options {
            let button = createCheckboxButton(title: option)
            button.addAction(UIAction { _ in
                self.updateCheckboxSelection(stack: self.targetStack, selected: option)
                self.selectedTarget = option
            }, for: .touchUpInside)
            targetStack.addArrangedSubview(button)
        }
        
        if let firstButton = targetStack.arrangedSubviews.first as? UIButton {
            firstButton.isSelected = true
            firstButton.backgroundColor = .mainPink
            firstButton.setTitleColor(.white, for: .normal)
        }
        
        NSLayoutConstraint.activate([
            targetLabel.topAnchor.constraint(equalTo: targetContainer.topAnchor),
            targetLabel.centerXAnchor.constraint(equalTo: targetContainer.centerXAnchor),
            
            targetStack.topAnchor.constraint(equalTo: targetLabel.bottomAnchor, constant: 13),
            targetStack.centerXAnchor.constraint(equalTo: targetContainer.centerXAnchor),
            targetStack.bottomAnchor.constraint(equalTo: targetContainer.bottomAnchor)
        ])
        
        stackView.addArrangedSubview(targetContainer)
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
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        scrollView.contentInset.bottom = keyboardFrame.height + 20
        
        DispatchQueue.main.async {
            if let currentField = self.findFirstResponder(in: self) as? UIView {
                let fieldFrame = currentField.convert(currentField.bounds, to: self.scrollView)
                self.scrollView.scrollRectToVisible(fieldFrame.insetBy(dx: 0, dy: -20), animated: true)
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
    
    private func findFirstResponder(in view: UIView) -> UIResponder? {
        for subview in view.subviews {
            if subview.isFirstResponder {
                return subview
            } else if let responder = findFirstResponder(in: subview) {
                return responder
            }
        }
        return nil
    }
    
    // 입력 필드 생성 (텍스트필드)
    private func makeField(title: String, placeholder: String) -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 6
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: "Jua-Regular", size: 16)
        titleLabel.textColor = .mainPink
        
        let textField = UITextField()
        textField.delegate = self
        textField.font = UIFont(name: "Jua-Regular", size: 13)
        textField.textColor = .black
        textField.borderStyle = .none
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.mainPink.cgColor
        textField.layer.cornerRadius = 8
        textField.setLeftPaddingPoints(8)
        textField.heightAnchor.constraint(equalToConstant: 42).isActive = true
        textField.returnKeyType = .next
        
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor.gray,
                .font: UIFont(name: "Jua-Regular", size: 13)!
            ]
        )
        
        textFields.append(textField)
        
        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(textField)
        
        return container
    }
    
    // MARK: - 가게 주소 입력 버튼 클릭 핸들러
    @objc private func handleMapButtonTapped() {
        print("가게 주소 입력 버튼 클릭")
        onMapButtonTapped?()
    }
    
    // MARK: - 할인 대상 입력 버튼 클릭 핸들러
    @objc private func handleTargetButtonTapped() {
        print("할인 대상 입력 버튼 클릭")
        if let presentedVC = parentViewController?.presentedViewController as? StoreSelectTargetViewController {
            presentedVC.dismiss(animated: true)
        } else {
            let storeSelectTargetVC = StoreSelectTargetViewController()
            
            let triggerVC = DismissTriggerViewController(modal: storeSelectTargetVC)
            triggerVC.modalPresentationStyle = .overFullScreen
            triggerVC.modalTransitionStyle = .crossDissolve
            
            // StoreSelectTargetViewController를
            // DismissTriggerViewController위에 올리기. 즉, 같이 올라감
            parentViewController?.present(triggerVC, animated: false)
        }
    }
    
    // MARK: - 할인 기간 입력 버튼 클릭 핸들러 (DatePickerManager 사용)
    @objc private func handleSaleInfoButtonTapped() {
        print("할인 기간 입력 버튼 클릭")
        datePickerManager?.showDatePicker()
    }
    
    // MARK: - 텍스트 필드 처리
    
    // 키보드 엔터 처리
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let index = textFields.firstIndex(of: textField) {
            let nextIndex = index + 1
            if nextIndex < textFields.count {
                textFields[nextIndex].becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        }
        return true
    }
    
    // 선택된 대상 값을 가져오는 메서드
    func getSelectedTarget() -> String {
        return selectedTarget
    }
    
    // 텍스트 필드 포커싱 했을 시 스크롤 금지
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.isScrollEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.isScrollEnabled = true
    }
    
    // MARK: - 외부 탭 시 발생하는 이벤트 처리
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        // 위임
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        self.endEditing(true)
    }

}

// MARK: - DatePickerManagerDelegate

extension UploadFormView: DatePickerManagerDelegate {
    
    func datePickerManager(_ manager: DatePickerManager, didSelectDateRange startDate: Date, endDate: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let dateRangeText = "\(formatter.string(from: startDate))~\(formatter.string(from: endDate))"
        
        updateSaleDateField(with: dateRangeText)
    }
    
    func datePickerManager(_ manager: DatePickerManager, didSelectAlwaysDiscount: String) {
        updateSaleDateField(with: didSelectAlwaysDiscount)
    }
    
    func datePickerManagerDidCancel(_ manager: DatePickerManager) {
    }
}

// MARK: - 텍스트 필드 내부 패딩 설정

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(
            frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height)
        )
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(
            frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height)
        )
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
