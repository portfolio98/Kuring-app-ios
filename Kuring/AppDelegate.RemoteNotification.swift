//
//  AppDelegate.RemoteNotification.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/02/14.
//

import UIKit
import KuringSDK
import KuringCommons
import SendbirdChatSDK
import FirebaseMessaging
import SwiftUI

extension AppDelegate {
    func registerForRemoteNotification(of application: UIApplication) {
        // MARK: FirebaseMessaging
        Messaging.messaging().delegate = self
        
        // MARK: UNUserNotificationCenter
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current()
            .requestAuthorization(options: authOptions) { _, _ in }
        application.registerForRemoteNotifications()
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
        SendbirdChat.registerDevicePushToken(deviceToken, unique: false) { registrationStatus, error in
            SendbirdChat.setPushTriggerOption(Kuring.isCustomNotificationEnabled ? .all : .off)
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Logger.error("Failed to register for remote notification with error: \(error.localizedDescription)")
    }
}

// MARK: - FirebaseMessaging
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else {
            Logger.error("No FCM token")
            return
        }

        Kuring.register(fcmToken: fcmToken)
        Logger.debug("FCM token: \(fcmToken)")
    }
}

// MARK: - UNUserNotificationCenter
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // MARK: Analytics
        let userInfo = notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        Logger.debug("???????????????????????? ????????? ???????????????: \(userInfo)")
        
        // MARK: Kuring
        Kuring.userNotificationCenter(
            center,
            willPresent: notification
        )
        
        completionHandler([.banner, .list, .badge, .sound])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // MARK: Analytics
        let userInfo = response.notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        Logger.debug("?????? ????????? ???????????????: \(userInfo)")

        openBanner(with: userInfo)
        
        completionHandler()
    }
    
    /// ????????? ????????? ???, ????????? ???????????????.
    func openBanner(with userInfo: [AnyHashable: Any]) {
        guard let userInfo = userInfo as? [String: Any] else { return }
        guard let navigationController = self.window?.rootViewController as? UINavigationController else { return }
        
        
        guard let notice = Notice(userInfo: userInfo) else {
            Logger.error("\(#function): ?????? ????????? ????????????.")
            return
        }
        
        let view = NoticeWebView(notice: notice)
        let noticeWebVC = UIHostingController(rootView: view)
        navigationController.pushViewController(noticeWebVC, animated: true)
    }
}

// MARK: - UIApplicationDelegate
extension AppDelegate {
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        // ?????? ?????? ??????????????? ????????? ?????? ???????????? ????????????,
        // ??? ????????? ????????? ????????? ?????? ????????? ????????? ????????? ?????? ?????? ????????????
        
        // MARK: Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        Logger.debug("???????????? ?????? ????????? ?????????????????????: \(userInfo)")
        
        // MARK: Kuring
        Kuring.application(
            application,
            didReceiveRemoteNotification: userInfo
        )
        
        completionHandler(.newData)
    }
}

// MARK: - KuringDelegate
extension AppDelegate: KuringDelegate {
    func didReceiveNotification(_ notification: Notice) {
        Logger.debug("Received \(notification.subject)")
    }

    func didReadyToCreateNotificationBanner(title: String, body: String, identifier: String) {
        Logger.debug("did ready to create notification banner - \(title) - \(body) - \(identifier)")
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.badge = nil
        
        let identifier = identifier
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                Logger.error("Failed to show banner: \(error.localizedDescription)")
            }
        }
    }
    
    func didUpdateSubscription(_ subscription: Subscription) {
        Logger.debug("\(subscription.categories)")
    }
}
