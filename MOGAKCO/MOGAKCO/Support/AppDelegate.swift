//
//  AppDelegate.swift
//  MOGAKCO
//
//  Created by heerucan on 2022/11/07.
//

import UIKit

import Firebase
import FirebaseMessaging
import IQKeyboardManagerSwift
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in
        }
        application.registerForRemoteNotifications()
        
        return true
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

// MARK: - Firebase FCMtoken 받기 위한 처리

extension AppDelegate: MessagingDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("🔴FCMtoken 검색 실패", error.localizedDescription)
            } else if let token = token {
                print("🟢FCMtoken 검색 성공 ->>>", token)
                UserDefaults.standard.set(token, forKey: Matrix.FCMtoken)
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        print("🟢FCMtoken ->>>", fcmToken)
        let dataDict: [String: String] = ["token": fcmToken]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        // TODO: FCMtoken이 갱신되면 SSAC 서버에게 보낼 것
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }
}
