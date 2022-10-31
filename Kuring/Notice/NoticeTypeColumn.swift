//
//  NoticeTypeColumn.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/29.
//

import SwiftUI
import KuringSDK
import KuringCommons

struct NoticeTypeColumn: View {
    @EnvironmentObject var listModel: NoticeListModel
    let noticeType: NoticeType
    
    var body: some View {
        Text(noticeType.koreanValue)
            .font(.subheadline)
            .foregroundColor(
                noticeType == listModel.currentType
                ? ColorSet.Label.green.color
                : ColorSet.Label.primary.color
            )
            .padding(.horizontal, 16)
            .frame(height: 36)
            .background {
                RoundedRectangle(cornerRadius: 18)
                    .foregroundColor(
                        noticeType == listModel.currentType
                        ? ColorSet.secondaryGreen.color
                        : Color.clear
                    )
            }
            .onTapGesture {
                listModel.currentType = noticeType
            }
    }
}
