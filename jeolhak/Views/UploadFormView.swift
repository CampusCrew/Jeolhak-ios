//
//  UploadFormView.swift
//  jeolhak
//
//  Created by 윤대현 on 5/28/25.
//

import UIKit

// MARK: - 할인 가게 등록 폼

class UploadFormView: UIView, UITextFieldDelegate {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()
    
    // 텍스트 필드 배열
    private var textFields: [UITextField] = []
    
    // 가게 주소 입력 버튼 콜백
    var onMapButtonTapped: (() -> Void)?
    // 할인 대상 입력 버튼 콜백
    var onTargetButtonTapped: (() -> Void)?
    // 할인 기간 입력 버튼 콜백
    var onSaleDateButtonTapped: (() -> Void)?
    
    // 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupDismissKeyboardGesture()
        setupKeyboardNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UI 구성 및 배치
    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
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
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        [
            makeField(title: "가게 이름", placeholder: "예) 모쿠모쿠"),
            makeField(title: "가게 주소", placeholder: "예) 익산시 무왕로 18-1길"),
            makeField(title: "할인 대상", placeholder: "예) 창의공과대학 컴퓨터소프트웨어공학과"),
            makeField(title: "할인 정보", placeholder: "예) 30,000원 이상 결제 시 10% 할인"),
            makeField(title: "할인 기간", placeholder: "예) 6월 1일 ~ 7월 10일"),
            makeField(title: "기타 사항", placeholder: "예) 클리커 지참 필수"),
            makeField(title: "가게 이미지", placeholder: "예) 추후 추가 예정")
        ].forEach { stackView.addArrangedSubview($0) }
    }
    
    // 키보드 외 터치 시 해제
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        self.endEditing(true)
    }
    
    // 키보드 알림 등록
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 키보드 등장 시 인셋 및 스크롤 처리
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
    
    // 현재 포커스된 텍스트필드 탐색
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
    
    // 입력 필드 생성
    private func makeField(title: String, placeholder: String) -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 6
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: "Jua-Regular", size: 16)
        titleLabel.textColor = .mainPink
        
        // 가로 배치
        let fieldRow = UIStackView()
        fieldRow.axis = .horizontal // 수평 배치 (왼쪽에서 오른쪽으로 순서대로 arrangedSubView 배치)
        fieldRow.spacing = 8 // arrangedSubView 사이의 간격
        fieldRow.alignment = .fill // arrangedSubView의 높이 맞추기
        
        let textField = UITextField()
        textField.delegate = self
        textField.font = UIFont(name: "Jua-Regular", size: 13)
        textField.textColor = .black
        textField.borderStyle = .none
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.mainPink.cgColor
        textField.layer.cornerRadius = 8
        textField.setLeftPaddingPoints(8)
        textField.setRightPaddingPoints(8)
        textField.heightAnchor.constraint(equalToConstant: 42).isActive = true // 제약조건 추가
        textField.returnKeyType = .next
        
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor.gray,
                .font: UIFont(name: "Jua-Regular", size: 13)!
            ]
        )
        
        textFields.append(textField)
        
        if title == "가게 주소" {
            // 가게 주소 입력 버튼 추가
            let mapButton = UIButton(type: .system)
            let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
            let icon = UIImage(systemName: "map", withConfiguration: config)
            mapButton.setImage(icon, for: .normal)
            mapButton.tintColor = .mainPink
            mapButton.addTarget(self, action: #selector(handleMapButtonTapped), for: .touchUpInside)
            mapButton.widthAnchor.constraint(equalToConstant: 36).isActive = true // 제약조건 추가
            
            fieldRow.addArrangedSubview(textField) // 수평, 좌측 배치
            fieldRow.addArrangedSubview(mapButton) // 수평, 우측 배치
        } else if title == "할인 대상"{
            // 할인 대상 입력 버튼 추가
            let capButton = UIButton(type: .system)
            let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
            let icon = UIImage(systemName: "graduationcap", withConfiguration: config)
            capButton.setImage(icon, for: .normal)
            capButton.tintColor = .mainPink
            capButton.addTarget(self, action: #selector(handleTargetButtonTapped), for: .touchUpInside)
            capButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
            
            fieldRow.addArrangedSubview(textField)
            fieldRow.addArrangedSubview(capButton)
        } else if title == "할인 기간" {
            let calendarButton = UIButton(type: .system)
            let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
            let icon = UIImage(systemName: "calendar", withConfiguration: config)
            calendarButton.setImage(icon, for: .normal)
            calendarButton.tintColor = .mainPink
            calendarButton.addTarget(self, action: #selector(handleSaleInfoButtonTapped), for: .touchUpInside)
            calendarButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
            
            fieldRow.addArrangedSubview(textField)
            fieldRow.addArrangedSubview(calendarButton)
        } else {
            fieldRow.addArrangedSubview(textField)
        }
        
        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(fieldRow)
        
        return container
    }
    
    // 가게 주소 입력 버튼 클릭 핸들러
    @objc private func handleMapButtonTapped() {
        print("가게 주소 입력 버튼 클릭")
        onMapButtonTapped?()
    }
    
    // 할인 대상 입력 버튼 클릭 핸들러
    @objc private func handleTargetButtonTapped() {
        print("할인 대상 입력 버튼 클릭")
        onTargetButtonTapped?()
    }
    
    // 할인 기간 입력 버튼 클릭 핸들러
    @objc private func handleSaleInfoButtonTapped() {
        print("할인 기간 입력 버튼 클릭")
        onSaleDateButtonTapped?()
    }
    
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
