//
//  NoticeBookmarkList.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/05/17.
//

import SwiftUI
import KuringSDK
import KuringCommons

struct NoticeBookmarkList: View {
    @EnvironmentObject var listModel: NoticeListModel
    
    var isHideen: Bool {
        !Kuring.noticeBookmark.isEmpty
    }
    
    var body: some View {
        ZStack {
            List {
                ForEach(listModel.bookmarkNotices, id: \.self) { notice in
                    NoticeRow(notice: notice)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button (action: { remove(notice: notice) }) {
                                Image(systemName: "trash")
                            }
                            .tint(ColorSet.pink.color)
                        }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            
            Text(StringSet.Bookmark.empty)
                .foregroundColor(ColorSet.green.color)
                .opacity(isHideen ? 0 : 1)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("🗃공지 보관함")
                    .fontWeight(.semibold)
            }
        }
    }
    
    func remove(notice: Notice) {
        withAnimation {
            listModel.bookmark(notice: notice)
        }
    }
}
