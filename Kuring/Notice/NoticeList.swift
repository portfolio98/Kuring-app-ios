//
//  NoticeList.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/29.
//

import SwiftUI
import KuringSDK
import KuringCommons

struct NoticeList: View {
    @EnvironmentObject var listModel: NoticeListModel
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 10) {
                    ForEach(NoticeType.allCases, id: \.self) {
                        NoticeTypeColumn(noticeType: $0)
                    }
                }
                .padding(.leading, 16)
            }
            .frame(height: 48)
            
            ZStack {
                List {
                    ForEach(listModel.currentNotices) { notice in
                        NoticeRow(notice: notice)
                            .listRowSeparator(.hidden)
                            .onAppear {
                                // 마지막에 도달했을 때 공지 더 가져오기
                                if listModel.currentNotices.last == notice {
                                    listModel.load()
                                }
                            }
                    }
                }
                .listStyle(.plain)
                .refreshable { listModel.refresh() }
                .onAppear { listModel.load() }
                
                if listModel.isLoading {
                    LottieView(filename: StringSet.Lottie.loading)
                        .frame(width: 100, height: 100, alignment: .center)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Image("appIconLabel")
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                NavigationLink(
                    destination: NoticeBookmarkList()
                        .environmentObject(listModel)
                ) {
                    Image(systemName: "archivebox")
                        .foregroundColor(ColorSet.Label.primary.color)
                }

                NavigationLink(
                    destination: NotificationList()
                        .environmentObject(listModel)
                ) {
                    Image(systemName: "bell")
                        .foregroundColor(ColorSet.Label.primary.color)
                }
            }
        }
        .environmentObject(listModel)
    }
}
