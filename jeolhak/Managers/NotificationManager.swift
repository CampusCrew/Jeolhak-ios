//
//  NotificationManager.swift
//  jeolhak
//
//  Created by 윤대현 on 6/1/25.
//

import UIKit

// MARK: - 알림 매니저 (싱글톤)
class NotificationManager {
    static let shared = NotificationManager()
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    private let notificationsKey = "SavedNotifications"
    
    // 알림 저장
    func saveNotification(_ notification: NotificationItem) {
        var notifications = loadNotifications()
        notifications.append(notification)
        
        // 최대 100개까지만 저장 (메모리 관리)
        if notifications.count > 100 {
            notifications = Array(notifications.suffix(100))
        }
        
        if let data = try? JSONEncoder().encode(notifications) {
            userDefaults.set(data, forKey: notificationsKey)
        }
        
        // 실시간으로 UI 업데이트
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: .notificationListUpdated,
                object: notification
            )
        }
    }
    
    // 알림 불러오기
    func loadNotifications() -> [NotificationItem] {
        guard let data = userDefaults.data(forKey: notificationsKey),
              let notifications = try? JSONDecoder().decode([NotificationItem].self, from: data) else {
            return []
        }
        return notifications
    }
    
    // 모든 알림 삭제
    func clearAllNotifications() {
        userDefaults.removeObject(forKey: notificationsKey)
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .notificationListCleared, object: nil)
        }
    }
}
