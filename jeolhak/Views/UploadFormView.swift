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
            makeField(title: "할인 대상", placeholder: "예) 원대 학생증 소지자"),
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
        
        let textField = UITextField()
        textField.delegate = self
        textField.font = UIFont(name: "Jua-Regular", size: 16)
        textField.textColor = .black
        textField.borderStyle = .none
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.mainPink.cgColor
        textField.layer.cornerRadius = 8
        textField.setLeftPaddingPoints(12)
        textField.setRightPaddingPoints(12)
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textField.returnKeyType = .next
        
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor.gray,
                .font: UIFont(name: "Jua-Regular", size: 16)!
            ]
        )
        
        textFields.append(textField)
        
        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(textField)
        
        return container
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
