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
    
    // 할인 정보 입력용 TextView 추가
    private var discountInfoTextView: UITextView?
    private var discountInfoHeightConstraint: NSLayoutConstraint?
    
    // 가게 주소 선택 라벨
    private let addressFieldLabel = UILabel()
    // 할인 대상 선택 라벨
    private let targetFieldLabel = UILabel()
    // 할인 기간 선택 라벨
    private let saleDateFieldLabel = UILabel()
    
    // 로딩 인디케이터
    private var loadingIndicator: UIActivityIndicatorView?
    private var loadingBackgroundView: UIView?
    
    // DatePickerManager 사용
    private var datePickerManager: DatePickerManager?
    
    var onMapButtonTapped: (() -> Void)?
    var onTargetButtonTapped: (() -> Void)?
    var onSaleDateButtonTapped: (() -> Void)?
    
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
        scrollView.bounces = false
        
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
        stackView.addArrangedSubview(makeField(title: "가게 이름", placeholder: "최대한 자세히 입력해주세요! 예) 다사랑치킨피자 원대본점"))
        stackView.addArrangedSubview(makeClickableField(title: "가게 주소", placeholder: "예) 익산시 무왕로 18-1길", label: addressFieldLabel, action: #selector(handleMapButtonTapped)))
        stackView.addArrangedSubview(makeClickableField(title: "할인 대상", placeholder: "예) 창의공과대학 컴퓨터소프트웨어공학과", label: targetFieldLabel, action: #selector(handleTargetButtonTapped)))
        stackView.addArrangedSubview(makeClickableField(title: "할인 기간", placeholder: "예) 6월 1일 ~ 7월 10일", label: saleDateFieldLabel, action: #selector(handleSaleInfoButtonTapped)))
        stackView.addArrangedSubview(makeTextViewField(title: "할인 정보", placeholder: "예) 30,000원 이상 결제 시 10% 할인"))
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
    
    
    // MARK: - 등록 버튼 정의
    private func setupRegisterButton() {
        registerButton.setTitle("등록", for: .normal)
        registerButton.titleLabel?.font = UIFont(name: "Jua-Regular", size: 24)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.backgroundColor = .mainPink
        registerButton.layer.cornerRadius = 15
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onRegisterButtonTapped))
        registerButton.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - 등록 이벤트
    
    // 등록 전 확인
    @objc private func onRegisterButtonTapped() {
        print("등록 버튼이 눌렸어요!")
        
        // 1. 등록 확인 알람 표시
        let confirmAlert = UIAlertController(
            title: "가게 등록",
            message: "정말 등록하시겠습니까?",
            preferredStyle: .alert
        )
        
        // 취소 버튼
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            print("등록 취소됨")
        }
        
        // 확인 버튼
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.performRegistration()
        }
        
        confirmAlert.addAction(cancelAction)
        confirmAlert.addAction(confirmAction)
        
        parentViewController?.present(confirmAlert, animated: true)
    }
    
    // 서버로 POST 요청
    private func performRegistration() {
        // textFields 배열 순서: 가게 이름, 기타 사항, 요청자
        guard textFields.count >= 3 else {
            print("❌ 텍스트필드 수 부족")
            return
        }
        
        // 기본 입력 필드들
        let name = textFields[0].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let etc = textFields[1].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let requester = textFields[2].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        // 할인 정보 (TextView에서 가져오기, 플레이스홀더 체크)
        let saleInfo: String
        if let textView = discountInfoTextView,
           textView.textColor != .gray,
           !textView.text.isEmpty {
            saleInfo = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            saleInfo = ""
        }
        
        // 클릭 가능한 필드들에서 데이터 가져오기
        let address = addressFieldLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let targetText = targetFieldLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let saleDate = saleDateFieldLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        // 필수 필드 검증
        if name.isEmpty {
            showAlert(message: "가게 이름을 입력해주세요")
            return
        }
        
        if address.isEmpty || address.contains("예)") {
            showAlert(message: "가게 주소를 선택해주세요")
            return
        }
        
        if targetText.isEmpty || targetText.contains("예)") {
            showAlert(message: "할인 대상을 선택해주세요")
            return
        }
        
        if saleDate.isEmpty || saleDate.contains("예)") {
            showAlert(message: "할인 기간을 선택해주세요")
            return
        }
        
        if saleInfo.isEmpty {
            showAlert(message: "할인 정보를 입력해주세요")
            return
        }
        
        if requester.isEmpty {
            showAlert(message: "요청자를 입력해주세요")
            return
        }
        
        // partDivision과 partName 분리 로직
        let partDivision: String
        let partName: String
        
        // 먼저 재학생/휴학생 관련 문자열 제거
        let cleanedTargetText = targetText
            .replacingOccurrences(of: " 재학생", with: "")
            .replacingOccurrences(of: " 휴학생", with: "")
            .replacingOccurrences(of: " 재학생/휴학생", with: "")
        
        // 독립학과 처리 (예외 케이스)
        if cleanedTargetText.contains("독립학과") {
            partDivision = "학과"
            partName = cleanedTargetText.replacingOccurrences(of: "독립학과 ", with: "")
        }
        // "전체"가 포함된 경우 단과대학
        else if cleanedTargetText.contains("전체") {
            partDivision = "단과"
            // "전체" 문자열 제거 후 공백으로 분리하여 왼쪽(단과대학명) 추출
            let withoutTotal = cleanedTargetText.replacingOccurrences(of: " 전체", with: "")
            let components = withoutTotal.components(separatedBy: " ")
            partName = components.first ?? withoutTotal
        }
        // 그 외의 경우 학과
        else {
            partDivision = "학과"
            // 공백으로 분리하여 오른쪽(학과명) 추출
            let components = cleanedTargetText.components(separatedBy: " ")
            partName = components.last ?? cleanedTargetText
        }
        
        // saleTarget 생성 (partName + selectedTarget)
        let saleTarget = "\(partName) \(selectedTarget)"
        
        // DTO 생성
        let payload = UploadStoreRequestDTO(
            name: name,
            address: address,
            partDivision: partDivision,
            partName: partName,
            saleTarget: saleTarget,
            saleInfo: saleInfo,
            saleDate: saleDate,
            etc: etc,
            requester: requester
        )
        
        // 로딩 인디케이터 표시
        showLoadingIndicator()
        
        NetworkManager.shared.requestPOST(
            urlString: APIConstants.postStores,
            parameters: payload
        ) { [weak self] (result: Result<UploadStoreResponseDTO, APIError>) in
            DispatchQueue.main.async {
                // 로딩 인디케이터 숨기기
                self?.hideLoadingIndicator()
                self?.handleRegistrationResponse(result: result)
            }
        }
    }
    
    // 서버 응답 처리
    private func handleRegistrationResponse(result: Result<UploadStoreResponseDTO, APIError>) {
        switch result {
        case .success(let response):
            print("서버 응답: \(response)")
            
            switch response.code {
            case 1:
                // 성공 - HomeViewController로 이동
                showSuccessAlert(message: "성공적으로 등록되었어요!") { [weak self] in
                    self?.navigateToHome()
                }
                
            case 2:
                // 중복된 가게 - 알람만 표시
                showAlert(message: "중복된 가게가 있어요!")
                
            case 3:
                // 서버 오류 - 알람만 표시
                showAlert(message: "네트워크 문제 혹은 서버에 문제가 발생했어요!")
                
            default:
                // 예상치 못한 응답 코드
                showAlert(message: "알 수 없는 오류가 발생했어요!")
            }
            
        case .failure(let error):
            print("❌ 등록에 실패했어요. : \(error)")
            showAlert(message: "네트워크 문제 혹은 서버에 문제가 발생했어요!")
        }
    }
    
    // 가게 등록 성공 시
    private func showSuccessAlert(message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            completion()
        }
        alert.addAction(okAction)
        parentViewController?.present(alert, animated: true)
    }
    
    // 홈 VC로 이동
    private func navigateToHome() {
        // 새로운 가게 등록 알림
        NotificationCenter.default.post(name: .didRegisterNewStore, object: nil)
        
        // UIView에서 부모 뷰 컨트롤러 찾기
        guard let parentViewController = self.findViewController() else {
            print("부모 뷰 컨트롤러를 찾을 수 없습니다.")
            return
        }
        
        // MainTabBar의 첫 번째 탭(HomeViewController)으로 이동
        if let tabBarController = parentViewController.tabBarController {
            tabBarController.selectedIndex = 0
            
            // 현재 뷰 컨트롤러를 pop하여 네비게이션 스택에서 제거
            if let navigationController = parentViewController.navigationController {
                navigationController.popViewController(animated: true)
            }
        } else {
            print("TabBarController를 찾을 수 없습니다.")
        }
    }
    
    // UIView에서 부모 VC 찾기
    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            responder = responder?.next
            if let viewController = responder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    // MARK: - 할인 가게 정보 등록 폼 초기화
    private func resetFormData() {
        // 텍스트 필드 초기화 (가게 이름, 기타 사항, 요청자)
        for textField in textFields {
            textField.text = ""
        }
        
        // 클릭 필드들 초기화
        addressFieldLabel.text = "예) 익산시 무왕로 18-1길"
        addressFieldLabel.textColor = .gray
        
        targetFieldLabel.text = "예) 창의공과대학 컴퓨터소프트웨어공학과"
        targetFieldLabel.textColor = .gray
        
        saleDateFieldLabel.text = "예) 6월 1일 ~ 7월 10일"
        saleDateFieldLabel.textColor = .gray
        
        // 할인 정보 초기화
        if let textView = discountInfoTextView {
            textView.text = "예) 30,000원 이상 결제 시 10% 할인"
            textView.textColor = .gray
            
            // TextView 높이도 기본값으로 복원
            discountInfoHeightConstraint?.constant = 42
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        }
        
        // 할인 대상 초기화
        selectedTarget = "재학생"
        updateCheckboxSelection(stack: targetStack, selected: "재학생")
        
        // 키보드 숨기기
        self.endEditing(true)
        
        // 스크롤 위치 맨 위로 이동
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    // MARK: - 필수 입력 필드 검증
    private func showAlert(message: String) {
        guard let parentVC = parentViewController else { return }
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        
        parentVC.present(alert, animated: true)
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
        
        let options = ["재학생", "재학생/휴학생"]
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
    
    // 다중 줄 입력 필드 생성 (TextView)
    private func makeTextViewField(title: String, placeholder: String) -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 6
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: "Jua-Regular", size: 16)
        titleLabel.textColor = .mainPink
        
        let textView = UITextView()
        textView.delegate = self
        textView.font = UIFont(name: "Jua-Regular", size: 13)
        textView.textColor = .black
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.mainPink.cgColor
        textView.layer.cornerRadius = 8
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.returnKeyType = .default
        textView.isScrollEnabled = false
        
        // 기본 높이 설정 (최소 42pt)
        let minHeight: CGFloat = 42
        discountInfoHeightConstraint = textView.heightAnchor.constraint(equalToConstant: minHeight)
        discountInfoHeightConstraint?.isActive = true
        
        // 플레이스홀더 설정
        textView.text = placeholder
        textView.textColor = .gray
        
        discountInfoTextView = textView
        
        container.addArrangedSubview(titleLabel)
        container.addArrangedSubview(textView)
        
        return container
    }
    
    // MARK: - 가게 주소 입력 버튼 클릭 핸들러
    @objc private func handleMapButtonTapped() {
        self.endEditing(true)
        print("가게 주소 입력 버튼 클릭")
        onMapButtonTapped?()
        
        if let presentedVC = parentViewController?.presentedViewController as? SelectAddressViewController {
            presentedVC.dismiss(animated: true)
        } else {
            let selectAddressVC = SelectAddressViewController()
            
            // 콜백 설정
            selectAddressVC.onAddressSelected = { [weak self] selectedAddress in
                // 선택된 주소로 라벨 업데이트
                self?.updateAddressField(with: selectedAddress)
            }
            
            let nav = UINavigationController(rootViewController: selectAddressVC)
            
            let triggerVC = DismissTriggerViewController(modal: nav)
            triggerVC.modalPresentationStyle = .overFullScreen
            triggerVC.modalTransitionStyle = .crossDissolve
            
            parentViewController?.present(triggerVC, animated: false)
        }
    }
    
    // MARK: - 할인 대상 입력 버튼 클릭 핸들러
    @objc private func handleTargetButtonTapped() {
        self.endEditing(true)
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
        self.endEditing(true)
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
                // 다음 필드가 TextView라면 포커스 이동
                discountInfoTextView?.becomeFirstResponder()
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
    
    // MARK: - 로딩 인디케이터 활성화
    private func showLoadingIndicator() {
        // 이미 표시 중이면 리턴
        if loadingBackgroundView != nil { return }
        
        // 백그라운드 뷰 생성
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        // 인디케이터 생성
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        
        // 로딩 텍스트 라벨
        let loadingLabel = UILabel()
        loadingLabel.text = "등록 중..."
        loadingLabel.textColor = .white
        loadingLabel.font = UIFont(name: "Jua-Regular", size: 16)
        loadingLabel.textAlignment = .center
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 뷰 추가
        backgroundView.addSubview(indicator)
        backgroundView.addSubview(loadingLabel)
        self.addSubview(backgroundView)
        
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            indicator.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: -20),
            
            loadingLabel.topAnchor.constraint(equalTo: indicator.bottomAnchor, constant: 16),
            loadingLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ])
        
        // 참조 저장
        loadingIndicator = indicator
        loadingBackgroundView = backgroundView
        
        // 사용자 인터랙션 비활성화
        self.isUserInteractionEnabled = false
    }
    
    // MARK: - 로딩 인디케이터 비활성화
    private func hideLoadingIndicator() {
        loadingIndicator?.stopAnimating()
        loadingBackgroundView?.removeFromSuperview()
        
        loadingIndicator = nil
        loadingBackgroundView = nil
        
        // 사용자 인터랙션 활성화
        self.isUserInteractionEnabled = true
    }
    
}

// MARK: - UITextViewDelegate

extension UploadFormView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.isScrollEnabled = false
        
        // 플레이스홀더 제거
        if textView.textColor == .gray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollView.isScrollEnabled = true
        
        // 빈 텍스트일 경우 플레이스홀더 복원
        if textView.text.isEmpty {
            textView.text = "예) 30,000원 이상 결제 시 10% 할인"
            textView.textColor = .gray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // 텍스트가 변경될 때마다 높이 재계산
        updateTextViewHeight(textView)
    }
    
    private func updateTextViewHeight(_ textView: UITextView) {
        let fixedWidth = textView.frame.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let minHeight: CGFloat = 42
        let newHeight = max(newSize.height, minHeight)
        
        // 높이가 변경되었을 때만 업데이트
        if abs(discountInfoHeightConstraint?.constant ?? 0 - newHeight) > 1 {
            discountInfoHeightConstraint?.constant = newHeight
            
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        }
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
