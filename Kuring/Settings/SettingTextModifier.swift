//
//  SettingTextModifier.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/06/05.
//

import SwiftUI
import KuringCommons

struct SettingTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            content
                .font(.caption)
                .foregroundColor(ColorSet.Label.primary.color)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
        }
    }
}

