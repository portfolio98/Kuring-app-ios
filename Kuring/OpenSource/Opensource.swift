//
//  Opensource.swift
//  kuring-uikit-ios
//
//  Created by Hamlit Jason on 2022/02/10.
//

import Foundation

struct Opensource: Hashable {
    var link: String
    var name: String { link.components(separatedBy: "/").last ?? "" }
    var isUsed: Bool
    
    init(link: String, isUsed: Bool = true) {
        self.link = link
        self.isUsed = isUsed
    }
}

extension Opensource {
    static let items: [Opensource] = [
        Opensource(link: "https://github.com/Alamofire/Alamofire", isUsed: false),
        Opensource(link: "https://github.com/ReactiveX/RxSwift", isUsed: false),
        Opensource(link: "https://github.com/RxSwiftCommunity/RxAlamofire", isUsed: false),
        Opensource(link: "https://github.com/RxSwiftCommunity/RxDataSources", isUsed: false),
        Opensource(link: "https://github.com/RxSwiftCommunity/RxGesture", isUsed: false),
        Opensource(link: "https://github.com/airbnb/lottie-ios"),
        Opensource(link: "https://github.com/SnapKit/SnapKit", isUsed: false),
        Opensource(link: "https://github.com/daltoniam/Starscream"),
        Opensource(link: "https://github.com/devxoul/Then", isUsed: false),
        Opensource(link: "https://github.com/KU-Stacks/kuring-ios-commons"),
        Opensource(link: "https://github.com/KU-Stacks/kuring-sdk-ios-spm"),
        Opensource(link: "https://github.com/firebase/firebase-ios-sdk"),
        Opensource(link: "https://github.com/sendbird/sendbird-chat-sdk-ios"),
        Opensource(link: "https://github.com/googleads/swift-package-manager-google-mobile-ads"),
        
    ]
    
    static var list: [Opensource] {
        Opensource.items
            .filter { $0.isUsed }
            .sorted { $0.link.components(separatedBy: "/").last ?? "" < $1.link.components(separatedBy: "/").last ?? "" }
        + Opensource.items
            .filter { !$0.isUsed }
            .sorted { $0.link.components(separatedBy: "/").last ?? "" < $1.link.components(separatedBy: "/").last ?? "" }
    }
}
