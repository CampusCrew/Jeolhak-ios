//
//  AppDelegate.swift
//  jeolhak
//
//  Created by 윤대현 on 3/27/25.
//

/**
 앱의 라이프사이클 관리 (앱 시작, 종료 등)
 */

import UIKit
import Firebase
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // MARK: - Notification을 위한 파이어베이스 설정
        
        // Firebase 초기화
        FirebaseApp.configure()
        
        // FCM 델리게이트 위임
        Messaging.messaging().delegate = self
        
        // 알림 델리게이트 위임
        UNUserNotificationCenter.current().delegate = self
        
        // 알림 권한 요청
        requestNotificationPermission()
        
        // APNs 토큰 등록
        application.registerForRemoteNotifications()
        
        // 앱 처음 실행 시 badge 초기화
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        return true
    }
    
    // MARK: - 푸쉬 알림 권한 요청
    private func requestNotificationPermission() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions) { granted, error in
                if granted {
                    print("푸시 알림 권한 허용됨")
                } else {
                    print("푸시 알림 권한 거부됨: \(error?.localizedDescription ?? "")")
                }
            }
    }
    
    // MARK: - 토픽 구독 정의
    private func subscribeToTopic() {
        Messaging.messaging().subscribe(toTopic: "all") { error in
            if let error = error {
                print("all 토픽 구독 실패: \(error.localizedDescription)")
            } else {
                print("all 토픽 구독 성공")
            }
        }
    }
    
    // MARK: - 토픽 구독 해제
    private func unsubscribeFromTopic() {
        Messaging.messaging().unsubscribe(fromTopic: "all") { error in
            if let error = error {
                print("all 토픽 구독 해제 실패: \(error.localizedDescription)")
            } else {
                print("all 토픽 구독 해제 성공")
            }
        }
    }
    
    // MARK: - FCM 토큰 갱신 처리
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM 토큰 갱신: \(fcmToken ?? "없음")")
        
        if let token = fcmToken {
            // 서버에 토큰 전송 (필요시)
            print("FCM 토큰: \(token)")
            
            // FCM 토큰을 받은 후 토픽 구독
            subscribeToTopic()
        }
    }
    
    // MARK: - APNs 토큰 등록 성공/실패
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs 토큰 등록 성공")
        // FCM에 APNs 토큰 설정
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // APNs 토큰 등록 실패
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs 토큰 등록 실패: \(error.localizedDescription)")
    }
    
    // MARK: -포그라운드/백그라운드 관계없이 모든 FCM 메시지 처리
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("FCM 메시지 수신: \(userInfo)")
        
        // 알림 내용 추출
        var body = "새로운 알림"
        if let aps = userInfo["aps"] as? [String: Any],
           let alert = aps["alert"] as? [String: Any],
           let alertBody = alert["body"] as? String {
            body = alertBody
        } else if let directBody = userInfo["body"] as? String {
            body = directBody
        }
        
        // timestamp 추출
        var timestamp = DateFormatter().string(from: Date()) // 기본값: 현재 시간
        if let fcmTimestamp = userInfo["timestamp"] as? String {
            timestamp = fcmTimestamp // "12월 1일" 같은 형태로 바로 사용
        }
        
        // 항상 저장 (
        let notification = NotificationItem(
            image: "bell.fill",
            content: body,
            date: timestamp // 수정된 부분: timestamp 사용
        )
        
        NotificationManager.shared.saveNotification(notification)
        
        let currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
        UIApplication.shared.applicationIconBadgeNumber = currentBadgeCount + 1
        
        print("현재 Badge 개수: \(currentBadgeCount + 1)")
        
        completionHandler(.newData)
    }
    
    // MARK: - 앱이 백그라운드에서 포그라운드로 돌아올 때
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    // MARK: - 앱이 포그라운드로 진입할 때
    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

// MARK: - 푸시 알림 델리게이트
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 앱이 포그라운드에 있을 때 알림 수신 (인앱에서 알림만 표시)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // 포그라운드에서도 알림 표시 (배너로 표시)
        completionHandler([.banner, .sound])
    }
    
    // 사용자가 알림을 탭했을 때 (앱 실행만)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // 알림 탭하면 그냥 앱만 활성화 (특별한 처리 없음)
        // 앱이 꺼져있으면 → 앱 실행
        // 앱이 백그라운드에 있으면 → 앱을 포그라운드로
        // 앱이 이미 실행중이면 → 그대로 유지
        completionHandler()
    }
}
