//
//  KuringApp.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/06/12.
//

import SwiftUI

@main
struct KuringApp: App {
    @StateObject private var listModel = NoticeListModel()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(listModel)
        }
    }
}
