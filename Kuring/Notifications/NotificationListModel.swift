//
//  NotificationListModel.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/06/04.
//

import SwiftUI
import KuringSDK

class NotificationListModel: ObservableObject {
    @Published var notifications: [String: [Notice]] = Kuring.notifications
    
    init() {
        Kuring.addDelegate(self, forKey: String(describing: self))
    }
    
    func disappear() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        Kuring.notifications.values.flatMap { $0 }.forEach { notifications in
            notifications.isNew = false
        }
    }
    
    func delete(notice: Notice) {
        Kuring.removeNotification(notice)
        withAnimation {
            notifications = Kuring.notifications            
        }
    }
}

extension NotificationListModel: KuringDelegate {
    func didReceiveNotification(_ notification: Notice) {
        notifications = Kuring.notifications
    }
    
    func didReadyToCreateNotificationBanner(title: String, body: String, identifier: String) { }
    
    func didUpdateSubscription(_ subscription: KuringSDK.Subscription) {
        notifications = Kuring.notifications
    }
}
