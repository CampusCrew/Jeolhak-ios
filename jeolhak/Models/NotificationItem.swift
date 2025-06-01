//
//  NotificationItem.swift
//  jeolhak
//
//  Created by 윤대현 on 6/1/25.
//

import UIKit
import FirebaseMessaging

// MARK: - 알림 데이터 모델
struct NotificationItem: Codable {
    let id: String
    let image: String
    let content: String
    let timestamp: String
    
    init(image: String, content: String, date: String) {
        self.id = UUID().uuidString
        self.image = image
        self.content = content
        self.timestamp = date
    }
}
