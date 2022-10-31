//
//  SearchedResultList.swift
//  KuringLite
//
//  Created by Jaesung Lee on 2022/06/05.
//
import SwiftUI
import KuringSDK
import KuringCommons

struct SearchedResultList: View {
    @ObservedObject var engine: SearchEngine
    @State var isShowing: Bool = false
    @State var selectedStaff: Staff?
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            switch engine.currentType {
            case .notice:
                ForEach(engine.noticeResult) { notice in
                    NavigationLink {
                        NoticeWebView(notice: notice)
                            .onAppear {
                                HapticManager.shared.createImpact()
                            }
                    } label: {
                        SearchedNoticeRow(notice: notice)
                    }
                }
            case .staff:
                ForEach(engine.staffResult, id: \.email) { staff in
                    SearchedStaffRow(staff: staff)
                        .onTapGesture {
                            HapticManager.shared.createImpact()
                            selectedStaff = staff
                            isShowing.toggle()
                        }
                }
            default:
                EmptyView()
            }
        }
        .sheet(isPresented: $isShowing) {
            SearchedStaffDetailList(staff: $selectedStaff)
        }
        
    }
}
