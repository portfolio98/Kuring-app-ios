//
//  SettingList.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/06/05.
//

import SwiftUI
import KuringSDK
import KuringCommons
import Combine

struct SettingList: View {
    
    @StateObject private var viewModel = SettingListModel()
    
    var body: some View {
        List {
            Section(header: Text("공지 구독")) {
                
                Text("🗞 공지 구독하기")
                    .modifier(SettingTextModifier())
                    .onTapGesture {
                        viewModel.showsSubscription = true
                    }
                
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("🪁기타 알림 받기")
                            .modifier(SettingTextModifier())
                        
                        Text("주요 공지사항, 앱 내 중요 사항")
                            .font(.caption2)
                            .foregroundColor(ColorSet.gray.color)
                    }
                    
                    Spacer()
                    Toggle("", isOn: $viewModel.isOnSwitch)
                        .tint(ColorSet.primary.color)
                }
            }
            
            Section(header: Text("정보")) {
                HStack {
                    Text("🚀 앱 버전")
                        .modifier(SettingTextModifier())
                    Spacer()
                    Text(viewModel.version ?? "")
                        .font(.caption)
                        .foregroundColor(ColorSet.gray.color)
                }
                
                HStack {
                    Text("🌟 새로운 내용")
                        .modifier(SettingTextModifier())
                        .onTapGesture {
                            URLLink.whatsNew.openURL()
                        }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(ColorSet.Label.tertiary.color)
                }
                
                HStack {
                    Text("👍 쿠링 팀")
                        .modifier(SettingTextModifier())
                        .onTapGesture {
                            URLLink.team.openURL()
                        }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(ColorSet.Label.tertiary.color)
                }
                
                HStack {
                    Text("🛡 개인정보 처리방침")
                        .modifier(SettingTextModifier())
                        .onTapGesture {
                            URLLink.privacy.openURL()
                        }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(ColorSet.Label.tertiary.color)
                }
                
                HStack {
                    Text("✅ 서비스 이용약관")
                        .modifier(SettingTextModifier())
                        .onTapGesture {
                            URLLink.terms.openURL()
                        }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(ColorSet.Label.tertiary.color)
                }
                
                HStack {
                    Text("🏛 사용된 오픈소스")
                        .modifier(SettingTextModifier())
                        .onTapGesture {
                            viewModel.showsOpensource.toggle()
                        }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(ColorSet.Label.tertiary.color)
                }
                
            }
            
            Section(header: Text("SNS")) {
                
                HStack {
                    Text("👉 인스타그램")
                        .modifier(SettingTextModifier())
                        .onTapGesture {
                            URLLink.instagram.openURL()
                        }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(ColorSet.Label.tertiary.color)
                }
            }
            
            Section(header: Text("피드백")) {
                HStack {
                    Text("💬 피드백 보내기")
                        .modifier(SettingTextModifier())
                        .onTapGesture {
                            viewModel.showsFeedback.toggle()
                        }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(ColorSet.Label.tertiary.color)
                }
            }
        }
        .listStyle(.insetGrouped)
        .onTapGesture(perform: HapticManager.shared.createImpact)
        .sheet(isPresented: $viewModel.showsSubscription) {
            SubscriptionView()
        }
        .sheet(isPresented: $viewModel.showsFeedback) {
            FeedbackView()
        }
        .sheet(isPresented: $viewModel.showsOpensource) {
            NavigationView {
                OpenSourceView()                
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("👋 더보기")
                    .fontWeight(.semibold)
            }
        }
        .onAppear {
            // FIXME: 토글링 이슈
            // true로 해도 앱 재시작 시, 데이터가 true이지만 토글은 false로 나타나는 현상
            viewModel.isOnSwitch = Kuring.isCustomNotificationEnabled
        }
    }
}

struct SettingList_Previews: PreviewProvider {
    static var previews: some View {
        SettingList()
        SettingList().preferredColorScheme(.dark)
    }
}
