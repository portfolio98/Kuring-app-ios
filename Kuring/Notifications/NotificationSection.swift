//
//  NotificationSection.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/06/04.
//

import SwiftUI
import KuringCommons

struct NotificationSection: View {
    let date: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(date)
                .frame(height: 24)
                .font(.subheadline)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(ColorSet.gray.color, lineWidth: 1)
                )
            Spacer()
        }
    }
}
