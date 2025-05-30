//
//  Notification.swift
//  jeolhak
//
//  Created by 윤대현 on 5/27/25.
//

import Foundation

// MARK: - 알람 센터 정의

extension Notification.Name {
    // 카드뷰 닫힘 감지
    static let didCloseCardView = Notification.Name("didCloseCardView")
    
    // 단과, 학과 변경 감지
    static let didUpdateUserSelection = Notification.Name("didUpdateUserSelection")
    
    // FCM 알람 수신 감지
    static let didReceivePushNotification = Notification.Name("didReceivePushNotification")
    
    // 할인 가게 등록 뷰에서, 단과 및 학과 수신 감지
    static let didSelectTarget = Notification.Name("didSelectTarget")
    
    // 할인 기간 선택 뷰에서, 할인 기간 수신 감지
    static let didSelectSaleDate = Notification.Name("didSelectSaleDate")
}
