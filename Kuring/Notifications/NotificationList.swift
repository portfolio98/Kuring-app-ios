//
//  NotificationList.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/05/29.
//

import SwiftUI
import KuringSDK
import KuringCommons
import Combine

struct NotificationList: View {
    @StateObject private var listModel = NotificationListModel()
    @State private var isShowingSubscriptionView: Bool = false
    
    var dates: [String] {
        listModel.notifications.keys.compactMap { $0 }.sorted(by: >)
    }
    
    var body: some View {
        ZStack {
            List {
                ForEach(dates, id: \.self) { date in
                    Section(header: NotificationSection(date: date)) {
                        ForEach(listModel.notifications[date] ?? []) { notice in
                            NoticeRow(notice: notice)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button (action: { listModel.delete(notice: notice) }) {
                                        Image(systemName: "trash")
                                    }
                                    .tint(ColorSet.pink.color)
                                }
                        }
                        .listRowSeparator(.hidden)
                        
                    }
                }
                
            }
            .listStyle(.plain)
            
            if listModel.notifications.isEmpty {
                Text(StringSet.MyNotification.empty)
                    .foregroundColor(ColorSet.green.color)
            }
        }
        .onDisappear(perform: listModel.disappear)
        .sheet(isPresented: $isShowingSubscriptionView) {
            SubscriptionView()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("🔔내 알림")
                    .fontWeight(.semibold)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: showSubscriptionView) {
                    Image(systemName: "checklist")
                }
            }
        }
        
    }
    
    func showSubscriptionView() {
        isShowingSubscriptionView = true
    }
    
}
