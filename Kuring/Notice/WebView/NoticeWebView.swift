//
//  NoticeWebView.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/05/17.
//

import SwiftUI
import WebKit
import KuringSDK
import KuringCommons
import Lottie


struct NoticeWebView: View {
    @EnvironmentObject var listModel: NoticeListModel
    /// 웹뷰의 로딩 상태
    @State private var isLoading: Bool = true
    @State private var isScrolling: Bool = false
    @State private var item: ActivityItem?
    
    var isBookmarked: Bool {
        listModel.bookmarkNotices.contains(notice)
    }
    
    let notice: Notice
    
    var body: some View {
        ZStack {
            WebView(
                isLoading: $isLoading,
                isScrolling: $isScrolling,
                urlString: notice.urlString,
                noticeID: notice.articleID
            )
            
            if isLoading {
                LottieView(filename: StringSet.Lottie.loading)
                    .frame(width: 100, height: 100, alignment: .center)
            }
            
            VStack(alignment: .center) {
                Spacer()
                
                BannerView()
                    .frame(height: 52)
                    .opacity(isScrolling ? 0 : 1)
            }
            .padding([.leading, .trailing], 18)
            
        }
        .activitySheet($item)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Image("appIconLabel")
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: bookmark) {
                    Image(
                        systemName: isBookmarked
                        ? "bookmark.fill"
                        : "bookmark"
                    )
                }
                .foregroundColor(ColorSet.Label.primary.color)
                
                Button(action: share) {
                    Image(systemName: "square.and.arrow.up")
                }
                .foregroundColor(ColorSet.Label.primary.color)
            }
            
        }
        .onAppear(perform: read)
    }
    
    func bookmark() {
        listModel.bookmark(notice: notice)
    }
    
    func read() {
        listModel.read(notice: notice)
    }
    
    func share() {
        item = ActivityItem(items: notice.urlString)
    }
    
}
