//
//  View.Kuring.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/03/22.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    /**
     관련`ActivityItem`이 존재할 때, 해당하는 activity sheet를 보여줍니다.
     
     - Parameters:
       - item: activity에 사용할 아이템입니다.
       - onComplete: sheet가 dimiss되었을 때, 결과과 호출됩니다.
     */
    func activitySheet(_ item: Binding<ActivityItem?>, permittedArrowDirections: UIPopoverArrowDirection = .any, onComplete: UIActivityViewController.CompletionWithItemsHandler? = nil) -> some View {
        background(ActivityView(item: item, permittedArrowDirections: permittedArrowDirections, onComplete: onComplete))
    }
}

// MARK: - For iOS 14
struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

enum HorizontalEdge {
    case top, bottom
}

extension EdgeInsets {
    init(_ edge: HorizontalEdge, _ inset: CGFloat) {
        switch edge {
        case .top: self.init(top: inset, leading: 0, bottom: 0, trailing: 0)
        case .bottom: self.init(top: 0, leading: 0, bottom: inset, trailing: 0)
        }
    }
    
    func uiEdgeInsets(in direction: LayoutDirection) -> UIEdgeInsets {
        if direction == .rightToLeft {
            return UIEdgeInsets(top: top, left: leading, bottom: bottom, right: trailing)
        } else {
            return UIEdgeInsets(top: top, left: leading, bottom: bottom, right: trailing)
        }
    }
}

struct AdditionalSafeAreaInsetsView<Content: View>: UIViewControllerRepresentable {
    let insets: EdgeInsets
    @ViewBuilder var content: () -> Content
    
    @Environment(\.layoutDirection) private var layoutDirection
    
    func makeUIViewController(context: Context) -> UIHostingController<Content> {
        let viewController = UIHostingController(rootView: content())
        viewController.additionalSafeAreaInsets = insets.uiEdgeInsets(in: layoutDirection)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIHostingController<Content>, context: Context) {
        uiViewController.additionalSafeAreaInsets = insets.uiEdgeInsets(in: layoutDirection)
        uiViewController.rootView = content()
    }
}

struct SafeAreaInsetView<Base: View, Bar: View>: View {
    let edge: HorizontalEdge
    let base: Base
    @ViewBuilder let content: () -> Bar
    
    @State private var barHeight: CGFloat = 0
    
    var body: some View {
        let alignment: Alignment = {
            switch edge {
            case .top: return .top
            case .bottom: return .bottom
            }
        }()
        
        AdditionalSafeAreaInsetsView(insets: EdgeInsets(edge, barHeight)) {
            base
        }
        .overlay(
            content()
                .background(
                    GeometryReader { proxy in
                        Color.clear.preference(key: HeightPreferenceKey.self, value: proxy.size.height)
                    }
                    .onPreferenceChange(HeightPreferenceKey.self) { value in
                        self.barHeight = value
                    }
                ),
            alignment: alignment
        )
    }
}

extension View {
    func safeAreaInset<Content: View>(
        edge: HorizontalEdge,
        @ViewBuilder _ content: @escaping () -> Content
    ) -> some View {
        SafeAreaInsetView(edge: edge, base: self, content: content)
    }
}
