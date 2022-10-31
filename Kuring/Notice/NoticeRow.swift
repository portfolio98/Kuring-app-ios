//
//  NoticeRow.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/18.
//

import SwiftUI
import KuringSDK
import KuringCommons

struct NoticeRow: View {
    @EnvironmentObject var listModel: NoticeListModel
    let notice: Notice
    
    var dateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: Date(timeIntervalSince1970: notice.postedAt))
    }
    
    var isNoticeBookmarked: Bool { listModel.bookmarkNotices.contains(notice) }
    var isNoticeRead: Bool { listModel.readNoticeIDs.contains(notice.id) }
    
    var body: some View {
        ZStack(alignment: .leading) {
            NavigationLink {
                NoticeWebView(notice: notice)
                    .environmentObject(listModel)
            } label: {
                EmptyView()
            }
            .opacity(0)
            
            HStack {
                // MARK: New notice marker
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 8, height: 8)
                    .foregroundColor(
                        isNoticeBookmarked
                        ? ColorSet.green.color
                        : notice.isNew
                        ? notice.isSubscribed ? ColorSet.pink.color : ColorSet.secondaryGray.color
                        : .clear
                    )
                    .padding(.leading, 8)
                
                VStack(alignment: .leading, spacing: 8) {
                    // MARK: Title
                    Text(notice.subject)
                        .foregroundColor(
                            isNoticeRead
                            ? ColorSet.Label.tertiary.color
                            : ColorSet.Label.primary.color
                        )
                        .font(.subheadline)
                        .lineLimit(2)
                    
                    HStack {
                        // MARK: Date
                        Text(dateText)
                            .foregroundColor(
                                isNoticeRead
                                ? ColorSet.Label.tertiary.color
                                : ColorSet.Label.secondary.color
                            )
                            .font(.caption)
                        
                        // MARK: Tag
                        ForEach(notice.tags, id: \.self) {
                            Text($0)
                                .frame(height: 16)
                                .foregroundColor(ColorSet.Background.primary.color)
                                .font(.caption)
                                .padding(.horizontal, 4)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .foregroundColor(ColorSet.secondaryGray.color)
                                }
                            
                        }
                    }
                }
                .padding(.trailing, 24)
            }
        }
        .frame(minHeight: 56)
        .buttonStyle(.plain) // Deselect row
        .swipeActions(edge: .leading) {
            Button (action: bookmark) {
                let isBookmark = listModel.bookmarkNotices.contains(notice)
                Image(systemName: isBookmark ? "bookmark.slash" : "bookmark")
            }
            .tint(ColorSet.green.color)
        }
    }
    
    func bookmark() {
        listModel.bookmark(notice: self.notice)
    }
}
