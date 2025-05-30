//
//  DataPickerManager.swift
//  jeolhak
//
//  Created by 윤대현 on 5/31/25.
//

import UIKit

// 프로토콜 정의
protocol DatePickerManagerDelegate: AnyObject {
    func datePickerManager(_ manager: DatePickerManager, didSelectDateRange startDate: Date, endDate: Date)
    func datePickerManager(_ manager: DatePickerManager, didSelectAlwaysDiscount: String)
    func datePickerManagerDidCancel(_ manager: DatePickerManager)
}

class DatePickerManager {
    
    // MARK: - Properties
    
    weak var delegate: DatePickerManagerDelegate?
    private weak var stackView: UIStackView?
    
    private var datePicker: UIDatePicker?
    private var datePickerContainer: UIView?
    private var instructionLabel: UILabel?
    private var selectionPhase: DateSelectionPhase = .selectingStartDate
    private var selectedStartDate: Date?
    
    // 체크박스 관련 프로퍼티
    private var alwaysDiscountCheckbox: UIButton?
    private var yearEndDiscountCheckbox: UIButton?
    private var selectedCheckboxType: CheckboxType?
    
    enum DateSelectionPhase {
        case selectingStartDate
        case selectingEndDate
    }
    
    enum CheckboxType {
        case alwaysDiscount
        case yearEndDiscount
    }
    
    // MARK: - Initialization
    
    init(stackView: UIStackView) {
        self.stackView = stackView
    }
    
    // MARK: - Public Methods
    
    func showDatePicker() {
        // 이미 DatePicker가 표시되어 있다면 숨기기
        if let container = datePickerContainer {
            hideDatePicker()
            return
        }
        
        createDatePickerContainer()
        insertDatePickerIntoStackView()
        animateShowDatePicker()
        
        // 추가: DatePicker가 보일 때 아이콘을 filled로 변경
        if let stackView = stackView {
            updateCalendarIcon(in: stackView, isFilled: true)
        }
    }
    
    func hideDatePicker() {
        guard let container = datePickerContainer else { return }
        
        UIView.animate(withDuration: 0.25, animations: {
            container.alpha = 0
        }, completion: { _ in
            self.removeDatePickerFromStackView()
            self.resetDatePickerState()
            
            // 추가: DatePicker가 숨겨질 때 아이콘을 일반으로 변경
            if let stackView = self.stackView {
                self.updateCalendarIcon(in: stackView, isFilled: false)
            }
            
            self.delegate?.datePickerManagerDidCancel(self)
        })
    }
    
    func updateCalendarIcon(in stackView: UIStackView, isFilled: Bool) {
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        let iconName = isFilled ? "calendar.circle.fill" : "calendar.circle"
        
        if let container = stackView.arrangedSubviews.first(where: { view in
            if let stack = view as? UIStackView,
               let title = (stack.arrangedSubviews.first as? UILabel)?.text {
                return title == "할인 기간"
            }
            return false
        }) as? UIStackView,
           let clickable = container.arrangedSubviews.last,
           let icon = clickable.subviews.first(where: { $0 is UIImageView }) as? UIImageView {
            icon.image = UIImage(systemName: iconName, withConfiguration: config)
        }
    }
    
    // MARK: - Private Methods
    
    private func createDatePickerContainer() {
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 8
        container.translatesAutoresizingMaskIntoConstraints = false
        container.alpha = 0
        self.datePickerContainer = container
        
        let label = UILabel()
        label.text = "할인 시작일을 선택하세요."
        label.font = UIFont(name: "Jua-Regular", size: 16)
        label.textColor = .mainPink
        self.instructionLabel = label
        
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.locale = Locale(identifier: "ko_KR")
        picker.tintColor = .mainPink
        picker.layer.cornerRadius = 8
        picker.clipsToBounds = true
        picker.layer.borderColor = UIColor.mainPink.cgColor
        picker.layer.borderWidth = 1
        picker.translatesAutoresizingMaskIntoConstraints = false
        self.datePicker = picker
        
        let nextButton = UIButton(type: .system)
        nextButton.setTitle("다음", for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "Jua-Regular", size: 16)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.backgroundColor = .mainPink
        nextButton.layer.cornerRadius = 6
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nextButton.addTarget(self, action: #selector(nextDateSelectionStep), for: .touchUpInside)
        
        // 체크박스 컨테이너 생성
        let checkboxContainer = createCheckboxContainer()
        
        let stack = UIStackView(arrangedSubviews: [label, picker, nextButton, checkboxContainer])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
        ])
        
        // nextButton과 checkboxContainer 사이 간격 설정
        stack.setCustomSpacing(10, after: nextButton)
    }
    
    private func createCheckboxContainer() -> UIView {
        let container = UIView()
        
        // 올해 말까지 체크박스
        let yearEndDiscountCheckbox = createCheckbox(title: "오늘부터 이번년도 말일까지", type: .yearEndDiscount)
        self.yearEndDiscountCheckbox = yearEndDiscountCheckbox
        
        // 상시 할인 체크박스
        let alwaysDiscountCheckbox = createCheckbox(title: "상시 할인", type: .alwaysDiscount)
        self.alwaysDiscountCheckbox = alwaysDiscountCheckbox
        
        
        
        let checkboxStack = UIStackView(arrangedSubviews: [yearEndDiscountCheckbox, alwaysDiscountCheckbox])
        checkboxStack.axis = .vertical
        checkboxStack.spacing = 8
        checkboxStack.alignment = .leading
        checkboxStack.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(checkboxStack)
        NSLayoutConstraint.activate([
            checkboxStack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            checkboxStack.topAnchor.constraint(equalTo: container.topAnchor),
            checkboxStack.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    private func createCheckbox(title: String, type: CheckboxType) -> UIButton {
        let button = UIButton(type: .custom)
        
        // Configuration 사용 (iOS 15+)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.title = title
            config.baseForegroundColor = .mainPink
            config.imagePadding = 10 // 체크박스와 텍스트 사이 간격
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            // 폰트 설정을 configuration에서 직접 설정
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont(name: "Jua-Regular", size: 16)
                return outgoing
            }
            
            button.configuration = config
        } else {
            // 기존 방식 (iOS 15 미만)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.mainPink, for: .normal)
            button.titleLabel?.font = UIFont(name: "Jua-Regular", size: 16)
            button.contentHorizontalAlignment = .leading
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // 체크박스 이미지 설정
        updateCheckboxImage(button: button, isSelected: false)
        
        // 타겟 설정
        button.addTarget(self, action: #selector(checkboxTapped(_:)), for: .touchUpInside)
        button.tag = type == .alwaysDiscount ? 0 : 1
        
        return button
    }
    
    private func updateCheckboxImage(button: UIButton, isSelected: Bool) {
        let checkboxSize: CGFloat = 20
        let checkboxImage: UIImage
        
        if isSelected {
            // 선택된 상태: 배경이 mainPink인 사각형
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: checkboxSize, height: checkboxSize))
            checkboxImage = renderer.image { context in
                UIColor.mainPink.setFill()
                context.fill(CGRect(x: 0, y: 0, width: checkboxSize, height: checkboxSize))
                
                // 체크 표시
                UIColor.white.setStroke()
                let checkPath = UIBezierPath()
                checkPath.move(to: CGPoint(x: 4, y: 10))
                checkPath.addLine(to: CGPoint(x: 8, y: 14))
                checkPath.addLine(to: CGPoint(x: 16, y: 6))
                checkPath.lineWidth = 2
                checkPath.stroke()
            }
        } else {
            // 선택되지 않은 상태: 테두리만 mainPink인 사각형
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: checkboxSize, height: checkboxSize))
            checkboxImage = renderer.image { context in
                UIColor.mainPink.setStroke()
                let rect = CGRect(x: 1, y: 1, width: checkboxSize-2, height: checkboxSize-2)
                context.stroke(rect)
            }
        }
        
        button.setImage(checkboxImage, for: .normal)
    }
    
    @objc private func checkboxTapped(_ sender: UIButton) {
        let tappedType: CheckboxType = sender.tag == 0 ? .alwaysDiscount : .yearEndDiscount
        
        // 이전 선택 해제
        if let previousType = selectedCheckboxType {
            let previousButton = previousType == .alwaysDiscount ? alwaysDiscountCheckbox : yearEndDiscountCheckbox
            updateCheckboxImage(button: previousButton!, isSelected: false)
        }
        
        // 같은 체크박스를 다시 누른 경우 선택 해제
        if selectedCheckboxType == tappedType {
            selectedCheckboxType = nil
        } else {
            // 새로운 체크박스 선택
            selectedCheckboxType = tappedType
            updateCheckboxImage(button: sender, isSelected: true)
        }
    }
    
    private func insertDatePickerIntoStackView() {
        guard let stackView = stackView, let container = datePickerContainer else { return }
        
        if let index = stackView.arrangedSubviews.firstIndex(where: {
            ($0 as? UIStackView)?.arrangedSubviews.first(where: {
                ($0 as? UILabel)?.text == "할인 기간"
            }) != nil
        }) {
            stackView.insertArrangedSubview(container, at: index + 1)
        } else {
            stackView.addArrangedSubview(container)
        }
    }
    
    private func animateShowDatePicker() {
        guard let container = datePickerContainer else { return }
        
        UIView.animate(withDuration: 0.25) {
            container.alpha = 1
        }
    }
    
    private func removeDatePickerFromStackView() {
        guard let stackView = stackView, let container = datePickerContainer else { return }
        
        stackView.removeArrangedSubview(container)
        container.removeFromSuperview()
    }
    
    private func resetDatePickerState() {
        self.datePickerContainer = nil
        self.datePicker = nil
        self.instructionLabel = nil
        self.selectionPhase = .selectingStartDate
        self.selectedStartDate = nil
        self.selectedCheckboxType = nil
        self.alwaysDiscountCheckbox = nil
        self.yearEndDiscountCheckbox = nil
    }
    
    @objc private func nextDateSelectionStep() {
        // 체크박스가 선택된 경우 처리
        if let checkboxType = selectedCheckboxType {
            switch checkboxType {
            case .alwaysDiscount:
                delegate?.datePickerManager(self, didSelectAlwaysDiscount: "상시")
                
            case .yearEndDiscount:
                let today = Date()
                let calendar = Calendar.current
                let year = calendar.component(.year, from: today)
                let yearEnd = calendar.date(from: DateComponents(year: year, month: 12, day: 31))!
                
                delegate?.datePickerManager(self, didSelectDateRange: today, endDate: yearEnd)
            }
            
            // DatePicker 숨기기
            UIView.animate(withDuration: 0.25, animations: {
                self.datePickerContainer?.alpha = 0
            }, completion: { _ in
                self.removeDatePickerFromStackView()
                self.resetDatePickerState()
                
                if let stackView = self.stackView {
                    self.updateCalendarIcon(in: stackView, isFilled: false)
                }
            })
            return
        }
        
        // 기존 DatePicker 로직
        guard let picker = self.datePicker, let label = instructionLabel else { return }
        
        switch selectionPhase {
        case .selectingStartDate:
            selectedStartDate = picker.date
            selectionPhase = .selectingEndDate
            label.text = "할인 종료일을 선택하세요"
            picker.minimumDate = picker.date
            
        case .selectingEndDate:
            guard let start = selectedStartDate else { return }
            let end = picker.date
            
            if end >= start {
                // 성공적으로 날짜 범위 선택 완료
                delegate?.datePickerManager(self, didSelectDateRange: start, endDate: end)
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.datePickerContainer?.alpha = 0
                }, completion: { _ in
                    self.removeDatePickerFromStackView()
                    self.resetDatePickerState()
                    
                    if let stackView = self.stackView {
                        self.updateCalendarIcon(in: stackView, isFilled: false)
                    }
                })
            } else {
                label.text = "시작일 이후의 날짜를 선택하세요"
                label.textColor = .systemRed
            }
        }
    }
}
