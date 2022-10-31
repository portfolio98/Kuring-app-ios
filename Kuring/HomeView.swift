//
//  HomeView.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/29.
//

import SwiftUI
import KuringCommons

struct HomeView: View {
    var body: some View {
        TabView {
            NavigationView {
                NoticeList()
            }
            .accentColor(ColorSet.Label.primary.color)
            .tabItem {
                Label("공지사항", systemImage: "list.dash")
            }
            
            SearchView()
                .tabItem {
                    Label("검색", systemImage: "magnifyingglass")
                }
            
            CampusHomeView()
                .tabItem {
                    Label("쿠링캠퍼스", systemImage: "building.columns")
                }
            
            SettingList()
                .tabItem {
                    Label("더보기", systemImage: "ellipsis")
                }
            
        }
        .accentColor(ColorSet.primary.color)
    }
}
